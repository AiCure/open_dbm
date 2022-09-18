"""
file_name: jitter_processing
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

jitter_dir = "acoustic/jitter"
ff_dir = "acoustic/pitch"
csv_ext = "_jitter.csv"


def audio_jitter(sound):
    """
    Using parselmouth library fetching jitter
    Args:
        sound: parselmouth object
    Returns:
        (list) list of jitters for each voice frame
    """
    pointProcess = parselmouth.praat.call(
        sound, "To PointProcess (periodic, cc)...", 80, 500
    )
    jitter = parselmouth.praat.call(
        pointProcess, "Get jitter (local)", 0, 0, 0.0001, 0.02, 1.3
    )
    return jitter


def empty_jitter(video_uri, out_loc, fl_name, r_config, error_txt, save=True):
    """
    Preparing empty jitter matrix if something fails
    """
    cols = ["Frames", r_config.aco_jitter, r_config.err_reason]
    out_val = [[np.nan, np.nan, error_txt]]
    df_jitter = pd.DataFrame(out_val, columns=cols)
    df_jitter["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_jitter, out_loc, fl_name, jitter_dir, csv_ext)
    return df_jitter


def segment_jitter(com_speech_sort, voiced_yes, voiced_no, jitter_frames, audio_file):
    """
    calculating jitter for each voice segment
    """
    snd = parselmouth.Sound(audio_file)
    pitch = snd.to_pitch(time_step=0.001)

    for idx, vs in enumerate(com_speech_sort):
        try:

            jitter = np.NaN
            if vs in voiced_yes and len(vs) > 1:

                start_time = pitch.get_time_from_frame_number(vs[0])
                end_time = pitch.get_time_from_frame_number(vs[-1])

                snd_start = int(snd.get_frame_number_from_time(start_time))
                snd_end = int(snd.get_frame_number_from_time(end_time))

                samples = parselmouth.Sound(snd.as_array()[0][snd_start:snd_end])
                jitter = audio_jitter(samples)
        except:
            pass

        jitter_frames[idx] = jitter
    return jitter_frames


def calc_jitter(
    video_uri, audio_file, out_loc, fl_name, r_config, save=True, ff_df=None
):
    """
    Preparing jitter matrix
    Args:
        audio_file: (.wav) parsed audio file
        out_loc: (str) Output directory for csv
        r_config: config.config_raw_feature.pyConfigFeatureNmReader object
    """
    dir_path = os.path.join(out_loc, ff_dir)
    if os.path.isdir(dir_path) or ff_df is not None:

        if ff_df is not None:
            voice_seg = ut.process_segment_pitch(ff_df, r_config)
        else:
            voice_seg = ut.segment_pitch(dir_path, r_config, ff_df=ff_df)

        jitter_frames = [np.NaN] * len(voice_seg[0])
        jitter_segment_frames = segment_jitter(
            voice_seg[0], voice_seg[1], voice_seg[2], jitter_frames, audio_file
        )

        df_jitter = pd.DataFrame(jitter_segment_frames, columns=[r_config.aco_jitter])
        df_jitter[
            r_config.err_reason
        ] = "Pass"  # will replace with threshold in future release

        df_jitter["Frames"] = df_jitter.index
        df_jitter["dbm_master_url"] = video_uri
        if save:
            logger.info("Processing Output file {} ".format(out_loc))
            ut.save_output(df_jitter, out_loc, fl_name, jitter_dir, csv_ext)
        df = df_jitter
    else:
        error_txt = "error: fundamental freq not available"
        df = empty_jitter(video_uri, out_loc, fl_name, r_config, error_txt, save=save)
    return df


def run_jitter(video_uri, out_dir, r_config, save=True, ff_df=None):
    """
    Processing all patient's videos for fetching jitter
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

                error_txt = "error: length less than 0.064"
                df = empty_jitter(
                    video_uri, out_loc, fl_name, r_config, error_txt, save=save
                )
            else:
                df = calc_jitter(
                    video_uri,
                    audio_file,
                    out_loc,
                    fl_name,
                    r_config,
                    save=save,
                    ff_df=ff_df,
                )
            return df
    except Exception as e:
        logger.error("Error in jitter: {}".format(e))
        logger.error("Failed to process audio file")
