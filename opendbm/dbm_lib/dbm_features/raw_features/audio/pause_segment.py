"""
file_name: pause_segment
project_name: DBM
created: 2020-20-07
"""

import glob
import logging
import os
from os.path import join

import numpy as np
import pandas as pd
import webrtcvad
from pydub import AudioSegment

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut
from opendbm.dbm_lib.dbm_features.raw_features.util import vad_utilities as vu

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

pause_seg_dir = "acoustic/pause_segment"
csv_ext = "_pausechar.csv"


def get_timing_cues(seg_starts_sec, seg_ends_sec, r_config):
    """
    Get timing cues from segmented speech
    Args:
        seg_starts_sec: Audio segment start time in seconds
        seg_ends_sec: Audio segment end time in seconds
    Returns:
        Dictionary with pause features
    """
    total_time = seg_ends_sec[-1] - seg_starts_sec[0]
    speaking_time = np.sum(np.asarray(seg_ends_sec) - np.asarray(seg_starts_sec))
    num_pauses = len(seg_starts_sec) - 1
    pause_len = np.zeros(num_pauses)

    for p in range(num_pauses):
        pause_len[p] = seg_starts_sec[p + 1] - seg_ends_sec[p]

    if len(pause_len) > 0:
        pause_time = np.sum(pause_len)

    else:
        pause_time = 0

    pause_frac = pause_time / total_time
    timing_dict = {
        r_config.aco_totaltime: total_time,
        r_config.aco_speakingtime: speaking_time,
        r_config.aco_numpauses: num_pauses,
        r_config.aco_pausetime: pause_time,
        r_config.aco_pausefrac: pause_frac,
    }
    return timing_dict


def process_silence(audio_file, r_config):
    """
    Returns dataframe for pause between words using voice activity detection
    Args:
        audio_file: Audio file location
    Returns:
        Dataframe value
    """
    feat_dict_list = []
    y, sr = vu.read_wave(audio_file)

    # 3 is most aggressive (splits most), 0 least (better for low snr)
    aggressiveness = 3
    frame_dur_ms = 20

    # pause segment(long & short pad)
    long_pad_around_voice_ms = 200
    short_pad_around_voice_ms = 100

    if len(y) > 0:
        vad = webrtcvad.Vad(aggressiveness)

        frames = vu.frame_generator(frame_dur_ms, y, sr)
        frames = list(frames)

        # longer pad time screens out little blips, but misses short silences
        long_seg_starts, long_seg_ends = vu.vad_get_segment_times(
            sr, frame_dur_ms, long_pad_around_voice_ms, vad, frames
        )

        # Logic to handle blank audio file
        if len(long_seg_starts) == 0 or len(long_seg_ends) == 0:
            return ""

        t_start = long_seg_starts[0]
        t_end = long_seg_ends[-1]
        # shorter pad time captures short silences (but misfires on little blips)
        short_seg_starts, short_seg_ends = vu.vad_get_segment_times(
            sr, frame_dur_ms, short_pad_around_voice_ms, vad, frames
        )

        seg_starts = []
        seg_ends = []
        for k in range(
            len(short_seg_starts)
        ):  # logic to clean up some typical misfires
            if (short_seg_starts[k] >= t_start) and (short_seg_starts[k] <= t_end):

                seg_starts.append(short_seg_starts[k])
                seg_ends.append(short_seg_ends[k])
        if len(seg_starts) == 0 or len(seg_ends) == 0:
            return ""

        timing_dict = get_timing_cues(seg_starts, seg_ends, r_config)
        feat_dict_list.append(timing_dict)

    df = pd.DataFrame(feat_dict_list)
    df[r_config.err_reason] = "Pass"  # will replace with threshold in future release
    return df


def empty_pause_segment(video_uri, out_loc, fl_name, r_config, error_txt, save=True):
    """
    Preparing empty Pause Segment matrix if something fails
    """
    cols = [
        r_config.aco_totaltime,
        r_config.aco_speakingtime,
        r_config.aco_numpauses,
        r_config.aco_pausetime,
        r_config.aco_pausefrac,
        r_config.err_reason,
    ]
    out_val = [[np.nan, np.nan, np.nan, np.nan, np.nan, error_txt]]
    df_pause = pd.DataFrame(out_val, columns=cols)
    df_pause["dbm_master_url"] = video_uri

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        ut.save_output(df_pause, out_loc, fl_name, pause_seg_dir, csv_ext)
    return df_pause


def run_pause_segment(video_uri, out_dir, r_config, save=True):
    """
    Processing all patient's for getting Pause Segment
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

                error_txt = "error: length less than 0.064"
                empty_pause_segment(video_uri, out_loc, fl_name, r_config, error_txt)
                return

            logger.info("Converting stereo sound to mono-lD")
            sound_mono = AudioSegment.from_wav(audio_file)
            sound_mono = sound_mono.set_channels(1)
            sound_mono = sound_mono.set_frame_rate(48000)

            mono_wav = os.path.join(input_loc, fl_name + "_mono.wav")
            sound_mono.export(mono_wav, format="wav")

            df_pause_seg = process_silence(mono_wav, r_config)
            os.remove(mono_wav)  # removing mono wav file

            if isinstance(df_pause_seg, pd.DataFrame) and len(df_pause_seg) > 0:
                df_pause_seg["dbm_master_url"] = video_uri
                if save:
                    logger.info("Processing Output file {} ".format(out_loc))
                    ut.save_output(
                        df_pause_seg, out_loc, fl_name, pause_seg_dir, csv_ext
                    )
                df = df_pause_seg

            else:
                error_txt = "error: webrtcvad returns no segment"
                df = empty_pause_segment(
                    video_uri, out_loc, fl_name, r_config, error_txt, save=save
                )
            return df

    except Exception as e:
        e
        logger.error("Failed to process audio file", str(e))
