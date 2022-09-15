"""
file_name: formant_freq
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

formant_dir = "acoustic/formant_freq"
csv_ext = "_formant.csv"
error_txt = "error: length less than 0.064"


def formant_list(formant, snd):
    """
    Getting formant frequency per second
    Args:
        formant: Formant object for sound wave
        snd: Parselmouth sound object
    Returns:
        List of first through fourth formant for each frame
    """
    f1_list = []
    f2_list = []
    f3_list = []
    f4_list = []

    dur = snd.duration - 0.02
    dur_round = round(dur, 2)

    time_list = np.arange(0.001, dur_round, 0.001)
    for time in time_list:

        f1 = formant.get_value_at_time(1, time)
        f2 = formant.get_value_at_time(2, time)
        f3 = formant.get_value_at_time(3, time)
        f4 = formant.get_value_at_time(4, time)

        f1_list.append(f1)
        f2_list.append(f2)
        f3_list.append(f3)
        f4_list.append(f4)
    return f1_list, f2_list, f3_list, f4_list


def formant_score(path):
    """
    Using parselmouth library fetching Formant Frequency
    Args:
        path: (.wav) audio file location
    Returns:
        (list) list of Formant freq for each voice frame
    """
    sound_pat = parselmouth.Sound(path)
    formant = sound_pat.to_formant_burg(time_step=0.001)
    f_score = formant_list(formant, sound_pat)
    return f_score


def calc_formant(video_uri, audio_file, out_loc, fl_name, r_config, save=True):
    """
    Preparing Formant freq matrix
    Args:
        audio_file: (.wav) parsed audio file; fl_name: input file name
        out_loc: (str) Output directory; r_config: raw variable config
    """

    f1_list, f2_list, f3_list, f4_list = formant_score(audio_file)
    df_formant = pd.DataFrame(f1_list, columns=[r_config.aco_fm1])

    df_formant[r_config.aco_fm2] = f2_list
    df_formant[r_config.aco_fm3] = f3_list
    df_formant[r_config.aco_fm4] = f4_list

    df_formant.replace("", np.nan, regex=True, inplace=True)
    df_formant[
        r_config.err_reason
    ] = "Pass"  # will replace with threshold in future release

    df_formant["Frames"] = df_formant.index
    df_formant["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_formant, out_loc, fl_name, formant_dir, csv_ext)
    return df_formant


def empty_fm(video_uri, out_loc, fl_name, r_config, save=True):

    """
    Preparing empty formant frequency matrix if something fails
    """
    cols = [
        "Frames",
        r_config.aco_fm1,
        r_config.aco_fm2,
        r_config.aco_fm3,
        r_config.aco_fm4,
        r_config.err_reason,
    ]
    out_val = [[np.nan, np.nan, np.nan, np.nan, np.nan, error_txt]]
    df_fm = pd.DataFrame(out_val, columns=cols)
    df_fm["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_fm, out_loc, fl_name, formant_dir, csv_ext)
    return df_fm


def run_formant(video_uri, out_dir, r_config, save=True):

    """
    Processing all patient's for fetching Formant freq
    ---------------
    ---------------
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

                df = empty_fm(video_uri, out_loc, fl_name, r_config, save=save)
            else:
                df = calc_formant(
                    video_uri, audio_file, out_loc, fl_name, r_config, save=save
                )
            return df
    except Exception as e:
        e
        logger.error("Failed to process audio file")
