"""
file_name: process_features
project_name: DBM
created: 2020-20-07
"""

import glob
import logging
import os

import numpy as np
import pandas as pd

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def batch_open_face(
    filepaths, video_url, input_dir, out_dir, of_path, video_tracking=False
):
    """Computes open_face features for the files in filepaths

    Args:
    -----
        filepaths: (itreable[str])
        video_tracking: To specify whether openface's video tracking module (FaceLandmarkVid)
                    is being used or the default (FeatureExtract)
        video_url: Raw video location on S3 bucket
        input_dir: Path to the input videos
        out_dir: Path to the processed output
        of_path: OpenFace source code path

    Returns:
    --------
        (itreable[str]) list of .csv files
    """
    if video_tracking:
        suffix = "_openface_lmk"
    else:
        suffix = "_openface"

    csv_files = []

    for fp in filepaths:
        try:

            _, out_loc, fl_name = ut.filter_path(video_url, out_dir)
            full_f_name = fl_name + suffix
            output_directory = os.path.join(out_loc, full_f_name)

            if video_tracking and not os.path.exists(os.path.abspath(output_directory)):
                os.makedirs(os.path.abspath(output_directory))
            csv_files.append(
                ut.compute_open_face_features(fp, output_directory, of_path)
            )

        except Exception as e:
            logger.error("Failed to run OpenFace on {}\n{}".format(fp, e))

    return csv_files


def process_open_face(
    video_uri, input_dir, out_dir, of_path, dbm_group, video_tracking
):
    """
    Processing all patient's for fetching emotion expressivity
    -------------------
    -------------------
    Args:
        video_uri: video path; input_dir : input directory for video's; dbm_group: feature group
        out_dir: (str) Output directory for processed output; of_path: OpenFace source code path

    """
    try:

        if dbm_group is not None:
            check_group = [
                "facial",
                "movement",
            ]  # add group here: if you want to use openface output for raw variable calculation
            check_val = bool(len({*check_group} & {*dbm_group}))
            if not check_val:
                return

        filepaths = [video_uri]
        batch_open_face(
            filepaths, video_uri, input_dir, out_dir, of_path, video_tracking
        )

    except Exception as e:
        e
        logger.error("Failed to process video file")
