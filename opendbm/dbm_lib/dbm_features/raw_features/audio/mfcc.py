"""
file_name: mfcc
project_name: DBM
created: 2020-20-07
"""

import glob
import logging
import os
from os.path import join

import numpy as np
import pandas as pd
import parselmouth

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

mfcc_dir = "acoustic/mfcc"
csv_ext = "_mfcc.csv"
error_txt = "error: length less than 0.064"


def empty_mfcc(video_uri, out_loc, fl_name, r_config, save=True):

    """
    Preparing empty empty_mfcc matrix if something fails
    """
    cols = [
        "Frames",
        r_config.aco_mfcc1,
        r_config.aco_mfcc2,
        r_config.aco_mfcc3,
        r_config.aco_mfcc4,
        r_config.aco_mfcc5,
        r_config.aco_mfcc6,
        r_config.aco_mfcc7,
        r_config.aco_mfcc8,
        r_config.aco_mfcc9,
        r_config.aco_mfcc10,
        r_config.aco_mfcc11,
        r_config.aco_mfcc12,
        r_config.err_reason,
    ]
    out_val = [
        [
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            np.nan,
            error_txt,
        ]
    ]
    df_mfcc = pd.DataFrame(out_val, columns=cols)
    df_mfcc["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_mfcc, out_loc, fl_name, mfcc_dir, csv_ext)

    return df_mfcc


def audio_mfcc(path):
    """
    Using parselmouth library fetching mfccs
    Args:
        path: (.wav) audio file location
    Returns:
        (list) list of mfccs for each voice frame
    """
    sound = parselmouth.Sound(path)
    mfcc_object = sound.to_mfcc(time_step=0.001, number_of_coefficients=12)
    mfccs = mfcc_object.to_array()
    mfccs = np.delete(mfccs, (0), axis=0)
    return mfccs


def calc_mfcc(video_uri, audio_file, out_loc, fl_name, r_config, save=True):
    """
    Preparing mfcc matrix
    Args:
        audio_file: (.wav) parsed audio file
        out_loc: output location to save csv
        fl_name: (str) name of audio file
        r_config: config.config_raw_feature.pyConfigFeatureNmReader object
    """
    dict_ = {}
    mfccs = audio_mfcc(audio_file)

    for i in range(1, 13):
        conf_str = r_config.base_raw["raw_feature"]
        dict_[conf_str["aco_mfcc" + str(i)]] = mfccs[i - 1, :]

    df = pd.DataFrame(dict_)
    df["Frames"] = df.index

    df[r_config.err_reason] = "Pass"  # may replace based on threshold in future release
    df["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df, out_loc, fl_name, mfcc_dir, csv_ext)
    return df


def run_mfcc(video_uri, out_dir, r_config, save=True):
    """
    Processing all patients to fetch mfccs

    Args:
        video_uri: video path; r_config: raw variable config object
        out_dir: (str) Output directory for processed output
    """
    try:

        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)
        aud_filter = glob.glob(join(input_loc, fl_name + ".wav"))
        if len(aud_filter) > 0:

            audio_file = aud_filter[0]
            aud_dur = ut.get_length(audio_file)

            if float(aud_dur) < 0.064:
                logger.info(
                    "Output file {} size is less than 0.064sec".format(audio_file)
                )

                return empty_mfcc(video_uri, out_loc, fl_name, r_config, save=save)

            return calc_mfcc(
                video_uri, audio_file, out_loc, fl_name, r_config, save=save
            )
    except Exception as e:
        e
        logger.error("Failed to process audio file")
