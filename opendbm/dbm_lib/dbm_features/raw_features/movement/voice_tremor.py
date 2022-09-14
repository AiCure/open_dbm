import pandas as pd
import os
import glob
from os.path import join
import parselmouth
from parselmouth.praat import call, run_file
import numpy as np
import librosa
import json
import re
import logging

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut
from opendbm.dbm_lib.dbm_features.raw_features.movement import DBMLIB_VTREMOR_LIB

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

vt_dir = 'movement/voice_tremor'
csv_ext = '_vtremor.csv'

#Executing praat script using parselmouth function
def tremor_praat(snd_file,r_cfg):
    """
        Generating Voice tremor endpoint dataframe
        Args:
            snd_file: (.wav) parsed audio file
            r_cfg: Raw variable configuration file
        Returns tremor endpoint dataframe
    """
    snd = parselmouth.Sound(snd_file)
    tremor_var = run_file(snd,DBMLIB_VTREMOR_LIB,capture_output=True)
    new_tremor_var = re.sub('--undefined--', '0', tremor_var[1])
    res = json.loads(new_tremor_var)
    tremor_df = pd.DataFrame(res,index=['0',])
    tremor_df.columns = [r_cfg.mov_freq_trem_freq,r_cfg.mov_amp_trem_freq,r_cfg.mov_freq_trem_index,
                         r_cfg.mov_amp_trem_index,r_cfg.mov_freq_trem_pindex,r_cfg.mov_amp_trem_pindex]
    return tremor_df

def prepare_vtrem_output(audio_file, out_loc, r_config, fl_name):
    """
        Preparing voice tremor matrix
        Args:
            audio_file: (.wav) parsed audio file ; r_config: raw config object
            out_loc: (str) Output directory for csv ; fl_name: file name
    """
    df_tremor = tremor_praat(audio_file, r_config)
    df_tremor[r_config.err_reason] = 'Pass'# will replace with threshold in future release

    logger.info('Processing Output file {} '.format(os.path.join(out_loc, fl_name)))
    ut.save_output(df_tremor, out_loc, fl_name, vt_dir, csv_ext)

def prepare_empty_vt(out_loc, fl_name, r_config, error_txt):

    """
    Preparing empty voice tremor matrix
    """
    cols = [r_config.mov_freq_trem_freq, r_config.mov_amp_trem_freq, r_config.mov_freq_trem_index,
            r_config.mov_amp_trem_index, r_config.mov_freq_trem_pindex, r_config.mov_amp_trem_pindex, r_config.err_reason]

    out_val = [[np.nan, np.nan, np.nan, np.nan, np.nan, np.nan, error_txt]]
    df_tremor = pd.DataFrame(out_val, columns = cols)

    logger.info('Saving Output file {} '.format(os.path.join(out_loc, fl_name)))
    ut.save_output(df_tremor, out_loc, fl_name, vt_dir, csv_ext)

def run_vtremor(video_uri, out_dir, r_config):
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
        aud_filter = glob.glob(join(input_loc, fl_name + '.wav'))
        if len(aud_filter)>0:

            audio_file = aud_filter[0]
            aud_dur = librosa.get_duration(filename=audio_file)

            if float(aud_dur) < 0.5:
                logger.info('Output file {} size is less than 0.5sec'.format(audio_file))
                
                error_txt = 'error: length less than 0.5 sec'
                prepare_empty_vt(video_uri, out_loc, fl_name, error_txt)
                return
            prepare_vtrem_output(audio_file, out_loc, r_config, fl_name)
    except Exception as e:
        logger.error('Failed to compute Voice Tremor {} for {}'.format(e,video_uri))
        prepare_empty_vt(out_loc, fl_name, r_config, e)
