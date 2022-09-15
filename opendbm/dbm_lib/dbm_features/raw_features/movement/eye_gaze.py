"""
file_name: eye_gaze
project_name: DBM
created: 2020-30-11
"""

import glob
import logging
import os
from os.path import join

import numpy as np
import pandas as pd
from scipy.spatial import distance

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

eye_pose_dir = "movement/gaze"
eye_pose_ext = "_eyegaze.csv"


def eye_motion_df(l_disp, r_disp, error_list, r_config):
    """
    Generating eye movement dataframe

    Args:
        error_list:
        l_disp: displacement list(left eye);
        r_disp: displacement list(right eye)
        r_config: raw variable config file object

    Reutrns:
        Final eye displacement dataframe
    """
    df_eye_left = pd.DataFrame(l_disp, columns=[r_config.mov_eleft_disp])
    df_eye_right = pd.DataFrame(r_disp, columns=[r_config.mov_eright_disp])

    df_eye_motion = pd.concat([df_eye_left, df_eye_right], axis=1, sort=False)
    df_eye_motion[r_config.err_reason] = error_list
    return df_eye_motion


def filter_motion(df_of, df_disp, col_l, col_r, r_config):
    """
    Filtering final eye movement dataframe

    Args:
        df_of: Openface raw out dataframe;
        df_disp: displacement dataframe
        col_r: right eye column
        col_l: left eye column;
        r_config: raw variable config file object
    """

    df_of = df_of[col_l + col_r + [" confidence"]].copy()
    df_of.loc[(df_of[" confidence"].astype(float) < 0.8), col_l + col_r] = np.nan

    df_filter = df_of[col_l + col_r]
    df_filter.columns = [
        r_config.mov_leye_x,
        r_config.mov_leye_y,
        r_config.mov_leye_z,
        r_config.mov_reye_x,
        r_config.mov_reye_y,
        r_config.mov_reye_z,
    ]

    df_motion = pd.concat([df_filter, df_disp], axis=1, sort=False)
    return df_motion


def eye_disp(of_results, col, r_config):
    """
    Computing head velocity frame by frame

    Args:
        of_results: Openface raw out dataframe
        col: col of eye_disp
        r_config: Face config file object

    Reutrns:
        Final head velocity frame by frame output
    """
    distance_list = []
    error_list = []

    of_results = of_results[col + [" confidence"]]
    for index, row in of_results.iterrows():
        dst = np.nan

        if index == 0 or float(row[" confidence"]) < 0.8:  # Threshold < 0.8
            distance_list.append(dst)

            if float(row[" confidence"]) < 0.8:
                error_list.append("confidence less than 80%")

            else:
                error_list.append("Pass")
            continue

        if index > 0:

            point_x = (
                of_results[col[0]][index - 1],
                of_results[col[1]][index - 1],
                of_results[col[2]][index - 1],
            )
            point_y = (row[col[0]], row[col[1]], row[col[2]])
            try:
                dst = distance.euclidean(point_x, point_y)
            except Exception as e:
                logger.info("Exception on eye_disp method", e)
                pass

            distance_list.append(abs(dst))
            error_list.append("Pass")

    return distance_list, error_list


def calc_eye_mov(video_uri, df_of, out_loc, fl_name, r_config, save=True):
    """
    Computing eye motion variables
    Args:
        video_uri: self explanatory
        df_of: Openface dataframe
        out_loc: Output path for saving output csv's
        fl_name: file name for output csv
        r_config: raw variable config file object
        save: whether to save result to csv or not

    """

    col_l = [" gaze_0_x", " gaze_0_y", " gaze_0_z"]
    col_r = [" gaze_1_x", " gaze_1_y", " gaze_1_z"]

    gazel_disp, err_l = eye_disp(df_of, col_l, r_config)
    gazer_disp, err_r = eye_disp(df_of, col_r, r_config)

    df_disp = eye_motion_df(gazel_disp, gazer_disp, err_l, r_config)
    df_disp["dbm_master_url"] = video_uri

    df_motion = filter_motion(df_of, df_disp, col_l, col_r, r_config)
    if save:
        ut.save_output(df_motion, out_loc, fl_name, eye_pose_dir, eye_pose_ext)
    return df_motion


def run_eye_gaze(video_uri, out_dir, r_config, save=True):
    """
    Processing all patient's for getting eye movement artifacts
    --------------------------------
    --------------------------------
    Args:
        video_uri: video path; input_dir : input directory for video's
        out_dir: (str) Output directory for processed output;
        r_config: raw variable config object
        save: whether to save result to csv or not
    """
    try:

        # filtering path to generate input & output path
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)
        of_csv_path = glob.glob(join(out_loc, fl_name + "_openface/*.csv"))

        if len(of_csv_path) > 0:
            of_csv = of_csv_path[0]
            df_of = pd.read_csv(of_csv)

            logger.info(
                "Processing Output file {} ".format(os.path.join(out_loc, fl_name))
            )
            df_motion = calc_eye_mov(
                video_uri, df_of, out_loc, fl_name, r_config, save=save
            )
            return df_motion

    except Exception as e:
        logger.error("Failed to process video file", e)
