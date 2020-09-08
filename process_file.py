"""
file_name: process_file
project_name: DBM
created: 2020-20-07
"""

from dbm_lib.config import config_reader, config_raw_feature, config_derive_feature
from dbm_lib.controller import process_feature as pf
from dbm_lib.dbm_features.raw_features.video import open_face_process as of
from dbm_lib.dbm_features.derived_features import derive as der

import pandas as pd
import os
import argparse
import logging
import glob

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

OPENFACE_PATH = 'pkg/OpenFace/build/bin/FeatureExtraction'
DLIB_SHAPE_MODEL = 'pkg/shape_detector/shape_predictor_68_face_landmarks.dat'

def process_raw_video(args, s_config, r_config):
    """
    Processing video file
    Args:
        args: user supplied arguments
        s_config: service config object
        r_config: raw feature config object
    """
    try:
        if args.output_raw_path != None:
            video_file = glob.glob(args.input_path)

            if len(video_file)>0:
                pf.audio_to_wav(video_file[0])
                of.process_open_face(video_file[0], os.path.dirname(video_file[0]), args.output_raw_path, 
                                     OPENFACE_PATH, args.dbm_group)

                pf.process_facial(video_file[0], args.output_raw_path, args.dbm_group, r_config)
                pf.process_acoustic(video_file[0], args.output_raw_path, args.dbm_group, r_config)
                pf.remove_file(video_file[0])
                pf.process_movement(video_file[0], args.output_raw_path, args.dbm_group, r_config, DLIB_SHAPE_MODEL)

            else:
                logger.info('Enter correct video(*.mp4) file path.')
                
    except Exception as e:
        logger.error('Failed to process mp4 file.')
        pf.remove_file(video_file[0])

def process_raw_audio(args, s_config, r_config):
    """
    Processing audio file
    Args:
        args: user supplied arguments
        s_config: service config object
        r_config: raw feature config object
    """
    try:
        if args.output_raw_path != None:
            audio_file = glob.glob(args.input_path)

            if len(audio_file)>0:
                pf.process_acoustic(audio_file[0], args.output_raw_path, args.dbm_group, r_config)
            else:
                logger.info('Enter correct audio(*.wav) file path.')
    except Exception as e:
        logger.error('Failed to process wav file.')
        
def process_derive(args, r_config, d_config):
    """
    Processing dbm derived variables
    """
    input_file = glob.glob(args.input_path)
    feature_df = der.run_derive(input_file, args.output_raw_path, args.output_derived_path, r_config, d_config)
    

if __name__=="__main__":
    parser = argparse.ArgumentParser(description="Process video/audio......")
    
    parser.add_argument("--input_path", help="path to the input files", required=True)
    
    parser.add_argument("--output_raw_path", help="path to the raw variable output", required=True)
    parser.add_argument("--output_derived_path", help="path to the derived variable output")
    parser.add_argument("--dbm_group", help="list of feature groups", nargs='+')
    
    args = parser.parse_args()
    s_config = config_reader.ConfigReader()
    r_config = config_raw_feature.ConfigRawReader()
    d_config = config_derive_feature.ConfigDeriveReader()
    
    _, file_ext = os.path.splitext(os.path.basename(args.input_path))
    
    if file_ext.lower() == '.mp4':
        process_raw_video(args, s_config, r_config)
    
    elif file_ext.lower() == '.wav':
        process_raw_audio(args, s_config, r_config)
        
    else:
        logger.info('Pipeline accepts mp4 or wav file only.')
    
    if args.output_derived_path != None:
        process_derive(args, r_config, d_config)
    