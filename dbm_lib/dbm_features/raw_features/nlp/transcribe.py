"""
file_name: transcribe
project_name: DBM
created: 2020-10-11
"""

import pandas as pd
import numpy as np
import librosa
import glob
from os.path import join
import logging

from dbm_lib.dbm_features.raw_features.util import util as ut
from dbm_lib.dbm_features.raw_features.util import nlp_util as n_util

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

formant_dir = 'nlp/transcribe'
csv_ext = '_transcribe.csv'
error_txt = 'error: length less than 0.1'

def calc_transcribe(video_uri, audio_file, out_loc, fl_name, r_config, deep_path, aud_dur):
    """
    Preparing Formant freq matrix
    Args:
        audio_file: (.wav) parsed audio file; fl_name: input file name
        out_loc: (str) Output directory; r_config: raw variable config
    """
    
    text = n_util.process_deepspeech(audio_file, deep_path)
    df_formant = pd.DataFrame([text], columns=[r_config.nlp_transcribe])
    
    df_formant.replace('', np.nan, regex=True,inplace=True)
    df_formant[r_config.nlp_totalTime] = aud_dur
    df_formant[r_config.err_reason] = 'Pass'# will replace with threshold in future release
    df_formant['dbm_master_url'] = video_uri
    
    logger.info('Saving Output file {} '.format(out_loc))
    ut.save_output(df_formant, out_loc, fl_name, formant_dir, csv_ext)
    
def empty_transcribe(video_uri, out_loc, fl_name, r_config):
    
    """
    Preparing empty formant frequency matrix if something fails
    """
    cols = [r_config.nlp_transcribe, r_config.nlp_totalTime, r_config.err_reason]
    out_val = [[np.nan, np.nan, error_txt]]
    df_fm = pd.DataFrame(out_val, columns = cols)
    df_fm['dbm_master_url'] = video_uri
    
    logger.info('Saving Output file {} '.format(out_loc))
    ut.save_output(df_fm, out_loc, fl_name, formant_dir, csv_ext)

def run_transcribe(video_uri, out_dir, r_config, deep_path):
    
    """
    Processing all patient's for fetching Formant freq
    ---------------
    ---------------
    Args:
        video_uri: video path; r_config: raw variable config object
        out_dir: (str) Output directory for processed output; deep_path: deepspeech build path
    """
    try:
        
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)
        aud_filter = glob.glob(join(input_loc, fl_name + '.wav'))
        if len(aud_filter)>0:

            audio_file = aud_filter[0]
            aud_dur = librosa.get_duration(filename=audio_file)

            if float(aud_dur) < 0.1:
                logger.info('Output file {} size is less than 0.1 sec'.format(audio_file))

                empty_transcribe(video_uri, out_loc, fl_name, r_config)
                return

            calc_transcribe(video_uri, audio_file, out_loc, fl_name, r_config, deep_path, aud_dur)
    except Exception as e:
        logger.error('Failed to process audio file')
        