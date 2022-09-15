"""
file_name: process_features
project_name: DBM
created: 2020-20-07
"""

import glob
import logging
import os
import subprocess
import tempfile
from os.path import basename, dirname, isfile, join, splitext

from opendbm.dbm_lib.dbm_features.raw_features import audio, movement, nlp, video

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def audio_to_wav(input_filepath, tmp=False):
    """Extracts a video's audio file and saves it to wav
    Args:
        input_filepath: (str)
    Returns:
    """
    try:

        fname, _ = splitext(input_filepath)
        if tmp:
            fname = os.path.basename(input_filepath)
            output_filepath = f"{tempfile.gettempdir()}/{fname}.wav"
        else:
            output_filepath = fname + ".wav"

        if not isfile(output_filepath):
            call = [
                "ffmpeg",
                "-i",
                input_filepath,
                "-vn",
                "-acodec",
                "pcm_s16le",
                "-ar",
                "44100",
                output_filepath,
            ]

            logger.info("Converting audio from {} to wav".format(input_filepath))
            subprocess.Popen(
                call,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                stdin=subprocess.PIPE,
            ).wait()
            # subprocess.check_output(call)
            logger.info("wav output saved in {}".format(output_filepath))
        else:
            logger.info("Output file {} already exists".format(output_filepath))
        return output_filepath

    except Exception as e:
        logger.error("Failed to extract audio from Video", e)


def process_acoustic(video_uri, out_dir, dbm_group, r_config):
    """
    processing acoustic features
    Args:
        video_uri: video path; out_dir: raw variable output dir
        dbm_group: list of features group to process; r_config: raw feature config object
    """
    if dbm_group is not None and len(dbm_group) > 0 and "acoustic" not in dbm_group:
        return

    logger.info("Processing acoustic variables from data in {}".format(video_uri))
    logger.info("processing audio intensity....")
    audio.intensity.run_intensity(video_uri, out_dir, r_config)

    logger.info("processing audio pitch freq....")
    audio.pitch_freq.run_pitch(video_uri, out_dir, r_config)

    logger.info("processing HNR....")
    audio.hnr.run_hnr(video_uri, out_dir, r_config)

    logger.info("processing GNE....")
    audio.gne.run_gne(video_uri, out_dir, r_config)

    logger.info("processing voice frame score....")
    audio.voice_frame_score.run_vfs(video_uri, out_dir, r_config)

    logger.info("processing formant frequency....")
    audio.formant_freq.run_formant(video_uri, out_dir, r_config)

    logger.info("processing pause segment....")
    audio.pause_segment.run_pause_segment(video_uri, out_dir, r_config)

    logger.info("processing jitter....")
    audio.jitter.run_jitter(video_uri, out_dir, r_config)

    logger.info("processing shimmer....")
    audio.shimmer.run_shimmer(video_uri, out_dir, r_config)

    logger.info("processing mfcc....")
    audio.mfcc.run_mfcc(video_uri, out_dir, r_config)


def process_facial(video_uri, out_dir, dbm_group, r_config):
    """
    processing facial features
    Args:
        video_uri: video path; out_dir: raw variable output dir
        dbm_group: list of features to process; r_config: raw feature config object
    """
    if dbm_group is not None and len(dbm_group) > 0 and "facial" not in dbm_group:
        return

    logger.info("Processing facial variables from data in {}".format(video_uri))
    logger.info("processing facial asymmetry....")
    video.face_asymmetry.run_face_asymmetry(video_uri, out_dir, r_config)

    logger.info("processing facial Action Unit....")
    video.face_au.run_face_au(video_uri, out_dir, r_config)

    logger.info("processing facial expressivity....")
    video.face_emotion_expressivity.run_face_expressivity(video_uri, out_dir, r_config)

    logger.info("processing facial landmark....")
    video.face_landmark.run_face_landmark(video_uri, out_dir, r_config)


def process_movement(video_uri, out_dir, dbm_group, r_config, dlib_model):
    """
    processing facial features
    Args:
        video_uri: video path; out_dir: raw variable output dir
        dbm_group: list of features to process; r_config: raw feature config object
        dlib_model: shape predictor model path
    """
    if dbm_group is not None and len(dbm_group) > 0 and "movement" not in dbm_group:
        return

    logger.info("Processing movement variables from data in {}".format(video_uri))

    logger.info("processing head movement....")
    movement.head_motion.run_head_movement(video_uri, out_dir, r_config)

    logger.info("processing eye blink....")
    movement.eye_blink.run_eye_blink(video_uri, out_dir, r_config, dlib_model)

    logger.info("processing eye gaze....")
    movement.eye_gaze.run_eye_gaze(video_uri, out_dir, r_config)

    logger.info("processing voice tremor....")
    movement.voice_tremor.run_vtremor(video_uri, out_dir, r_config)

    logger.info("processing facial tremor....")
    movement.facial_tremor.fac_tremor_process(
        video_uri, out_dir, r_config, model_output=True
    )


def process_nlp(video_uri, out_dir, dbm_group, tran_tog, r_config, deep_path):
    """
    processing nlp features
    Args:
        video_uri: video path; out_dir: raw variable output dir
        dbm_group: list of features to process; r_config: raw feature config object
        deep_path: deep speech build path
    """
    if dbm_group is not None and len(dbm_group) > 0 and "speech" not in dbm_group:
        return

    logger.info("Processing nlp variables from data in {}".format(video_uri))
    nlp.transcribe.run_transcribe(video_uri, out_dir, r_config, deep_path)
    nlp.speech_features.run_speech_feature(video_uri, out_dir, r_config, tran_tog)


def remove_file(file_path, file_ext=".wav"):
    """
    removing wav file
    """
    file_dir = dirname(file_path)
    file_name, _ = splitext(basename(file_path))
    wav_file = glob.glob(join(file_dir, file_name + file_ext))

    if len(wav_file) > 0:
        os.remove(wav_file[0])
