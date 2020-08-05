"""
file_name: process_emotion_expressivity
project_name: DBM
created: 2020-20-07
"""

import os
import numpy as np
import pandas as pd
import datetime
import glob
from os.path import join
import logging

from dbm_lib.dbm_features.raw_features.video.face_config.face_config_reader import ConfigFaceReader
from dbm_lib.dbm_features.raw_features.util import video_util as vu
from dbm_lib.dbm_features.raw_features.util import util as ut

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

face_expr_dir = 'video/face_expressivity'
csv_ext = '_face_expressivity.csv'

#Openface feature extraction
def of_feature(df_of, cfr, f_cfg):
    """
    Creating dataframe for face expressivity
    Args:
        of: open face attributes
    Returns:
        (list) list of expressivity score for emotions
    """
    df_list = []
    df_of['s_confidence'] = vu.smooth(df_of[' confidence'].values, window='flat').tolist()
    
    if 'AU' in cfr.SELECTED_FEATURES :
        vu.calc_of_for_video(df_of, cfr, f_cfg)
    #Normalizing facial expressivity for Composite and Negative expr(Range 0 to 1)
    
    if len(df_of[f_cfg.neg_exp])>0:
        df_of[f_cfg.neg_exp] = df_of[f_cfg.neg_exp]/5
        
    if len(df_of[f_cfg.com_exp])>0:
        df_of[f_cfg.com_exp] = df_of[f_cfg.com_exp]/7
        
    if len(df_of[f_cfg.com_exp_full])>0:
        df_of[f_cfg.com_exp_full] = df_of[f_cfg.com_exp_full]/7
        
    df_list.append(df_of)
    return df_list 


def run_face_expressivity(video_uri, out_dir, f_cfg):
    """
    Processing all patient's for fetching facial landmarks
    ---------------
    ---------------
    Args:
        video_uri: video path; f_cfg: raw variable config object
        out_dir: (str) Output directory for processed output
    """
    try:
        
        #Baseline logic
        cfr = ConfigFaceReader()
        input_loc, out_loc, fl_name = ut.filter_path(video_uri, out_dir)

        of_csv_path = glob.glob(join(out_loc, fl_name + '_OF_features/*.csv'))
        if len(of_csv_path)>0:

            df_of = pd.read_csv(of_csv_path[0], error_bad_lines=False)
            df_of = df_of[cfr.AU_fl]
            expr_df_list = of_feature(df_of, cfr, f_cfg)

            exp_final_df = pd.concat(expr_df_list, ignore_index=True)
            exp_final_df['dbm_master_url'] = video_uri

            logger.info('Processing Output file {} '.format(os.path.join(out_loc, fl_name)))
            ut.save_output(exp_final_df, out_loc, fl_name, face_expr_dir, csv_ext)
            
    except Exception as e:
        logger.error('Failed to process video file')