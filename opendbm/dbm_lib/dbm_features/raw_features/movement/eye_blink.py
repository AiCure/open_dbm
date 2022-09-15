"""
file_name: eye_blink
project_name: DBM
created: 2020-20-07
"""

import logging
import os
import subprocess

import cv2
import dlib
import imutils
import numpy as np
import pandas as pd
from imutils import face_utils
from imutils.video import FileVideoStream
from scipy.signal import find_peaks
from scipy.spatial import distance as dist

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

movement_expr_dir = "movement/eye_blink"
csv_ext = "_eyeblinks.csv"


def get_length(filename):
    result = subprocess.run(
        [
            "ffprobe",
            "-v",
            "error",
            "-show_entries",
            "format=duration",
            "-of",
            "default=noprint_wrappers=1:nokey=1",
            filename,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        stdin=subprocess.DEVNULL,
    )
    return float(result.stdout)


def eye_aspect_ratio(eye):
    """
    Computing eye aspect ratio for an individual frame
    Args:
        eye: Eye landmarks
    Return:
        Eye aspect ratio for a frame
    """
    # euclidean distance for vertical eye landmarks
    dist_cor1 = dist.euclidean(eye[1], eye[5])
    dist_cor2 = dist.euclidean(eye[2], eye[4])

    # euclidean distance for horizontal eye landmark
    dist_cor3 = dist.euclidean(eye[0], eye[3])

    ear = (dist_cor1 + dist_cor2) / (2.0 * dist_cor3)
    return ear


def blink_detection(video_path, facial_landmarks, raw_config):
    """
    Blink detection for each frame
    Args:
        video_path: MP4 file location
        facial_landmarks: Facial landmark pre-trained model path
        raw_config: Raw configuration file object
    Return:
        Dataframe with blink informatiom like blink frame, duration etc.
    """
    tot_frame = 1
    blink_frame = []
    ear_frame = []

    # clip = VideoFileClip(video_path, has_mask=True)
    vid_length = get_length(video_path)

    identifier = dlib.get_frontal_face_detector()  # dlib's face detector (HOG-based)
    forecaster = dlib.shape_predictor(facial_landmarks)  # the facial landmark predictor

    # left and right eye landmarks
    (left_beg, left_end) = face_utils.FACIAL_LANDMARKS_IDXS["left_eye"]
    (right_beg, right_end) = face_utils.FACIAL_LANDMARKS_IDXS["right_eye"]

    f_stream = True
    vid_stream = FileVideoStream(video_path).start()

    while True:
        try:
            # check if stream/frame available in video
            if f_stream and not vid_stream.more():
                break

            # reading & converting frame into grayscale
            vid_frame = vid_stream.read()
            vid_frame = imutils.resize(vid_frame, width=450)
            gray = cv2.cvtColor(vid_frame, cv2.COLOR_BGR2GRAY)

            # detecting face
            rects = identifier(gray, 0)
            for rect in rects:
                lmk = forecaster(gray, rect)
                lmk = face_utils.shape_to_np(lmk)

                l_eye = lmk[left_beg:left_end]  # Extracting left eye ratio
                r_eye = lmk[right_beg:right_end]  # Extracting right eye ratio
                l_ear = eye_aspect_ratio(l_eye)  # eye aspect ratio for left eye
                r_ear = eye_aspect_ratio(r_eye)  # eye aspect ratio for right eye

                ear = (l_ear + r_ear) / 2.0  # average the eye aspect ratio
                blink_frame.append(tot_frame)
                ear_frame.append(ear)

            tot_frame += 1
        except Exception as e:
            e
            logger.info(
                "blink detection processing finished in frame: {}".format(tot_frame - 1)
            )
            continue
    vid_stream.stop()
    blink_df = pd.DataFrame(ear_frame, columns=[raw_config.mov_blink_ear])
    blink_df[raw_config.vid_dur] = vid_length
    blink_df[raw_config.fps] = int(tot_frame / vid_length)
    blink_df[raw_config.mov_blinkframes] = blink_frame

    peaks, _ = find_peaks(
        blink_df[raw_config.mov_blink_ear] * -1, prominence=0.1
    )  # prominence = 0.1 based on tuning
    final_blink_df = blink_df.iloc[peaks, :].reset_index(drop=True)

    u_blink_df = blink_dur(final_blink_df, raw_config)
    u_blink_df["dbm_master_url"] = video_path
    return u_blink_df


def blink_dur(blink_df, raw_config):
    """
    Computing blink duration between each blink
    Args:
        blink_df : Dataframe with blink informatiom like blink frame
        raw_config: Raw configuration file object
    Returns:
        Updated dataframe with blink duration
    """
    if len(blink_df) > 0:
        blink_df[raw_config.mov_blinkdur] = (
            blink_df[raw_config.mov_blinkframes]
            .diff()
            .fillna(blink_df[raw_config.mov_blinkframes])
        )
    else:
        blink_df[raw_config.mov_blinkdur] = np.nan
    blink_df[raw_config.mov_blinkdur] = (
        blink_df[raw_config.mov_blinkdur] / blink_df[raw_config.fps]
    )
    return blink_df


def run_eye_blink(video_uri, out_dir, r_config, facial_landmarks, save=True):
    """
    Processing all patient's for getting eye blink artifacts
    ---------------
    ---------------
    Args:
        video_uri: video path; input_dir : input directory for video's
        out_dir: (str) Output directory for processed output;
        r_config: raw variable config object;
        facial_landmarks: landmark model path
        save: whether to save in csv or not
    """
    try:
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)

        vid_file_path = os.path.exists(video_uri)
        if vid_file_path:

            logger.info(
                "Processing Output file {} ".format(os.path.join(out_loc, fl_name))
            )
            df_blink = blink_detection(video_uri, facial_landmarks, r_config)
            if save:
                ut.save_output(df_blink, out_loc, fl_name, movement_expr_dir, csv_ext)

            return df_blink

    except Exception as e:
        logger.error(f"Failed to process video file: {e}")
