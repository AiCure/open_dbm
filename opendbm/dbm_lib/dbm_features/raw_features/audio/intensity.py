"""
file_name: intensity
project_name: DBM
created: 2020-20-07
"""

import glob
import logging
from os.path import join

import numpy as np
import pandas as pd
import parselmouth

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

intensity_dir = "acoustic/intensity"
csv_ext = "_intensity.csv"
error_txt = "error: length less than 0.064"


def intensity_score(path):
    """
    Using parselmouth library fetching Intensity
    Args:
        path: (.wav) audio file location
    Returns:
        (list) list of Intensity for each voice frame
    """
    sound_pat = parselmouth.Sound(path)
    intensity = sound_pat.to_intensity(time_step=0.001)
    return intensity.values[0]


def calc_intensity(video_uri, audio_file, out_loc, fl_name, r_config, save=True):
    """
    Preparing Intensity matrix
    Args:
        audio_file: (.wav) parsed audio file
        out_loc: (str) Output directory for csv's
    """

    intensity_frames = intensity_score(audio_file)
    df_intensity = pd.DataFrame(intensity_frames, columns=[r_config.aco_int])

    df_intensity["Frames"] = df_intensity.index
    df_intensity["dbm_master_url"] = video_uri
    df_intensity[
        r_config.err_reason
    ] = "Pass"  # will replace with threshold in future release

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_intensity, out_loc, fl_name, intensity_dir, csv_ext)
    return df_intensity


def empty_intensity(video_uri, out_loc, fl_name, r_config, save=True):
    """
    Preparing empty Intensity matrix if something fails
    """
    cols = ["Frames", r_config.aco_int, r_config.err_reason]
    out_val = [[np.nan, np.nan, error_txt]]
    df_int = pd.DataFrame(out_val, columns=cols)
    df_int["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_int, out_loc, fl_name, intensity_dir, csv_ext)
    return df_int


def run_intensity(video_uri, out_dir, r_config, save=True):
    """
    Processing all patient's for fetching Intensity
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

                df = empty_intensity(video_uri, out_loc, fl_name, r_config, save=save)
            else:
                df = calc_intensity(
                    video_uri, audio_file, out_loc, fl_name, r_config, save=save
                )
        return df
    except Exception as e:
        e
        logger.error("Failed to process audio file")
