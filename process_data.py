"""
file_name: process_file
project_name: DBM
created: 2020-20-07
"""

from opendbm.dbm_lib.config import config_reader, config_derive_feature, config_raw_feature
from opendbm.dbm_lib.controller import process_feature as pf
from opendbm.dbm_lib import open_face_process as of
from opendbm.dbm_lib.dbm_features.derived_features import derive as der

import pandas as pd
import os
import argparse
import logging
import glob
import time
import subprocess
from os.path import splitext

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

OPENFACE_PATH_VIDEO = 'opendbm/pkg/open_dbm/OpenFace/build/bin/FaceLandmarkVid'
OPENFACE_PATH = 'opendbm/pkg/open_dbm/OpenFace/build/bin/FeatureExtraction'
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

    of.process_open_face(video_file, os.path.dirname(video_file), out_path, OPENFACE_PATH, args.dbm_group,video_tracking=False)
    pf.process_facial(video_file, out_path, args.dbm_group, r_config)
    pf.process_acoustic(video_file, out_path, args.dbm_group, r_config)
    pf.process_nlp(video_file, out_path, args.dbm_group, args.tr, r_config, DEEP_SPEECH)  
    if args.dbm_group == None or len(args.dbm_group)>0 and 'movement' in args.dbm_group:
        of.process_open_face(video_file, os.path.dirname(video_file), out_path, OPENFACE_PATH_VIDEO, args.dbm_group, video_tracking=True)
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
                pf.process_nlp(audio_file[0], out_path, args.dbm_group, args.tr, r_config, DEEP_SPEECH)
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
        vid_loc = glob.glob(args.input_path + '/*.mp4') + glob.glob(args.input_path + '/*.mov') + glob.glob(args.input_path + '/*.MOV')

        if len(vid_loc) == 0:
            logger.info('Directory does not have any MP4 files.')
            return

        logger.info('Calculating raw variables...')
        for vid_file in vid_loc:
            try:
                fname, file_ext = os.path.splitext(vid_file)
                
                if file_ext.lower() == '.mov':
                    convert_file(vid_file)
                common_video(fname+'.mp4', args, r_config)
                
                remove_convert(vid_file, '.mp4') #removing files(ffmpeg converted ) after processing
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
        audio_loc = glob.glob(args.input_path + '/*.wav') + glob.glob(args.input_path + '/*.mp3') + glob.glob(args.input_path + '/*.MP3')

        if len(audio_loc) == 0:
            logger.info('Directory does not have any WAV files.')
            return

        logger.info('Calculating raw variables...')
        for audio in audio_loc:
            try:
                fname, file_ext = os.path.splitext(audio)
                if file_ext.lower() == '.mp3':
                    convert_file(audio)
                    
                out_path = os.path.join(args.output_path, 'raw_variables')
                pf.process_acoustic(fname+'.wav', out_path, args.dbm_group, r_config)
                pf.process_nlp(fname +'.wav', out_path, args.dbm_group, args.tr, r_config, DEEP_SPEECH)
                
                remove_convert(audio, '.wav') #removing files(ffmpeg converted) after processing
            except Exception as e:
                logger.error('Failed to process wav file.')

def convert_file(input_filepath):
    """
    Converting mp3/mov to wav/mp4 files
    """
    _, file_ext = os.path.splitext(os.path.basename(input_filepath))
    fname, _ = splitext(input_filepath)
    call = []
    
    if file_ext.lower() == '.mp3':
        output_filepath = fname + '.wav'
        logger.info('Converting audio from {} to wav'.format(input_filepath))
        call = ['ffmpeg', '-i', input_filepath, output_filepath]

    if file_ext.lower() == '.mov':
        output_filepath = fname + '.mp4'
        logger.info('Converting video from {} to mp4'.format(input_filepath))
        call = ['ffmpeg', '-i', input_filepath, '-vcodec', 'h264','-acodec','aac', '-strict', '-2', output_filepath]

    if len(call)>0:
        subprocess.check_output(call)
        
def remove_convert(input_filepath, file_ext):
    """
    removing converted files after processing
    """
    expected_ext = ['.mp3', '.mov']
    input_loc, inp_ext = os.path.splitext(input_filepath)
    
    if inp_ext.lower() in expected_ext:
        pf.remove_file(input_loc + file_ext, file_ext)

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
    parser.add_argument("--tr", help="speech transcription toogle")

    args = parser.parse_args()
    s_config = config_reader.ConfigReader()
    r_config = config_raw_feature.ConfigRawReader()
    d_config = config_derive_feature.ConfigDeriveReader()

    _, file_ext = os.path.splitext(os.path.basename(args.input_path))

    if file_ext:
        input_type = 'file'

        if file_ext.lower() in ['.mp4','.mov']:
            if file_ext.lower() == '.mov':
                convert_file(args.input_path)
                
            process_raw_video_file(args, s_config, r_config)
            remove_convert(args.input_path, '.mp4')

        elif file_ext.lower() in ['.wav','.mp3']:
            if file_ext.lower() == '.mp3':
                convert_file(args.input_path)
                
            process_raw_audio_file(args, s_config, r_config)
            remove_convert(args.input_path, '.wav')
        else:
            logger.error('No WAV/MP3 or MOV/MP4 files detected in input path')
    else:
        input_type = 'dir'
        process_raw_video_dir(args, s_config, r_config)
        process_raw_audio_dir(args, s_config, r_config)

    process_derive(args, r_config, d_config, input_type)
    exec_time = time.time() - start_time
    logger.info('Done! Processing time: {} seconds'.format(exec_time))
