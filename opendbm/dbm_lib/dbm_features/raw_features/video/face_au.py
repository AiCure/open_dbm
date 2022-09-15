"""
file_name: face_au.py
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

face_au_dir = "facial/face_au"
csv_ext = "_facau.csv"


def extract_col_nm_au(cols):
    """
    Extract action unit (au) column names from openface output (csv)
    Args:
        cols: column names from open face output (csv)
    Returns:
        (list) list of au column names
    """
    # cols_lmk = []
    au_tags = " AU"
    cols_au = [c for c in cols if au_tags in c]
    return cols_au


def au_col_nm_map(df):
    """
    Rename dataframe action unit column names to match functional specifications v1.0
    Args:
        df: dataframe
    Returns:
        dataframe with mapped variables
    """
    dict_au_cols = {}
    for col in list(df):
        if " AU" in col:
            idx = col.rfind("_")
            if idx > -1:
                au_id = col[idx - 2 : idx]
                if "_r" in col:
                    dict_au_cols[col] = "fac_AU" + au_id + "int"
                if "_c" in col:
                    dict_au_cols[col] = "fac_AU" + au_id + "pres"
    df.rename(columns=dict_au_cols, inplace=True)
    return df


def run_face_au(video_uri, out_dir, f_cfg, save=True):
    """
    Processing all patient's for fetching action units
    ---------------
    ---------------
    Args:
        video_uri: video path; f_cfg: face config object
        out_dir: (str) Output directory for processed output
    """
    try:

        # Baseline logic
        ConfigFaceReader()
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)

        of_csv_path = glob.glob(join(out_loc, fl_name + "_openface/*.csv"))
        if len(of_csv_path) > 0:

            df_of = pd.read_csv(of_csv_path[0])
            df_au = df_of[extract_col_nm_au(df_of)]
            df_au = df_au.copy()

            df_au["frame"] = df_of["frame"]
            df_au["face_id"] = df_of[" face_id"]
            df_au["timestamp"] = df_of[" timestamp"]
            df_au["confidence"] = df_of[" confidence"]
            df_au["success"] = df_of[" success"]

            df_au = au_col_nm_map(df_au)
            df_au["dbm_master_url"] = video_uri
            if save:
                logger.info(
                    "Processing Output file {} ".format(os.path.join(out_loc, fl_name))
                )
                ut.save_output(df_au, out_loc, fl_name, face_au_dir, csv_ext)
            return df_au

    except Exception as e:
        e
        logger.error("Failed to process video file")
