"""
file_name: speech_features
project_name: DBM
created: 2020-13-11
"""

import glob
import logging
import os
import shutil
from os.path import join

import pandas as pd

from opendbm.dbm_lib.dbm_features.raw_features.util import nlp_util as n_util
from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

speech_dir = "speech/speech_feature"
speech_ext = "_nlp.csv"
transcribe_ext = "speech/deepspeech/*_transcribe.csv"


def run_speech_feature(video_uri, out_dir, r_config, tran_tog, save=True):
    """
    Processing all patient's for fetching nlp features
    -------------------
    -------------------
    Args:
        video_uri: video path; r_config: raw variable config object
        out_dir: (str) Output directory for processed output
    """

    input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)

    transcribe_path = glob.glob(join(out_loc, transcribe_ext))
    transcribe_df = pd.read_csv(transcribe_path[0])
    df_speech = n_util.process_speech(transcribe_df, r_config)

    if save:
        logger.info("Saving Output file {} ".format(out_loc))
        logger.info("filename {} ".format(fl_name))
        ut.save_output(df_speech, out_loc, fl_name, speech_dir, speech_ext)

    if (tran_tog is None) or (tran_tog != "on"):
        if os.getcwd() == "/app":  # docker version
            shutil.rmtree(os.path.dirname(transcribe_path[0]))
        else:  # api_lib version
            if fl_name.endswith("mp4"):
                shutil.rmtree((out_dir + "/" + fl_name).replace("//", "/"))
            else:
                shutil.rmtree(
                    (out_dir + "/" + fl_name.strip(".mp4")).replace("//", "/")
                )

    return df_speech
