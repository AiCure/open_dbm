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
import time

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

OPENFACE_PATH = 'pkg/OpenFace/build/bin/FeatureExtraction'
DEEP_SPEECH = 'pkg/DeepSpeech'
DLIB_SHAPE_MODEL = 'pkg/shape_detector/shape_predictor_68_face_landmarks.dat'

def common_video(video_file, args, r_config):
    """
    Common function for video feature processing
    Args:
        video_file: video file path
        args: user supplied arguments
        r_config: raw feature config object
    """
    out_path = os.path.join(args.output_path, 'raw_variables')
    pf.audio_to_wav(video_file)
    of.process_open_face(video_file, os.path.dirname(video_file), out_path, OPENFACE_PATH, args.dbm_group)
    pf.process_facial(video_file, out_path, args.dbm_group, r_config)
    pf.process_acoustic(video_file, out_path, args.dbm_group, r_config)
    pf.process_nlp(video_file, out_path, args.dbm_group, r_config, DEEP_SPEECH)
    
    pf.process_movement(video_file, out_path, args.dbm_group, r_config, DLIB_SHAPE_MODEL)
    pf.remove_file(video_file)

def process_raw_video_file(args, s_config, r_config):
    """
    Processing video file
    Args:
        args: user supplied arguments
        s_config: service config object
        r_config: raw feature config object
    """
    try:
        if args.output_path != None:
            video_file = glob.glob(args.input_path)

            if len(video_file)>0:
                logger.info('Calculating raw variables...')
                common_video(video_file[0], args, r_config)

            else:
                logger.info('Enter correct video(*.mp4) file path.')

    except Exception as e:
        logger.error('Failed to process mp4 file.')
        pf.remove_file(video_file[0])

def process_raw_audio_file(args, s_config, r_config):
    """
    Processing audio file
    Args:
        args: user supplied arguments
        s_config: service config object
        r_config: raw feature config object
    """
    try:
        if args.output_path != None:
            audio_file = glob.glob(args.input_path)

            if len(audio_file)>0:
                logger.info('Calculating raw variables...')

                out_path = os.path.join(args.output_path, 'raw_variables')
                pf.process_acoustic(audio_file[0], out_path, args.dbm_group, r_config)
                pf.process_nlp(audio_file[0], out_path, args.dbm_group, r_config, DEEP_SPEECH)
                
            else:
                logger.info('Enter correct audio(*.wav) file path.')
    except Exception as e:
        logger.error('Failed to process wav file.')

def process_raw_video_dir(args, s_config, r_config):
    """
    Processing video file
    Args:
        args: user supplied arguments
        s_config: service config object
        r_config: raw feature config object
    """
    if args.output_path != None:
        vid_loc = glob.glob(args.input_path + '/*.mp4')

        if len(vid_loc) == 0:
            logger.info('Directory does not have any MP4 files.')
            return

        logger.info('Calculating raw variables...')
        for vid_file in vid_loc:
            try:
                common_video(vid_file, args, r_config)
            except Exception as e:
                logger.error('Failed to process mp4 file.')
                pf.remove_file(vid_file)

def process_raw_audio_dir(args, s_config, r_config):
    """
    Processing audio file
    Args:
        args: user supplied arguments
        s_config: service config object
        r_config: raw feature config object
    """
    if args.output_path != None:
        audio_loc = glob.glob(args.input_path + '/*.wav')

        if len(audio_loc) == 0:
            logger.info('Directory does not have any WAV files.')
            return

        logger.info('Calculating raw variables...')
        for audio in audio_loc:
            try:

                out_path = os.path.join(args.output_path, 'raw_variables')
                pf.process_acoustic(audio, out_path, args.dbm_group, r_config)
                pf.process_nlp(audio, out_path, args.dbm_group, r_config, DEEP_SPEECH)
                
            except Exception as e:
                logger.error('Failed to process wav file.')

def process_derive(args, r_config, d_config, input_type):
    """
    Processing dbm derived variables
    """
    if input_type == 'file':
        input_file = glob.glob(args.input_path)
    else:
        input_file = glob.glob(args.input_path + '/*')

    out_raw_path = os.path.join(args.output_path, 'raw_variables')
    out_derive_path = os.path.join(args.output_path, 'derived_variables')

    logger.info('Calculating derived variables...')
    feature_df = der.run_derive(input_file, out_raw_path, out_derive_path, r_config, d_config)

if __name__=="__main__":
    start_time = time.time()
    parser = argparse.ArgumentParser(description="Process video/audio......")

    parser.add_argument("--input_path", help="path to the input files", required=True)
    parser.add_argument("--output_path", help="path to the raw and derived variable output", required=True)
    parser.add_argument("--dbm_group", help="list of feature groups", nargs='+')

    args = parser.parse_args()
    s_config = config_reader.ConfigReader()
    r_config = config_raw_feature.ConfigRawReader()
    d_config = config_derive_feature.ConfigDeriveReader()

    _, file_ext = os.path.splitext(os.path.basename(args.input_path))

    if file_ext:
        input_type = 'file'
        if file_ext.lower() == '.mp4':
            process_raw_video_file(args, s_config, r_config)

        elif file_ext.lower() == '.wav':
            process_raw_audio_file(args, s_config, r_config)

        else:
            logger.error('No WAV or MP4 files detected in input path')
    else:
        input_type = 'dir'
        process_raw_video_dir(args, s_config, r_config)
        process_raw_audio_dir(args, s_config, r_config)

    process_derive(args, r_config, d_config, input_type)
    exec_time = time.time() - start_time
    logger.info('Done! Processing time: {} seconds'.format(exec_time))
