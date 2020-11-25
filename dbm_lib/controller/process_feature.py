"""
file_name: process_features
project_name: DBM
created: 2020-20-07
"""

from dbm_lib.dbm_features.raw_features.audio import intensity, pitch_freq, hnr, gne, voice_frame_score, formant_freq
from dbm_lib.dbm_features.raw_features.audio import pause_segment, jitter, shimmer, mfcc
from dbm_lib.dbm_features.raw_features.video import face_asymmetry, face_au, face_emotion_expressivity, face_landmark
from dbm_lib.dbm_features.raw_features.movement import head_motion, eye_blink, voice_tremor, facial_tremor

import subprocess
import logging
from os.path import isfile, splitext, basename, dirname, join
import glob
import os

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

def audio_to_wav(input_filepath):
    """ Extracts a video's audio file and saves it to wav
    Args:
        input_filepath: (str)
    Returns:
    """
    try:

        fname, _ = splitext(input_filepath)
        output_filepath = fname + '.wav'

        if not isfile(output_filepath):
            call = ['ffmpeg', '-i', input_filepath, '-vn', '-acodec', 'pcm_s16le', '-ar', '44100', output_filepath]

            logger.info('Converting audio from {} to wav'.format(input_filepath))
            subprocess.check_output(call)
            logger.info('wav output saved in {}'.format(output_filepath))
        else:
            logger.info('Output file {} already exists'.format(output_filepath))

    except Exception as e:
        logger.error('Failed to extract audio from Video')

def process_acoustic(video_uri, out_dir, dbm_group, r_config):
    """
    processing acoustic features
    Args:
        video_uri: video path; out_dir: raw variable output dir
        dbm_group: list of features group to process; r_config: raw feature config object
    """
    if dbm_group != None and len(dbm_group)>0 and 'acoustic' not in dbm_group:
        return

    logger.info('Processing acoustic variables from data in {}'.format(video_uri))
    logger.info('processing audio intensity....')
    intensity.run_intensity(video_uri, out_dir, r_config)

    logger.info('processing audio pitch freq....')
    pitch_freq.run_pitch(video_uri, out_dir, r_config)

    logger.info('processing HNR....')
    hnr.run_hnr(video_uri, out_dir, r_config)

    logger.info('processing GNE....')
    gne.run_gne(video_uri, out_dir, r_config)

    logger.info('processing voice frame score....')
    voice_frame_score.run_vfs(video_uri, out_dir, r_config)

    logger.info('processing formant frequency....')
    formant_freq.run_formant(video_uri, out_dir, r_config)

    logger.info('processing pause segment....')
    pause_segment.run_pause_segment(video_uri, out_dir, r_config)

    logger.info('processing jitter....')
    jitter.run_jitter(video_uri, out_dir, r_config)

    logger.info('processing shimmer....')
    shimmer.run_shimmer(video_uri, out_dir, r_config)

    logger.info('processing mfcc....')
    mfcc.run_mfcc(video_uri, out_dir, r_config)

    logger.info('processing voice tremor....')
    voice_tremor.run_vtremor(video_uri, out_dir, r_config)

def process_facial(video_uri, out_dir, dbm_group, r_config):
    """
    processing facial features
    Args:
        video_uri: video path; out_dir: raw variable output dir
        dbm_group: list of features to process; r_config: raw feature config object
    """
    if dbm_group != None and len(dbm_group)>0 and 'facial' not in dbm_group:
        return

    logger.info('Processing facial variables from data in {}'.format(video_uri))
    logger.info('processing facial asymmetry....')
    face_asymmetry.run_face_asymmetry(video_uri, out_dir, r_config)

    logger.info('processing facial Action Unit....')
    face_au.run_face_au(video_uri, out_dir, r_config)

    logger.info('processing facial expressivity....')
    face_emotion_expressivity.run_face_expressivity(video_uri, out_dir, r_config)

    logger.info('processing facial landmark....')
    face_landmark.run_face_landmark(video_uri, out_dir, r_config)

def process_movement(video_uri, out_dir, dbm_group, r_config, dlib_model):
    """
    processing facial features
    Args:
        video_uri: video path; out_dir: raw variable output dir
        dbm_group: list of features to process; r_config: raw feature config object
        dlib_model: shape predictor model path
    """
    if dbm_group != None and len(dbm_group)>0 and 'movement' not in dbm_group:
        return

    logger.info('Processing movement variables from data in {}'.format(video_uri))

    logger.info('processing head movement....')
    head_motion.run_head_movement(video_uri, out_dir, r_config)

    logger.info('processing eye blink....')
    eye_blink.run_eye_blink(video_uri, out_dir, r_config, dlib_model)

    logger.info('processing voice tremor....')
    voice_tremor.run_vtremor(video_uri, out_dir, r_config)

    logger.info('processing facial tremor....')
    face_tremor.fac_tremor_process(video_uri, out_dir, r_config, model_output=True)

def remove_file(file_path):
    """
    removing wav file
    """
    file_dir = dirname(file_path)
    file_name, _ = splitext(basename(file_path))
    wav_file = glob.glob(join(file_dir, file_name + '.wav'))

    if len(wav_file)> 0:
        os.remove(wav_file[0])
