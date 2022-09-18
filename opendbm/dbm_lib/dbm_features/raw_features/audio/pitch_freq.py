"""
file_name: pitch_freq
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

ff_dir = "acoustic/pitch"
csv_ext = "_pitch.csv"
error_txt = "error: length less than 0.064"


def audio_pitch(path):
    """
    Using parselmouth library fetching pitch/fundamental frequency
    Args:
        path: (.wav) audio file location
    Returns:
        (list) list of pitch/fundamental frequency for each voice frame
    """
    sound_pat = parselmouth.Sound(path)
    pitch = sound_pat.to_pitch(time_step=0.001)
    pitch_values = pitch.selected_array["frequency"]

    return list(pitch_values)


def label_speech(row, fd_freq):
    """
    identify whether frame is voiced or not
    Args:
        row: (item) pitch frequency value
    Returns:
        (str) yes or no indicator for voice
    """
    if row[fd_freq] > 0:
        return "yes"
    else:
        return "no"


def calc_pitch(video_uri, audio_file, out_loc, fl_name, r_config, save=True):

    """
    Preparing pitch frequency matrix
    Args:
        audio_file: (.wav) parsed audio file
        row: (dataframe) subject details from master csv
        new_out_base_dir: (str) Output directory for csv
    """

    ff_frames = audio_pitch(audio_file)
    df_ffreq = pd.DataFrame(ff_frames, columns=[r_config.aco_ff])

    df_ffreq["Frames"] = df_ffreq.index
    df_ffreq[r_config.aco_voiceLabel] = df_ffreq.apply(
        lambda row: label_speech(row, r_config.aco_ff), axis=1
    )

    df_ffreq[
        r_config.err_reason
    ] = "Pass"  # will replace with threshold in future release
    df_ffreq["dbm_master_url"] = video_uri

    if save:
        logger.info("Processing Output file {} ".format(out_loc))
        ut.save_output(df_ffreq, out_loc, fl_name, ff_dir, csv_ext)
    return df_ffreq


def empty_pitch(video_uri, out_loc, fl_name, r_config, save=True):
    """
    Preparing empty pitch frequency matrix if something fails
    """

    df_ffreq = pd.DataFrame(
        [[np.nan, np.nan, "no", error_txt]],
        columns=[
            "Frames",
            r_config.aco_ff,
            r_config.aco_voiceLabel,
            r_config.err_reason,
        ],
    )
    df_ffreq["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_ffreq, out_loc, fl_name, ff_dir, csv_ext)
    return df_ffreq


def run_pitch(video_uri, out_dir, r_config, save=True):

    """
    Processing audio for fetching pitch
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

                df = empty_pitch(video_uri, out_loc, fl_name, r_config, save=save)
            else:
                df = calc_pitch(
                    video_uri, audio_file, out_loc, fl_name, r_config, save=save
                )
            return df

    except Exception as e:
        e
        logger.error("Failed to process audio file")
