"""
file_name: voice_frame_score
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

vfs_dir = "acoustic/voice_frame_score"
csv_ext = "_voiceprev.csv"
error_txt = "error: length less than 0.064"


def audio_pitch_frame(pitch):
    """
    Computing total number of speech and participant voiced frames
    Args:
        pitch: speech pitch
    Returns:
        (float) total voice frames and participant voiced frames
    """
    total_frames = pitch.get_number_of_frames()
    voiced_frames = pitch.count_voiced_frames()
    return total_frames, voiced_frames


def voice_segment(path):
    """
    Using parselmouth library for fundamental frequency
    Args:
        path: (.wav) audio file location
    Returns:
        (float) total voice frames, participant voiced frames and voiced frames percentage
    """
    sound_pat = parselmouth.Sound(path)
    pitch = sound_pat.to_pitch()
    total_frames, voiced_frames = audio_pitch_frame(pitch)

    voiced_percentage = (voiced_frames / total_frames) * 100
    return voiced_percentage, voiced_frames, total_frames


def calc_vfs(video_uri, audio_file, out_loc, fl_name, r_config, save=True):
    """
    creating dataframe matrix for voice frame score
    Args:
        audio_file: Audio file path
        new_out_base_dir: AWS instance output base directory path
        f_nm_config: Config file object
    """

    voice_percentage, voiced_frames, total_frames = voice_segment(audio_file)
    df_vfs = pd.DataFrame([voiced_frames], columns=[r_config.aco_voiceFrame])

    df_vfs[r_config.aco_totVoiceFrame] = [total_frames]
    df_vfs[r_config.aco_voicePct] = [voice_percentage]
    df_vfs[
        r_config.err_reason
    ] = "Pass"  # will replace with threshold in future release

    df_vfs["Frames"] = df_vfs.index
    df_vfs["dbm_master_url"] = video_uri
    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_vfs, out_loc, fl_name, vfs_dir, csv_ext)
    return df_vfs


def empty_vfs(video_uri, out_loc, fl_name, r_config, save=True):
    """
    Preparing empty VFS matrix if something fails
    """
    cols = [
        "Frames",
        r_config.aco_voiceFrame,
        r_config.aco_totVoiceFrame,
        r_config.aco_voicePct,
        r_config.err_reason,
    ]
    out_val = [[np.nan, np.nan, np.nan, np.nan, error_txt]]
    df_vfs = pd.DataFrame(out_val, columns=cols)
    df_vfs["dbm_master_url"] = video_uri
    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_vfs, out_loc, fl_name, vfs_dir, csv_ext)
    return df_vfs


def run_vfs(video_uri, out_dir, r_config, save=True):
    """
    Processing all participants for fetching voice frame score
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

                df = empty_vfs(video_uri, out_loc, fl_name, r_config, save=save)
            else:
                df = calc_vfs(
                    video_uri, audio_file, out_loc, fl_name, r_config, save=save
                )
            return df
    except Exception as e:
        e
        logger.error("Failed to process audio file")
