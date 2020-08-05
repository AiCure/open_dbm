"""
file_name: shimmer_processing
project_name: DBM
created: 2020-20-07
"""

import pandas as pd
import numpy as np
import os
import glob
import parselmouth
import librosa
import numpy as np
import more_itertools as mit
from os.path import join

import logging

from dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

shimmer_dir = 'audio/shimmer'
ff_dir = 'audio/pitch'
csv_ext = '_shimmer.csv'

def audio_shimmer(sound):
    """
    Using parselmouth library fetching shimmer
    Args:
        sound: parselmouth object
    Returns:
        (list) list of shimmers for each voice frame
    """
    pointProcess = parselmouth.praat.call(sound, "To PointProcess (periodic, cc)...", 80, 500)
    shimmer = parselmouth.praat.call([sound, pointProcess], "Get shimmer (local)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    return shimmer

def empty_shimmer(video_uri, out_loc, fl_name, r_config, error_txt):
    """
    Preparing empty shimmer matrix if something fails
    """
    cols = ['Frames', r_config.aco_shimmer, r_config.err_reason]
    out_val = [[np.nan, np.nan, error_txt]]
    df_shimmer = pd.DataFrame(out_val, columns = cols)
    df_shimmer['dbm_master_url'] = video_uri
    
    logger.info('Saving Output file {} '.format(out_loc))
    ut.save_output(df_shimmer, out_loc, fl_name, shimmer_dir, csv_ext)
    
def segment_pitch(dir_path, r_config):
    """
    segmenting pitch freq for each voice segment
    """
    com_speech_sort, voiced_yes, voiced_no  = ([], ) * 3
    for file in os.listdir(dir_path):
        try:
            
            if file.endswith('_pitch.csv'):
                
                ff_df = pd.read_csv((dir_path+'/'+file))
                voice_label = ff_df[r_config.aco_voiceLabel]
                
                indices_yes = [i for i, x in enumerate(voice_label) if x == "yes"]
                voiced_yes = [list(group) for group in mit.consecutive_groups(indices_yes)]
                
                indices_no = [i for i, x in enumerate(voice_label) if x == "no"]
                voiced_no = [list(group) for group in mit.consecutive_groups(indices_no)]
                
                com_speech = voiced_yes + voiced_no
                com_speech_sort = sorted(com_speech, key=lambda x: x[0])
        except:
            pass
        
    return com_speech_sort, voiced_yes, voiced_no

def segment_shimmer(com_speech_sort, voiced_yes, voiced_no, shimmer_frames, audio_file):
    """
    calculating shimmer for each voice segment
    """
    snd = parselmouth.Sound(audio_file)
    pitch = snd.to_pitch(time_step=.001)
    
    for idx, vs in enumerate(com_speech_sort):
        try:
            
            shimmer = np.NaN
            if vs in voiced_yes and len(vs)>1:
                
                start_time = pitch.get_time_from_frame_number(vs[0])
                end_time = pitch.get_time_from_frame_number(vs[-1])

                snd_start = int(snd.get_frame_number_from_time(start_time))
                snd_end = int(snd.get_frame_number_from_time(end_time))

                samples = parselmouth.Sound(snd.as_array()[0][snd_start:snd_end])
                shimmer = audio_shimmer(samples)
        except:
            pass

        shimmer_frames[idx] = shimmer
    return shimmer_frames
    
def calc_shimmer(video_uri, audio_file, out_loc, fl_name, r_config):
    """
    Preparing shimmer matrix
    Args:
        audio_file: (.wav) parsed audio file
        out_loc: (str) Output directory for csv
        r_config: config.config_raw_feature.pyConfigFeatureNmReader object
    """
    dir_path = os.path.join(out_loc, ff_dir)
    if os.path.isdir(dir_path):
        voice_seg = segment_pitch(dir_path, r_config)
        
        shimmer_frames = [np.NaN] * len(voice_seg[0])
        shimmer_segment_frames = segment_shimmer(voice_seg[0], voice_seg[1], voice_seg[2], shimmer_frames, audio_file)
        
        df_shimmer = pd.DataFrame(shimmer_segment_frames, columns=[r_config.aco_shimmer])
        df_shimmer[r_config.err_reason] = 'Pass'# will replace with threshold in future release
        
        df_shimmer['Frames'] = df_shimmer.index
        df_shimmer['dbm_master_url'] = video_uri
        
        logger.info('Processing Output file {} '.format(out_loc))
        ut.save_output(df_shimmer, out_loc, fl_name, shimmer_dir, csv_ext)
        
    else:
        error_txt = 'error: fundamental freq not available'
        empty_shimmer(video_uri, out_loc, fl_name, r_config, error_txt)
    
def run_shimmer(video_uri, out_dir, r_config):
    """
    Processing all patients to fetch shimmer
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

            if float(aud_dur) < 0.064:
                logger.info('Output file {} size is less than 0.064sec'.format(audio_file))

                error_txt = 'error: length less than 0.064'
                empty_shimmer(video_uri, out_loc, fl_name, r_config, error_txt)
                return

            calc_shimmer(video_uri, audio_file, out_loc, fl_name, r_config)
    except Exception as e:
        logger.error('Failed to process audio file')