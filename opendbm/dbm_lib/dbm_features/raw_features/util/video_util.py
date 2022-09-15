"""
file_name: video_util
project_name: DBM
created: 2020-20-07
"""

import glob

import numpy as np
import pandas as pd

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut


def smooth(x, window_len=11, window="hanning"):
    """smooth the data using a window with requested size.

    This method is based on the convolution of a scaled window with the signal.
    The signal is prepared by introducing reflected copies of the signal
    (with the window size) in both ends so that transient parts are minimized
    in the begining and end part of the output signal.

    input:
        x: the input signal
        window_len: the dimension of the smoothing window; should be an odd integer
        window: the type of window from 'flat', 'hanning', 'hamming', 'bartlett', 'blackman'
            flat window will produce a moving average smoothing.

    output:
        the smoothed signal

    example:

    t=linspace(-2,2,0.1)
    x=sin(t)+randn(len(t))*0.1
    y=smooth(x)

    see also:

    numpy.hanning, numpy.hamming, numpy.bartlett, numpy.blackman, numpy.convolve
    scipy.signal.lfilter

    TODO: the window parameter could be the window itself if an array instead of a string
    NOTE: length(output) != length(input), to correct this: return y[(window_len/2-1):-(window_len/2)] instead of just y.
    """
    if x.ndim != 1:
        raise (ValueError, "smooth only accepts 1 dimension arrays.")
    if x.size < window_len:
        raise (ValueError, "Input vector needs to be bigger than window size.")
    if window_len < 3:
        return x
    if window not in ["flat", "hanning", "hamming", "bartlett", "blackman"]:
        raise (
            ValueError,
            "Window is on of 'flat', 'hanning', 'hamming', 'bartlett', 'blackman'",
        )
    s = np.r_[x[window_len - 1 : 0 : -1], x, x[-2 : -window_len - 1 : -1]]
    # print(len(s))
    if window == "flat":  # moving average
        w = np.ones(window_len, "d")
    else:
        w = eval("np." + window + "(window_len)")
    y = np.convolve(w / w.sum(), s, mode="valid")
    return y[int(window_len / 2) : -int(window_len / 2)]


def filter_by_confidence_and_thresh(x, fea, thresh):
    if x["s_confidence"] > 0.2 and np.fabs(x[fea]) < thresh:
        return x[fea]
    else:
        return np.NaN


def add_au_emotion(x, emotion, emotion_type, exp_type):
    """
    computing individula emotion expressivity matrix
    Args:
        emotion: Action Unit
    """
    error_reason = "Pass"
    if x["s_confidence"] > 0.8:  # if using smooth, no need for 'success'
        sum_r = 0
        cnt = 0
        for au in emotion:
            au_c_label = " AU{:02d}_c".format(au)
            au_r_label = " AU{:02d}_r".format(au)
            if x[au_c_label] == 1 and (
                not np.isnan(x[au_r_label])
            ):  # there are data with face in, but au_c=0
                sum_r += x[au_r_label]
                cnt += 6
            if (
                exp_type == "full" and x[au_c_label] == 0
            ):  # Logic to compute emotion expressivity when all AU's are present
                cnt = 0
                break
        if cnt > 0:
            sum_r /= cnt
        else:
            sum_r = 0
        v_emo = x[emotion_type] + sum_r
    else:
        v_emo = np.NaN
        error_reason = "confidence less than 80%"

    return v_emo, error_reason


def add_au_occ(x, emotion, emotion_type):
    """
    computing individula emotion presence
    Args:
        emotion: Action Unit
    """
    au_pres = []
    em_pres = 0
    error_reason = "Pass"
    if x["s_confidence"] > 0.8:  # if using smooth, no need for 'success'
        for au in emotion:
            au_c_label = " AU{:02d}_c".format(au)
            if x[au_c_label] == 1:  # there are data with face in, but au_c=0
                au_pres.append(1)

        if len(au_pres) == len(emotion):
            em_pres = 1
    else:
        em_pres = np.NaN
        error_reason = "confidence less than 80%"
    return em_pres, error_reason


def emotion_exp(em_au, of, em_col, err_col):
    """
    Computing individual emotion expressivity and adding it to dataframe
    """
    for emotion in em_au:
        of[[em_col[0], err_col]] = of.apply(
            add_au_emotion,
            args=(
                emotion,
                em_col[0],
                "partial",
            ),
            axis=1,
            result_type="expand",
        )
        of[[em_col[1], err_col]] = of.apply(
            add_au_emotion,
            args=(
                emotion,
                em_col[1],
                "full",
            ),
            axis=1,
            result_type="expand",
        )


def emotion_pres(em_au, of, em_col, err_col):
    """
    Computing individual emotion expressivity and adding it to dataframe
    """
    for emotion in em_au:
        of[[em_col, err_col]] = of.apply(
            add_au_occ,
            args=(
                emotion,
                em_col,
            ),
            axis=1,
            result_type="expand",
        )


def calc_of_for_video(of, face_cfg, fe_cfg):
    """
    Creating dataframe for emotion expressivity
    """
    new_cols = [
        fe_cfg.hap_exp,
        fe_cfg.sad_exp,
        fe_cfg.sur_exp,
        fe_cfg.fea_exp,
        fe_cfg.ang_exp,
        fe_cfg.dis_exp,
        fe_cfg.con_exp,
        fe_cfg.pai_exp,
        fe_cfg.neg_exp,
        fe_cfg.pos_exp,
        fe_cfg.neu_exp,
        fe_cfg.com_lower_exp,
        fe_cfg.com_upper_exp,
        fe_cfg.cai_exp,
        fe_cfg.com_exp,
        fe_cfg.happ_occ,
        fe_cfg.sad_occ,
        fe_cfg.sur_occ,
        fe_cfg.fea_occ,
        fe_cfg.ang_occ,
        fe_cfg.dis_occ,
        fe_cfg.con_occ,
        fe_cfg.hap_exp_full,
        fe_cfg.sad_exp_full,
        fe_cfg.sur_exp_full,
        fe_cfg.fea_exp_full,
        fe_cfg.ang_exp_full,
        fe_cfg.dis_exp_full,
        fe_cfg.con_exp_full,
        fe_cfg.pai_exp_full,
        fe_cfg.neg_exp_full,
        fe_cfg.pos_exp_full,
        fe_cfg.neu_exp_full,
        fe_cfg.cai_exp_full,
        fe_cfg.com_lower_exp_full,
        fe_cfg.com_upper_exp_full,
        fe_cfg.com_exp_full,
    ]
    of[new_cols] = pd.DataFrame([[0] * len(new_cols)], index=of.index)
    of[fe_cfg.err_reason] = "Pass"

    # Composite happiness expressivity
    emotion_exp(
        face_cfg.happiness, of, [fe_cfg.hap_exp, fe_cfg.hap_exp_full], fe_cfg.err_reason
    )
    # Composite sadness expressivity
    emotion_exp(
        face_cfg.sadness, of, [fe_cfg.sad_exp, fe_cfg.sad_exp_full], fe_cfg.err_reason
    )
    # Composite surprise expressivity
    emotion_exp(
        face_cfg.surprise, of, [fe_cfg.sur_exp, fe_cfg.sur_exp_full], fe_cfg.err_reason
    )
    # Composite fear expressivity
    emotion_exp(
        face_cfg.fear, of, [fe_cfg.fea_exp, fe_cfg.fea_exp_full], fe_cfg.err_reason
    )
    # Composite anger expressivity
    emotion_exp(
        face_cfg.anger, of, [fe_cfg.ang_exp, fe_cfg.ang_exp_full], fe_cfg.err_reason
    )
    # Composite disgust expressivity
    emotion_exp(
        face_cfg.disgust, of, [fe_cfg.dis_exp, fe_cfg.dis_exp_full], fe_cfg.err_reason
    )
    # Composite contempt expressivity
    emotion_exp(
        face_cfg.contempt, of, [fe_cfg.con_exp, fe_cfg.con_exp_full], fe_cfg.err_reason
    )
    # Composite Negative Expressivity
    emotion_exp(
        face_cfg.NEG_ACTION_UNITS,
        of,
        [fe_cfg.neg_exp, fe_cfg.neg_exp_full],
        fe_cfg.err_reason,
    )
    # Composite Positive Expressivity
    emotion_exp(
        face_cfg.POS_ACTION_UNITS,
        of,
        [fe_cfg.pos_exp, fe_cfg.pos_exp_full],
        fe_cfg.err_reason,
    )
    # Composite Neutral Expressivity
    emotion_exp(
        face_cfg.NET_ACTION_UNITS,
        of,
        [fe_cfg.neu_exp, fe_cfg.neu_exp_full],
        fe_cfg.err_reason,
    )
    # Composite Activation Expressivity
    emotion_exp(
        face_cfg.cai, of, [fe_cfg.cai_exp, fe_cfg.cai_exp_full], fe_cfg.err_reason
    )
    # Composite Expressivity
    emotion_exp(
        face_cfg.ACTION_UNITS,
        of,
        [fe_cfg.com_exp, fe_cfg.com_exp_full],
        fe_cfg.err_reason,
    )
    # Composite lower face expressivity
    emotion_exp(
        face_cfg.LOWER_ACTION_UNITS,
        of,
        [fe_cfg.com_lower_exp, fe_cfg.com_lower_exp_full],
        fe_cfg.err_reason,
    )
    # Composite upper face Expressivity
    emotion_exp(
        face_cfg.UPPER_ACTION_UNITS,
        of,
        [fe_cfg.com_upper_exp, fe_cfg.com_upper_exp_full],
        fe_cfg.err_reason,
    )
    # Composite pain expressivity
    emotion_exp(
        face_cfg.pain, of, [fe_cfg.pai_exp, fe_cfg.pai_exp_full], fe_cfg.err_reason
    )
    # AU happiness presence
    emotion_pres(face_cfg.happiness, of, fe_cfg.happ_occ, fe_cfg.err_reason)
    # AU Sad presence
    emotion_pres(face_cfg.sadness, of, fe_cfg.sad_occ, fe_cfg.err_reason)
    # AU Surprise presence
    emotion_pres(face_cfg.surprise, of, fe_cfg.sur_occ, fe_cfg.err_reason)
    # AU fear presence
    emotion_pres(face_cfg.fear, of, fe_cfg.fea_occ, fe_cfg.err_reason)
    # AU anger presence
    emotion_pres(face_cfg.anger, of, fe_cfg.ang_occ, fe_cfg.err_reason)
    # AU disgust presence
    emotion_pres(face_cfg.disgust, of, fe_cfg.dis_occ, fe_cfg.err_reason)
    # AU contempt presence
    emotion_pres(face_cfg.contempt, of, fe_cfg.con_occ, fe_cfg.err_reason)
