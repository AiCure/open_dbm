"""
file_name: intensity
project_name: DBM
created: 2020-20-07
"""

import pandas as pd
import numpy as np
import glob
import parselmouth
import librosa
from os.path import join
import logging

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

intensity_dir = 'acoustic/intensity'
csv_ext = '_intensity.csv'
error_txt = 'error: length less than 0.064'

def intensity_score(path):
    """
    Using parselmouth library fetching Intensity
    Args:
        path: (.wav) audio file location
    Returns:
        (list) list of Intensity for each voice frame
    """
    sound_pat = parselmouth.Sound(path)
    intensity = sound_pat.to_intensity(time_step=.001)
    return intensity.values[0]

def calc_intensity(video_uri, audio_file, out_loc, fl_name, r_config):
    """
    Preparing Intensity matrix
    Args:
        audio_file: (.wav) parsed audio file
        out_loc: (str) Output directory for csv's
    """
    
    intensity_frames = intensity_score(audio_file)
    df_intensity = pd.DataFrame(intensity_frames, columns=[r_config.aco_int])
    
    df_intensity['Frames'] = df_intensity.index
    df_intensity['dbm_master_url'] = video_uri
    df_intensity[r_config.err_reason] = 'Pass'# will replace with threshold in future release
    
    logger.info('Saving Output file {} '.format(out_loc))
    ut.save_output(df_intensity, out_loc, fl_name, intensity_dir, csv_ext)
    
def empty_intensity(video_uri, out_loc, fl_name, r_config):
    """
    Preparing empty Intensity matrix if something fails
    """
    cols = ['Frames', r_config.aco_int, r_config.err_reason]
    out_val = [[np.nan, np.nan, error_txt]]
    df_int = pd.DataFrame(out_val, columns = cols)
    df_int['dbm_master_url'] = video_uri
    
    logger.info('Saving Output file {} '.format(out_loc))
    ut.save_output(df_int, out_loc, fl_name, intensity_dir, csv_ext)

def run_intensity(video_uri, out_dir, r_config):
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
        aud_filter = glob.glob(join(input_loc, fl_name + '.wav'))
        if len(aud_filter)>0:

            audio_file = aud_filter[0]
            aud_dur = librosa.get_duration(filename=audio_file)

            if float(aud_dur) < 0.064:
                logger.info('Output file {} size is less than 0.064sec'.format(audio_file))

                empty_intensity(video_uri, out_loc, fl_name, r_config)
                return

            calc_intensity(video_uri, audio_file, out_loc, fl_name, r_config)
    except Exception as e:
        logger.error('Failed to process audio file')