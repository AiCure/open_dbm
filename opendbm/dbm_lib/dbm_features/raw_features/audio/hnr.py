"""
file_name: hnr
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

hnr_dir = "acoustic/harmonic_noise"
csv_ext = "_hnr.csv"
error_txt = "error: length less than 0.064"


def hnr_ratio(filepath):
    """
    Using parselmouth library fetching harmonic noise ratio ratio
    Args:
        path: (.wav) audio file location
    Returns:
        (list) list of hnr ratio for each voice frame, min,max and mean hnr
    """
    sound = parselmouth.Sound(filepath)
    harmonicity = sound.to_harmonicity_ac(time_step=0.001)

    hnr_all_frames = harmonicity.values  # [harmonicity.values != -200] nan it (****)
    hnr_all_frames = np.where(hnr_all_frames == -200, np.NaN, hnr_all_frames)
    return hnr_all_frames.transpose()


def calc_hnr(video_uri, audio_file, out_loc, fl_name, r_config, save=True):
    """
    Preparing harmonic noise matrix
    Args:
        audio_file: (.wav) parsed audio file
        out_loc: (str) Output directory for csv's
    """

    hnr_all_frames = hnr_ratio(audio_file)
    df_hnr = pd.DataFrame(hnr_all_frames, columns=[r_config.aco_hnr])

    df_hnr["Frames"] = df_hnr.index
    df_hnr["dbm_master_url"] = video_uri
    df_hnr[
        r_config.err_reason
    ] = "Pass"  # will replace with threshold in future release

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_hnr, out_loc, fl_name, hnr_dir, csv_ext)
    return df_hnr


def empty_hnr(video_uri, out_loc, fl_name, r_config, save=True):
    """
    Preparing empty HNR matrix if something fails
    """
    cols = ["Frames", r_config.aco_hnr, r_config.err_reason]
    out_val = [[np.nan, np.nan, error_txt]]
    df_hnr = pd.DataFrame(out_val, columns=cols)
    df_hnr["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_hnr, out_loc, fl_name, hnr_dir, csv_ext)
    return df_hnr


def run_hnr(video_uri, out_dir, r_config, save=True):
    """
    Processing all patient's for fetching harmonic noise ratio
    -------------------
    -------------------
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

                df = empty_hnr(video_uri, out_loc, fl_name, r_config, save=save)

            else:
                df = calc_hnr(
                    video_uri, audio_file, out_loc, fl_name, r_config, save=save
                )
            return df
    except Exception as e:
        e
        logger.error("Failed to process audio file")
