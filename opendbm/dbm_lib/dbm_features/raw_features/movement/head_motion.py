"""
file_name: head_mov
project_name: DBM
created: 2020-20-07
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

h_mov_dir = "movement/head_movement"
h_pose_dir = "movement/head_pose"
h_mov_ext = "_headmov.csv"
h_pose_ext = "_headpose.csv"


def head_pose_dist(of_results):
    """
    Computing head pose distance frame by frame

    Args:
        of_results: Openface raw out dataframe

    Returns:
        Final head pose distance frame by frame output
    """
    distance_list = []
    error_list = []
    for index, row in of_results.iterrows():
        dst = np.nan

        if index == 0 or float(row[" confidence"]) < 0.2:  # Threshold < 0.2
            distance_list.append(dst)

            if float(row[" confidence"]) < 0.2:
                error_list.append("confidence less than 20%")

            else:
                error_list.append("Pass")
            continue

        if index > 0:

            point_x = (
                of_results[" pose_Rx"][index - 1],
                of_results[" pose_Ry"][index - 1],
                of_results[" pose_Rz"][index - 1],
            )
            point_y = (row[" pose_Rx"], row[" pose_Ry"], row[" pose_Rz"])
            try:
                dst = distance.euclidean(point_x, point_y)
            except Exception as e:
                logger.info("Exception met on head_pose_dist method", e)
                pass
            distance_list.append(abs(dst))
            error_list.append("Pass")
    return distance_list, error_list


def head_pose(of_results, r_config):
    """
    Generating head pose estimation dataframe

    Args:
        of_results: openface results as dataframe
        r_config: raw variable config file object

    Returns:
        Final head pose estimation dataframe
    """
    pose_dist_list, error_list = head_pose_dist(of_results)
    of_results = of_results.copy()
    of_results.loc[
        (of_results[" confidence"].astype(float) < 0.2),
        [" pose_Rx", " pose_Ry", " pose_Rz"],
    ] = np.nan
    pose_of = of_results[[" pose_Rx", " pose_Ry", " pose_Rz"]]
    pose_of.columns = [
        r_config.mov_Hpose_Pitch,
        r_config.mov_Hpose_Yaw,
        r_config.mov_Hpose_Roll,
    ]
    pose_of = pose_of.copy()
    pose_of[r_config.mov_Hpose_Dist] = pose_dist_list
    pose_of[r_config.err_reason] = error_list

    return pose_of


def head_motion_df(distance_val, error_list, r_config):
    """
    Generating head movement dataframe

    Args:
        distance_val: distance list
        error_list: Error reason
        r_config: raw variable config file object

    Returns:
        Final head velocity dataframe
    """
    head_motion = r_config.head_vel
    df_head_motion = pd.DataFrame(distance_val, columns=[head_motion])
    df_head_motion["Frames"] = df_head_motion.index

    new_df_intensity = df_head_motion[["Frames", head_motion]].copy()
    new_df_intensity[r_config.err_reason] = error_list

    return new_df_intensity


def head_vel(of_results, r_config):
    """
    Computing head velocity frame by frame

    Args:
        of_results: Openface raw out dataframe
        r_config: Face config file object

    Returns:
        Final head velocity frame by frame output
    """
    distance_list = []
    error_list = []
    for index, row in of_results.iterrows():
        dst = np.nan

        if index == 0 or float(row[" confidence"]) < 0.2:  # Threshold < 0.2
            distance_list.append(dst)

            if float(row[" confidence"]) < 0.2:
                error_list.append("confidence less than 20%")

            else:
                error_list.append("Pass")
            continue

        if index > 0:

            point_x = (
                of_results[" pose_Tx"][index - 1],
                of_results[" pose_Ty"][index - 1],
                of_results[" pose_Tz"][index - 1],
            )
            point_y = (row[" pose_Tx"], row[" pose_Ty"], row[" pose_Tz"])
            try:
                dst = distance.euclidean(point_x, point_y)
            except Exception as e:
                logger.info("Exception met on head_vel method", e)
                pass

            if abs(dst) > 200:
                dst = np.nan
                error_list.append("Out of range")

            else:
                error_list.append("Pass")
            distance_list.append(dst)
    df_velocity = head_motion_df(distance_list, error_list, r_config)

    return df_velocity


def calc_head_mov(video_uri, df_of, out_loc, fl_name, r_config, save=True):
    """
    Computing head motion and head pose variables
    Args:
        video_uri: video path
        df_of: Openface dataframe
        out_loc: Output path for saving output csv's
        fl_name: file name for output csv
        r_config: raw variable config file object
        save: whether to save result to csv or not

    """

    col = [
        " confidence",
        " pose_Rx",
        " pose_Ry",
        " pose_Rz",
        " pose_Tx",
        " pose_Ty",
        " pose_Tz",
    ]
    df_of = df_of[col]

    df_hmotion = head_vel(df_of, r_config)
    df_hmotion["dbm_master_url"] = video_uri

    df_pose = head_pose(df_of, r_config)
    df_pose["dbm_master_url"] = video_uri

    if save:
        ut.save_output(df_hmotion, out_loc, fl_name, h_mov_dir, h_mov_ext)
        ut.save_output(df_pose, out_loc, fl_name, h_pose_dir, h_pose_ext)

    df_mot = pd.concat([df_hmotion[["Frames", "mov_headvel"]], df_pose], axis=1)
    return df_mot


def run_head_movement(video_uri, out_dir, r_config):
    """
    Processing all patient's for getting movement artifacts for cdx_analysis workflow
    --------------------------------
    --------------------------------
    Args:
        video_uri: video path; input_dir : input directory for video's
        out_dir: (str) Output directory for processed output;
        r_config: raw variable config object
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

            df_mot = calc_head_mov(video_uri, df_of, out_loc, fl_name, r_config)
            return df_mot

    except Exception as e:
        logger.error("Failed to process video file", e)
