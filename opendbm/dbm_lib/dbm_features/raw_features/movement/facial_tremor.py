import glob
import json
import logging
import os
import pickle
import re
import sys
from os.path import join

import cv2
import numpy as np
import numpy.ma as ma
import pandas as pd

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

from ..util.math_util import calc_displacement_vec

DBMLIB_PATH = os.path.dirname(__file__)

DBMLIB_FTREMOR_CONFIG = os.path.abspath(
    os.path.join(DBMLIB_PATH, "../../../../resources/features/facial/config.json")
)


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

ft_dir = "movement/facial_tremor"
csv_ext = "_fac_tremor.csv"
model_ext = "_fac_model.csv"
fac_features_ext = "_fac_features.csv"


def compute_features(out_dir, df_of, r_config):
    """Computes features

    Returns: features in vector format
    """
    config = json.loads(open(DBMLIB_FTREMOR_CONFIG, "r").read())

    pattern_x = re.compile(r"l\d+_x")
    pattern_y = re.compile(r"l\d+_y")

    # assumption: distance of face to camera remains at roughly static

    # logic break
    landmark_columns = []
    for col in df_of.columns:
        if pattern_x.match(col) or pattern_y.match(col):
            landmark_columns.append(col)

    df_of = df_of[(df_of[landmark_columns] != 0).any(axis=1)]
    df_of.reset_index(inplace=True)

    num_frames = len(df_of)
    logger.info("Number of frames to be processed: {}".format(str(num_frames)))
    landmarks = config["landmarks"]

    try:
        if num_frames == 0:
            error_reason = "No frames with visible face."
            logger.error(error_reason)
            return empty_frame(landmarks, r_config, error_reason)

        #             if num_frames < 60:
        #                 error_reason = 'Number of frames with visible face < 60. Video too short'
        #                 logger.error(error_reason)
        #                 return empty_frame(landmarks, f_cfg, error_reason)

        first_row = df_of.iloc[0]

        facew = abs(
            first_row[config["face_width_left"]] - first_row[config["face_width_right"]]
        )
        faceh = abs(
            first_row[config["face_height_left"]]
            - first_row[config["face_height_right"]]
        )

        if facew == 0 or faceh == 0:
            error_reason = "face width or height = 0. Check landmark values"
            logger.error(error_reason)
            return empty_frame(landmarks, r_config)

        fac_disp = calc_displacement_vec(df_of, landmarks, num_frames)

        # if verbose:
        # logger.info("Displacement output: {}".format(str(fac_disp)))

        fac_disp_median = np.median(fac_disp, axis=1)
        fac_disp_mean = np.mean(fac_disp, axis=1)

        if len(fac_disp.shape) != 2:
            error_reason = "fac_disp is not 2D. smth went wrong with disp calc"
            logger.error(error_reason)
            return empty_frame(landmarks, r_config, error_reason)

        if len(fac_disp[0]) <= 1:
            error_reason = "Video too short. smth went wrong with disp calc"
            logger.error(error_reason)
            return empty_frame(landmarks, r_config, error_reason)

        fac_corr_mat = np.corrcoef(fac_disp, rowvar=True)
        # extract relevant row from cov matrix
        ref_lmk_index = [
            i for i, lmk in enumerate(landmarks) if config["ref_lmk"] == lmk
        ]
        fac_corr = fac_corr_mat[ref_lmk_index][0]

        fac_area = config["ref_area"] / (facew * faceh)

        # if verbose:
        #     logger.info("Face area: {}".format(fac_area))
        #     logger.info("Face Displacement Median: {}".format(str(fac_disp_median)))
        #     logger.info("Face Displacement Mean: {}".format(str(fac_disp_mean)))

        fac_features1 = np.multiply(fac_area * fac_disp_median, (1.0 - fac_corr))
        fac_features2 = np.multiply(fac_area * fac_disp_mean, (1.0 - fac_corr))

        #         base_fac_features = np.dot(fac_area * fac_disp_median, (1. - fac_corr))

        fac_features_dict = {}
        for i, landmark in enumerate(landmarks):
            fac_features_dict["fac_features_mean_{}".format(landmark)] = [
                fac_features2[i]
            ]
            raw_variable_map = "fac_tremor_median_{}".format(landmark)
            fac_features_dict[r_config.base_raw["raw_feature"][raw_variable_map]] = [
                fac_features1[i]
            ]

            fac_features_dict["fac_disp_median_{}".format(landmark)] = [
                fac_disp_median[i]
            ]
            fac_features_dict["fac_corr_{}".format(landmark)] = [fac_corr[i]]

        fac_features_dict[r_config.err_reason] = [""]
        data = pd.DataFrame.from_dict(fac_features_dict)
        logger.info("Concluded computing tremor features")

        return data

    except Exception as e:
        logger.error("Error computing tremor features: {}".format(str(e)))
        return empty_frame(landmarks, r_config, str(e))


def empty_frame(landmarks, r_config, error_reason):
    fac_features_dict = {}
    for i, landmark in enumerate(landmarks):
        raw_variable_map = "fac_tremor_median_{}".format(landmark)
        fac_features_dict[r_config.base_raw["raw_feature"][raw_variable_map]] = [np.nan]

        fac_features_dict["fac_features_mean_{}".format(landmark)] = [np.nan]
        fac_features_dict["fac_disp_median_{}".format(landmark)] = [np.nan]
        fac_features_dict["fac_corr_{}".format(landmark)] = [np.nan]

    fac_features_dict[r_config.err_reason] = [error_reason]
    empty_frame = pd.DataFrame.from_dict(fac_features_dict)
    return empty_frame


def fac_tremor_process(video_uri, out_dir, r_config, model_output=False, save=True):
    """
    processing input videos


    """
    try:

        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)
        of_csv_path = glob.glob(join(out_loc, fl_name + "_openface_lmk/*_output.csv"))
        if len(of_csv_path) > 0:
            of_csv = of_csv_path[0]
            df_of = pd.read_csv(of_csv)

            logger.info(
                "Processing Output file for facial_tremor {} ".format(
                    os.path.join(out_loc, fl_name)
                )
            )

            feats = compute_features(of_csv_path, df_of, r_config)

            #         if model_output:
            #             result = score(feats, r_config)
            #             feats = pd.concat([feats, result], axis=1)
            if save:
                ut.save_output(feats, out_loc, fl_name, ft_dir, csv_ext)
            return feats

    except Exception as e:
        logger.error("Failed to process video file for facial_tremor", str(e))
