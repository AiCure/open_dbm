"""
file_name: process_dir
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
    if args.output_raw_path != None:
        vid_loc = glob.glob(args.input_path + '/*.mp4')
        
        if len(vid_loc) == 0:
            logger.info('Directory does not have any mp4 files.')
            return
        
        logger.info('Processing mp4 files.')
        for vid_file in vid_loc:
            try:
                
                pf.audio_to_wav(vid_file)
                of.process_open_face(vid_file, os.path.dirname(vid_file), args.output_raw_path, OPENFACE_PATH, args.dbm_group)
                
                pf.process_facial(vid_file, args.output_raw_path, args.dbm_group, r_config)
                pf.process_acoustic(vid_file, args.output_raw_path, args.dbm_group, r_config)
                pf.remove_file(vid_file)
                pf.process_movement(vid_file, args.output_raw_path, args.dbm_group, r_config, DLIB_SHAPE_MODEL)
                
            except Exception as e:
                logger.error('Failed to process mp4 file.')
                pf.remove_file(vid_file)

def process_raw_audio(args, s_config, r_config):
    """
    Processing audio file
    Args:
        args: user supplied arguments
        s_config: service config object
        r_config: raw feature config object
    """
    if args.output_raw_path != None:
        audio_loc = glob.glob(args.input_path + '/*.wav')
        
        if len(audio_loc) == 0:
            logger.info('Directory does not have any wav files.')
            return
        
        for audio in audio_loc:
            try:
                
                logger.info('Processing wav files.')
                pf.process_acoustic(audio, args.output_raw_path, args.dbm_group, r_config)
                
            except Exception as e:
                logger.error('Failed to process wav file.')
        
def process_derive(args, r_config, d_config):
    """
    Processing dbm derived variables
    Args:
        s_config: service config object
    """
    input_file = glob.glob(args.input_path + '/*')
    feature_df = der.run_derive(input_file, args.output_raw_path, args.output_derived_path, r_config, d_config)

if __name__=="__main__":
    parser = argparse.ArgumentParser(description="Process video/audio......")
    
    parser.add_argument("--input_path", help="path to the input directory", required=True)
    
    parser.add_argument("--output_raw_path", help="dir path to the raw variable output", required=True)
    parser.add_argument("--output_derived_path", help="dir path to the derived variable output")
    parser.add_argument("--dbm_group", help="list of feature groups", nargs='+')
    
    args = parser.parse_args() 
    s_config = config_reader.ConfigReader()
    r_config = config_raw_feature.ConfigRawReader()
    d_config = config_derive_feature.ConfigDeriveReader()
    
    process_raw_video(args, s_config, r_config)
    process_raw_audio(args, s_config, r_config)
    
    if args.output_derived_path != None:
        process_derive(args, r_config, d_config)
    