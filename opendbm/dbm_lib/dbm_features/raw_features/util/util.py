"""
file_name: util
project_name: DBM
created: 2020-20-07
"""

import glob
import os
import subprocess

import more_itertools as mit
import numpy as np
import pandas as pd


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


def process_segment_pitch(ff_df, r_config):
    voice_label = ff_df[r_config.aco_voiceLabel]

    indices_yes = [i for i, x in enumerate(voice_label) if x == "yes"]
    voiced_yes = [list(group) for group in mit.consecutive_groups(indices_yes)]

    indices_no = [i for i, x in enumerate(voice_label) if x == "no"]
    voiced_no = [list(group) for group in mit.consecutive_groups(indices_no)]

    com_speech = voiced_yes + voiced_no
    com_speech_sort = sorted(com_speech, key=lambda x: x[0])
    return com_speech_sort, voiced_yes, voiced_no


def segment_pitch(dir_path, r_config, ff_df=None):
    """
    segmenting pitch freq for each voice segment
    """
    com_speech_sort, voiced_yes, voiced_no = ([],) * 3

    for file in os.listdir(dir_path):
        try:
            if file.endswith("_pitch.csv") and ff_df is None:
                ff_df = pd.read_csv((dir_path + "/" + file))
                com_speech_sort, voiced_yes, voiced_no
        except:
            pass

    return com_speech_sort, voiced_yes, voiced_no


def filter_path(video_url, out_dir):

    """
    Filtering video uri path to prepare input and ouptut location

    Args:
        video_url: S3 bucket path for video
        out_dir: Output directory path

    """

    fl_name, _ = os.path.splitext(os.path.basename(video_url))
    input_loc = os.path.dirname(video_url)
    out_loc = os.path.join(out_dir, fl_name)
    return input_loc, out_loc, fl_name


def save_output(df, out_loc, fl_name, f_dir, f_ext):
    """
    creating output directory for Audio features
    Args:
        df: (dataframe) feature dataframe[ex: Formant freq, pitch]
        out_loc: (dir) Output location where we want to save raw output
        fl_name: file name
        f_dir: directory name for a feature
        f_ext: extension for a feature [ex: '_pose.csv']
    """
    full_f_name = fl_name + f_ext
    dir_path = os.path.join(out_loc, f_dir)

    if not os.path.exists(dir_path):
        os.makedirs(dir_path)

    sav_path = os.path.join(dir_path, full_f_name)
    df.to_csv(sav_path, index=False)


def audio_process(base_dir, video_url):
    """
    Parsing cleaned audio files(Audio files without IMA voice)
    Args:
        base_dir: Base path for raw data
        video_url: Raw video file path
    """
    new_video_url = base_dir + "/".join(video_url[2:])
    split_val = new_video_url.split("/")
    wav_path = "/".join(split_val[0 : len(split_val) - 1])
    audio_split_check = glob.glob(wav_path + "/*_split.wav")
    return audio_split_check


def compute_open_face_features(
    input_filepath,
    output_directory,
    open_face_executable,
    au_static=False,
    tracked_visualization=False,
    clobber=False,
    verbose=True,
):
    """
    Runs OpenFace on an input video.
    See https://github.com/TadasBaltrusaitis/OpenFace/wiki/Command-line-arguments
    Args:
        input_filepath:
        output_directory:
        au_static:
        tracked_visualization:
        open_face_executable:
        clobber: (bool) if True existing files will be overwritten
        verbose:
    Returns:
        (str) path to output csv file
    Raises:
        IOError if OpenFace executable is missing
    """

    if not os.path.isfile(open_face_executable):
        raise IOError(
            "OpenFace executable {} could not be found.".format(open_face_executable)
        )

    bn, _ = os.path.splitext(os.path.basename(input_filepath))
    if not output_directory:
        output_directory = os.path.join(
            os.path.dirname(input_filepath), bn + "_openface"
        )

    output_csv = os.path.join(output_directory, bn + ".csv")
    if not os.path.isfile(output_csv) or clobber:
        call = [
            open_face_executable,
        ]
        if au_static:
            call += [
                "-au_static",
            ]

        if tracked_visualization:
            call += [
                "-tracked",
            ]

        call += ["-q", "-2Dfp", "-3Dfp", "-pdmparams", "-pose", "-aus", "-gaze"]
        call += ["-f", input_filepath, "-out_dir", output_directory]

        if verbose:
            print(
                "Computing OpenFace features {} from video file".format(input_filepath)
            )
        subprocess.check_output(call)
        if verbose:
            print("OpenFace features saved to {}".format(output_directory))
    else:
        if verbose:
            print("Output file {} already exists".format(output_csv))

    return os.path.join(output_directory, bn + ".csv")
