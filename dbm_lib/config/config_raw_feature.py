"""
file_name: config_raw_feature
project_name: DBM
created: 2020-20-07
"""

import yaml
from dbm_lib import DBMLIB_FEATURE_CONFIG

class ConfigRawReader(object):
    """Summary
    Read sevice end ponit
    """
    def __init__(self,
                 feature_config_yml=None):
        """Summary
        Args:
            feature_config_yml (None, optional): yml file defined service configuration
        """
        
        if feature_config_yml is None:
            feature_config = DBMLIB_FEATURE_CONFIG
        else:
            feature_config = feature_config_yml

        with open(feature_config, 'r') as ymlfile:
            config = yaml.load(ymlfile)
            
            #Verbal features
            self.base_raw = config
            self.err_reason = config['raw_feature']['error_reason']
            
            #Output range
            self.mov_headvel_start = config['raw_feature']['mov_headvel_start']
            self.mov_headvel_end = config['raw_feature']['mov_headvel_end']
            
            #Acoustic variable
            self.aco_int = config['raw_feature']['aco_int']
            self.aco_ff = config['raw_feature']['aco_ff']
            self.aco_voiceLabel = config['raw_feature']['aco_voiceLabel']
            self.aco_hnr = config['raw_feature']['aco_hnr']
            self.aco_gne = config['raw_feature']['aco_gne']
            self.aco_fm1 = config['raw_feature']['aco_fm1']
            self.aco_fm2 = config['raw_feature']['aco_fm2']
            self.aco_fm3 = config['raw_feature']['aco_fm3']
            self.aco_fm4 = config['raw_feature']['aco_fm4']
            self.aco_jitter = config['raw_feature']['aco_jitter']
            self.aco_shimmer = config['raw_feature']['aco_shimmer']
            self.aco_mfcc1 = config['raw_feature']['aco_mfcc1']
            self.aco_mfcc2 = config['raw_feature']['aco_mfcc2']
            self.aco_mfcc3 = config['raw_feature']['aco_mfcc3']
            self.aco_mfcc4 = config['raw_feature']['aco_mfcc4']
            self.aco_mfcc5 = config['raw_feature']['aco_mfcc5']
            self.aco_mfcc6 = config['raw_feature']['aco_mfcc6']
            self.aco_mfcc7 = config['raw_feature']['aco_mfcc7']
            self.aco_mfcc8 = config['raw_feature']['aco_mfcc8']
            self.aco_mfcc9 = config['raw_feature']['aco_mfcc9']
            self.aco_mfcc10 = config['raw_feature']['aco_mfcc10']
            self.aco_mfcc11 = config['raw_feature']['aco_mfcc11']
            self.aco_mfcc12 = config['raw_feature']['aco_mfcc12']
            self.aco_voiceFrame = config['raw_feature']['aco_voiceFrame']
            self.aco_totVoiceFrame = config['raw_feature']['aco_totVoiceFrame']
            self.aco_voicePct = config['raw_feature']['aco_voicePct']
            self.aco_pausetime = config['raw_feature']['aco_pausetime']
            self.aco_totaltime = config['raw_feature']['aco_totaltime']
            self.aco_speakingtime = config['raw_feature']['aco_speakingtime']
            self.aco_numpauses = config['raw_feature']['aco_numpauses']
            self.aco_pausefrac = config['raw_feature']['aco_pausefrac']

            #Facial Action Unit (for consistency)
            self.fac_AU01int = config['raw_feature']['fac_AU01int']
            self.fac_AU02int = config['raw_feature']['fac_AU02int']
            self.fac_AU04int = config['raw_feature']['fac_AU04int']
            self.fac_AU05int = config['raw_feature']['fac_AU05int']
            self.fac_AU06int = config['raw_feature']['fac_AU06int']
            self.fac_AU07int = config['raw_feature']['fac_AU07int']
            self.fac_AU09int = config['raw_feature']['fac_AU09int']
            self.fac_AU10int = config['raw_feature']['fac_AU10int']
            self.fac_AU12int = config['raw_feature']['fac_AU12int']
            self.fac_AU14int = config['raw_feature']['fac_AU14int']
            self.fac_AU15int = config['raw_feature']['fac_AU15int']
            self.fac_AU17int = config['raw_feature']['fac_AU17int']
            self.fac_AU20int = config['raw_feature']['fac_AU20int']
            self.fac_AU23int = config['raw_feature']['fac_AU23int']
            self.fac_AU25int = config['raw_feature']['fac_AU25int']
            self.fac_AU26int = config['raw_feature']['fac_AU26int']
            self.fac_AU45int = config['raw_feature']['fac_AU45int']
            self.fac_AU01pres = config['raw_feature']['fac_AU01pres']
            self.fac_AU02pres = config['raw_feature']['fac_AU02pres']
            self.fac_AU04pres = config['raw_feature']['fac_AU04pres']
            self.fac_AU05pres = config['raw_feature']['fac_AU05pres']
            self.fac_AU06pres = config['raw_feature']['fac_AU06pres']
            self.fac_AU07pres = config['raw_feature']['fac_AU07pres']
            self.fac_AU09pres = config['raw_feature']['fac_AU09pres']
            self.fac_AU10pres = config['raw_feature']['fac_AU10pres']
            self.fac_AU12pres = config['raw_feature']['fac_AU12pres']
            self.fac_AU14pres = config['raw_feature']['fac_AU14pres']
            self.fac_AU15pres = config['raw_feature']['fac_AU15pres']
            self.fac_AU17pres = config['raw_feature']['fac_AU17pres']
            self.fac_AU20pres = config['raw_feature']['fac_AU20pres']
            self.fac_AU23pres = config['raw_feature']['fac_AU23pres']
            self.fac_AU25pres = config['raw_feature']['fac_AU25pres']
            self.fac_AU26pres = config['raw_feature']['fac_AU26pres']
            self.fac_AU28pres = config['raw_feature']['fac_AU28pres']
            self.fac_AU45pres = config['raw_feature']['fac_AU45pres']

            #Facial Landmarks (for consistency)
            self.fac_LMK00disp = config['raw_feature']['fac_LMK00disp']
            self.fac_LMK01disp = config['raw_feature']['fac_LMK01disp']
            self.fac_LMK02disp = config['raw_feature']['fac_LMK02disp']
            self.fac_LMK03disp = config['raw_feature']['fac_LMK03disp']
            self.fac_LMK04disp = config['raw_feature']['fac_LMK04disp']
            self.fac_LMK05disp = config['raw_feature']['fac_LMK05disp']
            self.fac_LMK06disp = config['raw_feature']['fac_LMK06disp']
            self.fac_LMK07disp = config['raw_feature']['fac_LMK07disp']
            self.fac_LMK08disp = config['raw_feature']['fac_LMK08disp']
            self.fac_LMK09disp = config['raw_feature']['fac_LMK09disp']
            self.fac_LMK10disp = config['raw_feature']['fac_LMK10disp']
            self.fac_LMK11disp = config['raw_feature']['fac_LMK11disp']
            self.fac_LMK12disp = config['raw_feature']['fac_LMK12disp']
            self.fac_LMK13disp = config['raw_feature']['fac_LMK13disp']
            self.fac_LMK14disp = config['raw_feature']['fac_LMK14disp']
            self.fac_LMK15disp = config['raw_feature']['fac_LMK15disp']
            self.fac_LMK16disp = config['raw_feature']['fac_LMK16disp']
            self.fac_LMK17disp = config['raw_feature']['fac_LMK17disp']
            self.fac_LMK18disp = config['raw_feature']['fac_LMK18disp']
            self.fac_LMK19disp = config['raw_feature']['fac_LMK19disp']
            self.fac_LMK20disp = config['raw_feature']['fac_LMK20disp']
            self.fac_LMK21disp = config['raw_feature']['fac_LMK21disp']
            self.fac_LMK22disp = config['raw_feature']['fac_LMK22disp']
            self.fac_LMK23disp = config['raw_feature']['fac_LMK23disp']
            self.fac_LMK24disp = config['raw_feature']['fac_LMK24disp']
            self.fac_LMK25disp = config['raw_feature']['fac_LMK25disp']
            self.fac_LMK26disp = config['raw_feature']['fac_LMK26disp']
            self.fac_LMK27disp = config['raw_feature']['fac_LMK27disp']
            self.fac_LMK28disp = config['raw_feature']['fac_LMK28disp']
            self.fac_LMK29disp = config['raw_feature']['fac_LMK29disp']
            self.fac_LMK30disp = config['raw_feature']['fac_LMK30disp']
            self.fac_LMK31disp = config['raw_feature']['fac_LMK31disp']
            self.fac_LMK32disp = config['raw_feature']['fac_LMK32disp']
            self.fac_LMK33disp = config['raw_feature']['fac_LMK33disp']
            self.fac_LMK34disp = config['raw_feature']['fac_LMK34disp']
            self.fac_LMK35disp = config['raw_feature']['fac_LMK35disp']
            self.fac_LMK36disp = config['raw_feature']['fac_LMK36disp']
            self.fac_LMK37disp = config['raw_feature']['fac_LMK37disp']
            self.fac_LMK38disp = config['raw_feature']['fac_LMK38disp']
            self.fac_LMK39disp = config['raw_feature']['fac_LMK39disp']
            self.fac_LMK40disp = config['raw_feature']['fac_LMK40disp']
            self.fac_LMK41disp = config['raw_feature']['fac_LMK41disp']
            self.fac_LMK42disp = config['raw_feature']['fac_LMK42disp']
            self.fac_LMK43disp = config['raw_feature']['fac_LMK43disp']
            self.fac_LMK44disp = config['raw_feature']['fac_LMK44disp']
            self.fac_LMK45disp = config['raw_feature']['fac_LMK45disp']
            self.fac_LMK46disp = config['raw_feature']['fac_LMK46disp']
            self.fac_LMK47disp = config['raw_feature']['fac_LMK47disp']
            self.fac_LMK48disp = config['raw_feature']['fac_LMK48disp']
            self.fac_LMK49disp = config['raw_feature']['fac_LMK49disp']
            self.fac_LMK50disp = config['raw_feature']['fac_LMK50disp']
            self.fac_LMK51disp = config['raw_feature']['fac_LMK51disp']
            self.fac_LMK52disp = config['raw_feature']['fac_LMK52disp']
            self.fac_LMK53disp = config['raw_feature']['fac_LMK53disp']
            self.fac_LMK54disp = config['raw_feature']['fac_LMK54disp']
            self.fac_LMK55disp = config['raw_feature']['fac_LMK55disp']
            self.fac_LMK56disp = config['raw_feature']['fac_LMK56disp']
            self.fac_LMK57disp = config['raw_feature']['fac_LMK57disp']
            self.fac_LMK58disp = config['raw_feature']['fac_LMK58disp']
            self.fac_LMK59disp = config['raw_feature']['fac_LMK59disp']
            self.fac_LMK60disp = config['raw_feature']['fac_LMK60disp']
            self.fac_LMK61disp = config['raw_feature']['fac_LMK61disp']
            self.fac_LMK62disp = config['raw_feature']['fac_LMK62disp']
            self.fac_LMK63disp = config['raw_feature']['fac_LMK63disp']
            self.fac_LMK64disp = config['raw_feature']['fac_LMK64disp']
            self.fac_LMK65disp = config['raw_feature']['fac_LMK65disp']
            self.fac_LMK66disp = config['raw_feature']['fac_LMK66disp']
            self.fac_LMK67disp = config['raw_feature']['fac_LMK67disp']

            #Facial features
            self.hap_exp = config['raw_feature']['hap_exp']
            self.sad_exp = config['raw_feature']['sad_exp']
            self.sur_exp = config['raw_feature']['sur_exp']
            self.fea_exp = config['raw_feature']['fea_exp']
            self.ang_exp = config['raw_feature']['ang_exp']
            self.dis_exp = config['raw_feature']['dis_exp']
            self.con_exp = config['raw_feature']['con_exp']
            self.happ_occ = config['raw_feature']['happ_occ']
            self.sad_occ = config['raw_feature']['sad_occ']
            self.sur_occ = config['raw_feature']['sur_occ']
            self.fea_occ = config['raw_feature']['fea_occ']
            self.ang_occ = config['raw_feature']['ang_occ']
            self.dis_occ = config['raw_feature']['dis_occ']
            self.con_occ = config['raw_feature']['con_occ']
            self.pos_exp = config['raw_feature']['pos_exp']
            self.neg_exp = config['raw_feature']['neg_exp']
            self.neu_exp = config['raw_feature']['neu_exp']
            self.cai_exp = config['raw_feature']['cai_exp']
            self.com_exp = config['raw_feature']['com_exp']
            self.hap_exp_full = config['raw_feature']['hap_exp_full']
            self.sad_exp_full = config['raw_feature']['sad_exp_full']
            self.sur_exp_full = config['raw_feature']['sur_exp_full']
            self.fea_exp_full = config['raw_feature']['fea_exp_full']
            self.ang_exp_full = config['raw_feature']['ang_exp_full']
            self.dis_exp_full = config['raw_feature']['dis_exp_full']
            self.con_exp_full = config['raw_feature']['con_exp_full']
            self.pos_exp_full = config['raw_feature']['pos_exp_full']
            self.neg_exp_full = config['raw_feature']['neg_exp_full']
            self.neu_exp_full = config['raw_feature']['neu_exp_full']
            self.cai_exp_full = config['raw_feature']['cai_exp_full']
            self.com_exp_full = config['raw_feature']['com_exp_full']
            self.fac_AsymMaskMouth = config['raw_feature']['fac_AsymMaskMouth']
            self.fac_AsymMaskEye = config['raw_feature']['fac_AsymMaskEye']
            self.fac_AsymMaskEyebrow = config['raw_feature']['fac_AsymMaskEyebrow']
            self.fac_AsymMaskCom = config['raw_feature']['fac_AsymMaskCom']
            
            #Movement features
            self.head_vel = config['raw_feature']['head_vel']
            self.mov_blink_ear = config['raw_feature']['mov_blink_ear']
            self.vid_dur = config['raw_feature']['vid_dur']
            self.fps = config['raw_feature']['fps']
            self.mov_blinkframes = config['raw_feature']['mov_blinkframes']
            self.mov_blinkdur = config['raw_feature']['mov_blinkdur']
            self.mov_Hpose_Pitch = config['raw_feature']['mov_Hpose_Pitch']
            self.mov_Hpose_Yaw = config['raw_feature']['mov_Hpose_Yaw']
            self.mov_Hpose_Roll = config['raw_feature']['mov_Hpose_Roll']
            self.mov_Hpose_Dist = config['raw_feature']['mov_Hpose_Dist']

            #NLP features
            self.nlp_transcribe = config['raw_feature']['nlp_transcribe']
            