"""
file_name: face_landmark
project_name: DBM
created: 2020-20-07
"""

import datetime
import glob
import logging
import os
from os.path import join

import numpy as np
import pandas as pd

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut
from opendbm.dbm_lib.dbm_features.raw_features.util import video_util as vu

from .face_config.face_config_reader import ConfigFaceReader

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

face_lmk_dir = "facial/face_landmark"
csv_ext = "_faclmk.csv"


def extract_col_nm_lmk(cols):
    """
    Extract landmark column names from openface output (csv)
    Args:
        cols: column names from open face output (csv)
    Returns:
        (list) list of landmark column names
    """
    cols_lmk = []
    lmk_tags = [" y_", " x_", " X_", " Y_", " Z_"]
    for c in cols:
        if any(t in c for t in lmk_tags):
            cols_lmk.append(c)
    return cols_lmk


def lmk_col_nm_map(df):
    """
    Rename dataframe landmark column names to match functional specifications v1.0
    Args:
        df: dataframe
    """
    dict_lmk_cols = {}
    for col in list(df):
        idx = col.rfind("_") + 1
        if idx > 0:
            lmk_id = col[idx:] if len(col[idx:]) > 1 else "0" + col[idx:]
            if " y_" in col:
                dict_lmk_cols[col] = "fac_LMK" + lmk_id + "r"
            if " x_" in col:
                dict_lmk_cols[col] = "fac_LMK" + lmk_id + "c"
            if " X_" in col:
                dict_lmk_cols[col] = "fac_LMK" + lmk_id + "X"
            if " Y_" in col:
                dict_lmk_cols[col] = "fac_LMK" + lmk_id + "Y"
            if " Z_" in col:
                dict_lmk_cols[col] = "fac_LMK" + lmk_id + "Z"
    df.rename(columns=dict_lmk_cols, inplace=True)
    return df


def add_disp_3D(df):
    """
    Add 3D displacement for each landmark
    Args:
        df: landmark dataframe
    """
    df = df.sort_values(by=["frame"], ascending=False)
    cols_lmk = [col for col in list(df) if "fac_LMK" in col]
    df_t = df[cols_lmk]
    df_diff = df_t.diff()
    df_diff = df_diff.pow(2)

    tot_lmk = 68  # 68 landmark model
    for i in range(tot_lmk):
        lmk_id = "{:02d}".format(i)
        df["fac_LMK" + lmk_id + "disp"] = (
            df_diff[
                [
                    "fac_LMK" + lmk_id + "X",
                    "fac_LMK" + lmk_id + "Y",
                    "fac_LMK" + lmk_id + "Z",
                ]
            ]
            .sum(axis=1)
            .apply(np.sqrt)
        )

    return df


def run_face_landmark(video_uri, out_dir, f_cfg, save=True):
    """
    Processing all patient's for fetching facial landmarks
    ---------------
    ---------------
    Args:
        video_uri: video path;  f_cfg: raw variable config object
        out_dir: (str) Output directory for processed output
    """
    try:

        # Baseline logic
        ConfigFaceReader()
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)

        of_csv_path = glob.glob(join(out_loc, fl_name + "_openface/*.csv"))
        if len(of_csv_path) > 0:

            df_of = pd.read_csv(of_csv_path[0])
            df_lmk = df_of[extract_col_nm_lmk(df_of)]
            df_lmk = df_lmk.copy()

            df_lmk["frame"] = df_of["frame"]
            df_lmk["face_id"] = df_of[" face_id"]
            df_lmk["timestamp"] = df_of[" timestamp"]
            df_lmk["confidence"] = df_of[" confidence"]
            df_lmk["success"] = df_of[" success"]

            df_lmk = lmk_col_nm_map(df_lmk)
            df_lmk = add_disp_3D(df_lmk)
            df_lmk["dbm_master_url"] = video_uri

            if save:
                logger.info("Processing Output file {} ".format(join(out_loc, fl_name)))
                ut.save_output(df_lmk, out_loc, fl_name, face_lmk_dir, csv_ext)
        return df_lmk

    except Exception as e:
        e
        logger.error("Failed to process video file")
