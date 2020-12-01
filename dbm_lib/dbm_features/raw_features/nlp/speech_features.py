"""
file_name: speech_features
project_name: DBM
created: 2020-13-11
"""

import os
import numpy as np
import pandas as pd
import glob
from os.path import join
import logging

from dbm_lib.dbm_features.raw_features.util import util as ut
from dbm_lib.dbm_features.raw_features.util import nlp_util as n_util

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

speech_dir = 'nlp/speech_feature'
speech_ext = '_nlp.csv'
transcribe_ext = 'nlp/transcribe/*_transcribe.csv'

def run_speech_feature(video_uri, out_dir, r_config):
    """
    Processing all patient's for fetching nlp features
    -------------------
    -------------------
    Args:
        video_uri: video path; r_config: raw variable config object
        out_dir: (str) Output directory for processed output
    """
    try:
        
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)

        transcribe_path = glob.glob(join(out_loc, transcribe_ext))
        if len(transcribe_path)>0:

            transcribe_df = pd.read_csv(transcribe_path[0])
            df_speech= n_util.process_speech(transcribe_df, r_config)

            logger.info('Saving Output file {} '.format(out_loc))
            ut.save_output(df_speech, out_loc, fl_name, speech_dir, speech_ext)
            
    except Exception as e:
        logger.error('Failed to process video file')
