"""
file_name: facial_tremor
project_name: cdx_analysis
created: 2019-03-16
author: Deshana Desai
"""
import glob
import os
import sys

import cv2
import numpy as np
import pandas as pd


def euclidean_distance(point1, point2):
    """
    Compute euclidean distance between points
    """

    return np.sqrt((point1[0] - point2[0]) ** 2 + (point1[1] - point2[1]) ** 2)


# def detect_peaks()


def expand_landmarks(landmarks):
    """
    util method to expand landmark list:
    eg: [1,2] -> [['l1_x', 'l1_y'], ['l2_x', 'l2_y']]
    """
    return [["l{}_x".format(point), "l{}_y".format(point)] for point in landmarks]


def calc_displacement_vec(df, landmarks, num_frames):
    """
    Calculates displacement vector frame by frame
    """

    landmarks = expand_landmarks(landmarks)

    disp_vec = np.zeros((len(landmarks), num_frames))
    prev_point = np.zeros((len(landmarks), 2))

    # initialize
    for j, pair in enumerate(landmarks):
        first_row = df.iloc[0]
        prev_point[j] = (first_row[pair[0]], first_row[pair[1]])

    for i in range(num_frames):
        frame_row = df.iloc[i]
        for j, pair in enumerate(landmarks):
            x, y = pair[0], pair[1]
            current = (frame_row[x], frame_row[y])
            deviation = euclidean_distance(current, prev_point[j])
            disp_vec[j][i] = deviation
            prev_point[j] = current

    return disp_vec
