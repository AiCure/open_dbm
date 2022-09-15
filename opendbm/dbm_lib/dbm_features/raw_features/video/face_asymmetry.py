"""
file_name: face_asymmetry.py
project_name: DBM
created: 2020-20-07
"""

import datetime
import glob
import logging
import os
import subprocess
import time
from os.path import join

import cv2
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from mpl_toolkits import mplot3d
from scipy.spatial.transform import Rotation as R

from opendbm.dbm_lib.dbm_features.raw_features.util import util as ut
from opendbm.dbm_lib.dbm_features.raw_features.util import video_util as vu

from .face_config.face_config_reader import ConfigFaceReader

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

face_asym_dir = "facial/face_asymmetry"
csv_ext = "_facasym.csv"

cv2_color_purple = (254, 19, 188)
color_blue = (0, 0, 1.0)
color_green = (0, 1.0, 0)
color_red = (1.0, 0, 0)
color_y = (1.0, 1.0, 0)

error_code_message = {
    0: "pass",
    1: "confidence less than 80%",
}
error_message_code = {y: x for x, y in error_code_message.items()}


def visualize_vid(fn, attr=None, write_out=False):

    vid = cv2.VideoCapture(fn)
    # tot = int(vid.get(cv2.CAP_PROP_FRAME_COUNT))
    fps = vid.get(cv2.CAP_PROP_FPS)
    # frame_width = int(vid.get(3))
    # frame_height = int(vid.get(4))

    if write_out:
        fig_w = 680  # 680 667 676 #frame_width in order of Ali, Vennessa, synthesis
        fig_h = 659  # 659 659 659 #frame_height
        out_vid = cv2.VideoWriter(
            "out.mp4", cv2.VideoWriter_fourcc(*"MP4V"), fps, (fig_w, fig_h)
        )

    plt.figure(figsize=(8, 8))
    try:
        frameid = 0
        while True:
            ret, frame = vid.read()
            if not ret:
                # Release the Video Device if ret is false
                vid.release()
                print("Released Video Resource")
                break
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frameid += 1
            logger.info(frameid, frame.shape)

            if "lmks_frms" in attr:
                lmks_frms = attr["lmks_frms"]
                for i in range(lmks_frms[frameid].shape[0]):
                    cv2.circle(
                        frame,
                        (int(lmks_frms[frameid][i, 0]), int(lmks_frms[frameid][i, 1])),
                        2,
                        cv2_color_purple,
                        -1,
                    )

            if write_out:
                cv2.putText(
                    frame,
                    "Frame: " + str(frameid),
                    (10, 50),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    1,
                    (255, 255, 255),
                    3,
                )

            plt.subplot(211)
            plt.imshow(frame)
            plt.axis("off")
            plt.pause(0.2)

            if "score_asym" in attr:
                ax = plt.subplot(212)
                ax.cla()
                ax.set_xlim(0, 140)  # ax.set_xlim(0,300)
                ax.set_ylim(0, 10)

                sa = attr["score_asym"]
                s = sa[np.where(sa[:, 0] <= frameid), :][0, :, :]

                for i in range(1, s.shape[1]):
                    plt.plot(s[:, 0], s[:, i])

                plt.legend(["mouth", "eyebrow", "eye", "mouth+eye+eyebrow"])
                plt.minorticks_on()
                plt.grid(b=True, which="major", color="r", linestyle="-")
                plt.grid(b=True, which="minor", color="r", linestyle="--")

                plt.savefig("tmp.png", bbox_inches="tight")
                print(cv2.imread("tmp.png").shape)

            plt.clf()
            if write_out:
                out_vid.write(cv2.imread("tmp.png"))

    except KeyboardInterrupt:
        # Release the Video Device
        vid.release()
        if write_out:
            out_vid.release()
        logger.info("Exception, and Video Resource Released")

    if write_out:
        out_vid.release()


def retrieve_attr(of_df):
    """
    Retrieve landmarks and pose_translation for each frame from openface output
    Args:
        of_df: dataframe output from openface, including detected landmark coordinates
    Returns:
        lmks_frms: dictionary, with frame id as key and 68 landmark set as value
        pose_p: dictionary, with frame id as key and pose param as value
    """
    tot_lmks = 68  # openface specific
    if len([i for i in of_df.columns.to_list() if " x_" in i]) != tot_lmks:
        return {}

    lmks_frms = {}
    pose_p = {}

    for fi in sorted(of_df["frame"].to_list()):
        lmks = np.zeros((tot_lmks, 6))
        r = of_df[of_df["frame"] == fi]

        for i in range(tot_lmks):
            lmk_y = r[" y_" + str(i)].iloc[0]
            lmk_x = r[" x_" + str(i)].iloc[0]
            lmk_X = r[" X_" + str(i)].iloc[0]
            lmk_Y = r[" Y_" + str(i)].iloc[0]
            lmk_Z = r[" Z_" + str(i)].iloc[0]

            confi = r[" confidence"]
            lmks[i, :] = [lmk_x, lmk_y, lmk_X, lmk_Y, lmk_Z, confi]

        lmks_frms[fi] = lmks
        pose_p[fi] = [
            r[" pose_Tx"].iloc[0],
            r[" pose_Ty"].iloc[0],
            r[" pose_Tz"].iloc[0],
            r[" pose_Rx"].iloc[0],
            r[" pose_Ry"].iloc[0],
            r[" pose_Rz"].iloc[0],
        ]

    return lmks_frms, pose_p


def mirror_point(a, b, c, d, x1, y1, z1):
    # mirror a point w.r.t a 3D plane
    k = (-a * x1 - b * y1 - c * z1 - d) / float((a * a + b * b + c * c))

    x2 = a * k + x1
    y2 = b * k + y1
    z2 = c * k + z1

    x3 = 2 * x2 - x1
    y3 = 2 * y2 - y1
    z3 = 2 * z2 - z1
    return [x3, y3, z3]


def dist_vec2plane(vec, nrm):
    # Calculate the projected length of a vector (vec) to a plane defined by its normal (nrm)
    return np.sqrt(np.dot(vec, vec) - np.dot(vec, nrm) ** 2)


def vis_lmks3d(lmks_frms, vis_idx):
    """
    Visualizing facial landmarks
    """
    # fig = plt.figure()
    color_type = ["b", "g", "r", "y", "c"]
    assert len(color_type) > len(vis_idx)

    for fi in sorted(list(lmks_frms.keys())):
        ax = plt.axes(projection="3d")
        for i, vi in enumerate(vis_idx):
            ax.scatter(
                lmks_frms[fi][vi, 2],
                lmks_frms[fi][vi, 3],
                lmks_frms[fi][vi, 4],
                c=color_type[i],
            )

        ax.axes.set_xlim3d(left=-75, right=100)
        ax.axes.set_ylim3d(bottom=-200, top=25)
        ax.axes.set_zlim3d(bottom=440, top=560)
        ax.view_init(-89, -90)  # elev, ariz
        plt.title(str(fi))
        ax.set_xlabel("X")
        ax.set_ylabel("Y")
        ax.set_zlabel("Z")
        plt.pause(0.2)
        plt.cla()
        plt.draw()


def calc_fac_asymmetry(attr, is_vis=False):
    """
    Quantify facial asymmetry
    Args:
        attr: attribute dictionary containing necessary features for calculation, e.g.,
            lmks_frms: dictionary, with frame id as key and 68 landmark set (OpenFace) as value
            pose_param: dictionary, with frame id as key and pose param as value
    Returns:
        score_asym: 2D array of size (num_frms, num_asymm_fea), with frame id as the 0th column, and each remaining column as one asymmetry feature
    """
    # openface landmark indices
    lmks_ref_idx = list(range(0, 17)) + list(range(27, 36))
    lmks_mid_idx = [27, 28, 29, 30, 33, 51, 62, 66, 57, 8]
    lmks_rgt_idx = [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        17,
        18,
        19,
        20,
        21,
        36,
        37,
        38,
        39,
        40,
        41,
        48,
        49,
        50,
        59,
        58,
        60,
        61,
        67,
    ]
    lmks_lft_idx = [
        16,
        15,
        14,
        13,
        12,
        11,
        10,
        9,
        26,
        25,
        24,
        23,
        22,
        45,
        44,
        43,
        42,
        47,
        46,
        54,
        53,
        52,
        55,
        56,
        64,
        63,
        65,
    ]

    lmks_mth_idx = list(range(48, 68))
    lmks_ebr_idx = list(range(17, 27))
    lmks_eye_idx = list(range(36, 48))
    assert len(lmks_lft_idx) == len(lmks_rgt_idx)

    fea_list = ["mouth", "eyebrow", "eye", "composite"]
    score_asym = np.empty(shape=(0, 0))

    if ("lmks_frms" in attr) and ("pose_param" in attr):
        lmks_frms = attr["lmks_frms"]
        pose_p = attr["pose_param"]

        if is_vis:
            vis_lmks3d(
                lmks_frms, [lmks_lft_idx, lmks_rgt_idx, lmks_mid_idx, lmks_ref_idx]
            )

        score_asym = np.zeros(
            (len(lmks_frms), len(fea_list) + 1 + 1)
        )  # +1: extra column for error code
        if is_vis:
            # fig = plt.figure()
            ax = plt.axes(projection="3d")

        for s, fi in enumerate(sorted(list(lmks_frms.keys()))):
            lmks_3d = lmks_frms[fi][:, 2:5]
            pose = pose_p[fi]
            err_code = error_message_code["pass"]

            if lmks_frms[fi][0, 5] < 0.8:
                err_code = error_message_code["confidence less than 80%"]
                score_asym[s, :] = [fi, np.NaN, np.NaN, np.NaN, np.NaN, err_code]
                continue

            rx = R.from_euler("x", pose[3])
            ry = R.from_euler("y", pose[4])
            rz = R.from_euler("z", pose[5])

            vec_pose = rz.apply(ry.apply(rx.apply([0, 0, 1])))
            anc_idx = [30, 27, 8]  # for central plane estimation
            nrm = np.cross(
                lmks_3d[anc_idx[2], :] - lmks_3d[anc_idx[0], :],
                lmks_3d[anc_idx[1], :] - lmks_3d[anc_idx[0], :],
            )

            nrm = nrm / np.linalg.norm(nrm)
            a, b, c = nrm
            d = np.dot(nrm, lmks_3d[anc_idx[0], :])

            dist_L2R_mth = []
            dist_L2R_ebr = []
            dist_L2R_eye = []
            dist_com = []

            lmks_rfl = np.empty((0, 3))
            src_idx = lmks_lft_idx

            for k, idx in enumerate(src_idx):
                p_rfl = np.array(
                    mirror_point(
                        a, b, c, -d, lmks_3d[idx, 0], lmks_3d[idx, 1], lmks_3d[idx, 2]
                    )
                )
                lmks_rfl = np.vstack((lmks_rfl, p_rfl))
                dist = dist_vec2plane((p_rfl - lmks_3d[lmks_rgt_idx[k], :]), vec_pose)

                if idx in lmks_mth_idx:
                    dist_L2R_mth.append(dist)
                if idx in lmks_ebr_idx:
                    dist_L2R_ebr.append(dist)
                if idx in lmks_eye_idx:
                    dist_L2R_eye.append(dist)
                if (
                    (idx in lmks_mth_idx)
                    or (idx in lmks_ebr_idx)
                    or (idx in lmks_eye_idx)
                ):
                    dist_com.append(dist)
            score_asym[s, :] = [
                fi,
                np.mean(dist_L2R_mth),
                np.mean(dist_L2R_ebr),
                np.mean(dist_L2R_eye),
                np.mean(dist_com),
                err_code,
            ]

            if is_vis:
                ax.scatter(lmks_3d[:, 0], lmks_3d[:, 1], lmks_3d[:, 2])
                ax.scatter(lmks_rfl[:, 0], lmks_rfl[:, 1], lmks_rfl[:, 2], c="y")
                ax.scatter(pose_p[fi][0], pose_p[fi][1], pose_p[fi][2], c="c")
                plt.title("mirrored landmarks, frame: " + str(fi))
                ax.set_xlabel("X")
                ax.set_ylabel("Y")
                ax.set_zlabel("Z")
                plt.pause(0.2)
                plt.cla()
                plt.draw()

    return score_asym


def calc_asym_feature(open_face_csv, f_cfg):
    """
    Calculating facial asymmetry features and preparing final df
    """
    df_list = []

    of_df = pd.read_csv(open_face_csv)
    lmks_frms, pose_p = retrieve_attr(of_df)

    attr = {"lmks_frms": lmks_frms, "pose_param": pose_p}
    score_asym = calc_fac_asymmetry(attr)

    df_score_asym = pd.DataFrame(
        score_asym,
        columns=[
            "frame",
            f_cfg.fac_AsymMaskMouth,
            f_cfg.fac_AsymMaskEyebrow,
            f_cfg.fac_AsymMaskEye,
            f_cfg.fac_AsymMaskCom,
            f_cfg.err_reason,
        ],
    )
    df_score_asym[f_cfg.err_reason] = df_score_asym[f_cfg.err_reason].apply(
        lambda x: error_code_message[x]
    )

    df_score_asym["frame"] = of_df["frame"]
    df_score_asym["face_id"] = of_df[" face_id"]
    df_score_asym["timestamp"] = of_df[" timestamp"]
    df_score_asym["confidence"] = of_df[" confidence"]
    df_score_asym["success"] = of_df[" success"]

    df_list.append(df_score_asym)
    return df_list


def run_face_asymmetry(video_uri, out_dir, f_cfg, save=True):
    """
    Processing all patient's for calculating facial asymmetry
    ---------------
    ---------------
    Args:
        video_uri: video path; f_cfg: face config object
        out_dir: (str) Output directory for processed output
    """
    try:

        # Baseline logic
        ConfigFaceReader()
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)

        of_csv_path = glob.glob(join(out_loc, fl_name + "_openface/*.csv"))
        if len(of_csv_path) > 0:

            of_csv = of_csv_path[0]
            asym_df_list = calc_asym_feature(of_csv, f_cfg)

            asym_final_df = pd.concat(asym_df_list, ignore_index=True)
            asym_final_df["dbm_master_url"] = video_uri

            if save:
                logger.info(
                    "Processing Output file {} ".format(os.path.join(out_loc, fl_name))
                )
                ut.save_output(asym_final_df, out_loc, fl_name, face_asym_dir, csv_ext)
            return asym_final_df

    except Exception as e:
        e
        logger.error("Failed to process video file")
