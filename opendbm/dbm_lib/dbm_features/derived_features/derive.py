"""
file_name: derive
project_name: DBM
created: 2020-20-07
"""

import glob
import logging
import os
from datetime import datetime

import numpy as np
import pandas as pd

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def dict_to_df(feature_dict, file):
    """
    Converting ditionary to dataframe
    """
    final_dict = {k: v for d in feature_dict for k, v in d.items()}

    feature_df = pd.DataFrame([final_dict])
    feature_df["Filename"] = file

    return feature_df


def save_derive_output(df_list, out_loc):
    """
    Saving derive variable output
    """
    try:
        if len(df_list) > 0:
            df = df_list[0]

            file_name = os.path.join(out_loc, "derived_output.csv")
            if not os.path.exists(out_loc):

                os.makedirs(out_loc)
            df.to_csv(file_name, index=False)

    except Exception as e:
        e
        logger.error("Failed to save derived variable csv")


def feature_output(df_fea, exp_var, cal_type):
    """
    Computing mean value of dataframe columns
    """
    exp_val = np.nan
    try:

        df_ = df_fea[exp_var].astype(float).copy()
        df_ = df_.dropna().reset_index(drop=True)

        if len(df_) > 0:

            if cal_type == "mean":
                exp_val = df_.mean(axis=0, skipna=True)

            elif cal_type == "std":
                exp_val = df_.std(axis=0, skipna=True)

            elif cal_type == "count":  # use case for eye blink
                exp_var = "mov_blink"
                exp_val = (len(df_) / df_[0]) * 60

            elif cal_type == "pct":
                if len(df_) > 0:
                    exp_val = len(df_[df_ > 0]) / len(df_)

            elif cal_type == "range":
                exp_val = max(df_) - min(df_)

    except Exception as e:
        logger.error("Failed to compute calculation: {}".format(e))
        pass

    var_name = exp_var + "_" + cal_type
    exp_val = float("{0:.4f}".format(exp_val))
    var_val = (var_name, exp_val)

    return var_val


def cal_type_dict(var_df, raw_df, d_cfg_Obj, r_cfg_Obj):

    var_name = str(var_df["var_id"])

    # fetching key based on variable name from raw config
    var_key = list(r_cfg_Obj.keys())[list(r_cfg_Obj.values()).index(var_name)]
    cal_type = d_cfg_Obj[var_key]  # calculation type from config

    var_val = [feature_output(raw_df, var_name, cal) for cal in cal_type]
    var_val_dict = dict(var_val)

    return var_val_dict


def compute_feature(raw_df, var_cols, d_cfg_Obj, r_cfg_Obj):
    """
    Computing features
    """
    # Variable data frame for each feature group
    var_df = pd.DataFrame(var_cols, columns=["var_id"])
    feature_dict = {}

    if len(raw_df) > 0:
        feature_dict = var_df.apply(
            cal_type_dict,
            args=(
                raw_df,
                d_cfg_Obj,
                r_cfg_Obj,
            ),
            axis=1,
        )

    return feature_dict


def calc_derive(input_file, input_dir, r_cfg_Obj, d_cfg_Obj, feature):
    """
    Calculating derived variable
    """
    df_list = []
    df = pd.DataFrame()
    for file in input_file:

        file_name, _ = os.path.splitext(os.path.basename(file))
        input_loc = os.path.join(input_dir, file_name)

        var_cols = [r_cfg_Obj[x] for x in d_cfg_Obj[feature]]

        fea_loc = d_cfg_Obj[feature + "_LOC"]
        fea_res = glob.glob(os.path.join(input_loc, "*/*/*" + fea_loc + ".csv"))

        if len(fea_res) > 0:
            raw_df = pd.read_csv(fea_res[0])
            feature_dict = compute_feature(raw_df, var_cols, d_cfg_Obj, r_cfg_Obj)

            if len(feature_dict) > 0:
                feature_df = dict_to_df(feature_dict, file)
                df_list.append(feature_df)

    if len(df_list) > 0:
        df = pd.concat(df_list, ignore_index=True)
    return df


def run_derive(input_file, input_dir, output_dir, r_config, d_config):
    """
    Processing derived variable
    """
    d_cfg_Obj = d_config.base_derive["derive_feature"]
    r_cfg_Obj = r_config.base_raw["raw_feature"]
    feature_group = d_cfg_Obj["FEATURE_GROUP"]

    # Iterating over feature group
    df_list = []
    for feature in feature_group:
        try:

            df_fea = calc_derive(input_file, input_dir, r_cfg_Obj, d_cfg_Obj, feature)
            if len(df_fea) > 0:

                if len(df_list) == 0:
                    df_list.append(df_fea)
                else:
                    result = pd.merge(df_list[0], df_fea, how="outer", on=["Filename"])
                    df_list = [result]

        except Exception as e:
            e
            logger.error("Failed to process derived variables {}".format(feature))

    logger.info("Saving derived variable output...")
    save_derive_output(df_list, output_dir)
