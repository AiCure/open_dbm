import pandas as pd
import json
from os.path import exists

def read_derivedAttr(ar):
    derivedFilename = ar+"/derived_variables/derived_output.csv"
    if not exists(derivedFilename):
        return pd.DataFrame()
    derived_df = pd.read_csv(derivedFilename)
    facial_cols = [col for col in derived_df if "fac_" in col]
    acoustic_cols = [col for col in derived_df if "aco_" in col]
    movement_cols = [col for col in derived_df if "mov_" in col]
    nlp_cols = [col for col in derived_df if "nlp_" in col]
    derived_facial = derived_df.loc[:,derived_df.columns.isin(facial_cols)]
    derived_acoustic = derived_df.loc[:,derived_df.columns.isin(acoustic_cols)]
    derived_movement = derived_df.loc[:,derived_df.columns.isin(movement_cols)]
    derived_nlp = derived_df.loc[:,derived_df.columns.isin(nlp_cols)]
    ids = derived_df["Filename"].tolist()
    return {"ids": ids,
        "facialAttr": facial_cols, "acousticAttr": acoustic_cols, "movementAttr": movement_cols, "speechAttr": nlp_cols}

def read_medatada(ar, ar2):
    metaData={}
    metdataFilename = ar+"/"+ar2
    if exists(metdataFilename):
        metadataDf = pd.read_csv(metdataFilename)
        metaData = metadataDf.to_json(orient="records")
    return metaData

def read_derivedDf(ar):
    derivedFilename = ar+"/derived_variables/derived_output.csv"
    if not exists(derivedFilename):
        return pd.DataFrame()
    derived_df = pd.read_csv(derivedFilename)
    return derived_df


def read_rawFacialDf(ar, id):
    skip_cols = ["frame", "face_id", "error_reason", "timestamp", "confidence", "success", "dbm_master_url", "error_reason", " confidence", " face_id", " success", " timestamp", "s_confidence", ]
    
    facial_asym_filename = ar + "/raw_variables/"+id+"/facial/face_asymmetry/"+id+"_facasym.csv"
    facial_au_filename = ar + "/raw_variables/"+id+"/facial/face_au/"+id+"_facau.csv"
    facial_expr_filename = ar + "/raw_variables/"+id+"/facial/face_expressivity/"+id+"_facemo.csv"
    landmark_filename = ar + "/raw_variables/"+id+"/facial/face_landmark/"+id+"_faclmk.csv"

    if not exists(facial_asym_filename) or not exists(facial_au_filename) or not exists(facial_expr_filename):
        return  pd.DataFrame()

    facial_asym = pd.read_csv(facial_asym_filename)
    facial_asym_cols = [col for col in facial_asym if col not in skip_cols]

    facial_au = pd.read_csv(facial_au_filename)
    facial_au_cols = [col for col in facial_au if col not in skip_cols]

    facial_expr = pd.read_csv(facial_expr_filename)
    facial_expr_cols = [col for col in facial_expr if col not in skip_cols and "AU" not in col]

    landmark = pd.read_csv(landmark_filename)
    landmark_cols = [col for col in landmark if col not in skip_cols]

    face_df = landmark.loc[:, ~landmark.columns.isin(skip_cols)].copy()
    for el in facial_expr_cols:
        face_df[el] = facial_expr[el]
    for el in facial_au_cols:
        face_df[el] = facial_au[el]
    for el in facial_asym_cols:
        face_df[el] = facial_asym[el]
    return face_df[face_df.columns[::-1]].fillna(0)



def read_rawMovementDf(ar, id):
    skip_cols = ["error_reason", "dbm_master_url", "Frames", " Frames", "vid_dur", "fps" ]

    gaze_filename = ar + "/raw_variables/"+id+"/movement/gaze/"+id+"_eyegaze.csv"
    head_movement_filename = ar + "/raw_variables/"+id+"/movement/head_movement/"+id+"_headmov.csv"
    head_pose_filename = ar + "/raw_variables/"+id+"/movement/head_pose/"+id+"_headpose.csv"

    blinks_filename = ar + "/raw_variables/"+id+"/movement/eye_blink/"+id+"_eyeblinks.csv"
    fac_tremor_filename = ar + "/raw_variables/"+id+"/movement/facial_tremor/"+id+"_fac_tremor.csv"
    voice_tremor_filename = ar + "/raw_variables/"+id+"/movement/voice_tremor/"+id+"_vtremor.csv"
    
    if not exists(gaze_filename) or not exists(head_movement_filename) or not exists(head_pose_filename):
        return pd.DataFrame()

    gaze = pd.read_csv(gaze_filename)
    gaze_cols = [col for col in gaze if col not in skip_cols]

    head_movement = pd.read_csv(head_movement_filename)
    head_movement_cols = [col for col in head_movement if col not in skip_cols]


    blinks = pd.read_csv(blinks_filename)
    blinks_cols = [col for col in blinks if col not in skip_cols]

    fac_tremor = pd.read_csv(fac_tremor_filename)
    fac_tremor_cols = [col for col in fac_tremor if col not in skip_cols]

    voice_tremor = pd.read_csv(voice_tremor_filename)
    voice_tremor_cols = [col for col in voice_tremor if col not in skip_cols]


    head_pose = pd.read_csv(head_pose_filename)
    head_pose_cols = [col for col in head_pose if col not in skip_cols]

    movement_df = head_pose.loc[:, ~head_pose.columns.isin(skip_cols)].copy()
    for el in head_movement_cols:
        movement_df[el] = head_movement[el]
    for el in gaze_cols:
        movement_df[el] = gaze[el]
    for el in blinks_cols:
        movement_df[el] = blinks[el]
    for el in fac_tremor_cols:
        movement_df[el] = fac_tremor[el]
    for el in voice_tremor_cols:
        movement_df[el] = voice_tremor[el]
    return movement_df.fillna(0)



def read_rawAcousticDf(ar, id):
    skip_cols = ["error_reason", "dbm_master_url", "Frames", " Frames", "aco_voicelabel"] 

    fm_filename = ar + "/raw_variables/"+id+"/acoustic/formant_freq/"+id+"_formant.csv"
    gne_filename = ar + "/raw_variables/"+id+"/acoustic/glottal_noise/"+id+"_gne.csv"
    hnr_filename = ar + "/raw_variables/"+id+"/acoustic/harmonic_noise/"+id+"_hnr.csv"
    intt_filename = ar + "/raw_variables/"+id+"/acoustic/intensity/"+id+"_intensity.csv"
    mfcc_filename = ar + "/raw_variables/"+id+"/acoustic/mfcc/"+id+"_mfcc.csv"
    pitch_filename = ar + "/raw_variables/"+id+"/acoustic/pitch/"+id+"_pitch.csv"
    jitter_filename = ar + "/raw_variables/"+id+"/acoustic/jitter/"+id+"_jitter.csv"
    pause_segment_filename = ar + "/raw_variables/"+id+"/acoustic/pause_segment/"+id+"_pausechar.csv"
    shimmer_filename = ar + "/raw_variables/"+id+"/acoustic/shimmer/"+id+"_shimmer.csv"
    voice_frame_score_filename = ar + "/raw_variables/"+id+"/acoustic/voice_frame_score/"+id+"_voiceprev.csv"

    filename_list = [fm_filename, gne_filename, hnr_filename, intt_filename,mfcc_filename, pitch_filename, pause_segment_filename, shimmer_filename, voice_frame_score_filename]

    if not exists(fm_filename) or not exists(gne_filename) or not exists(hnr_filename) or not exists(intt_filename) or not exists(mfcc_filename) or not exists(pitch_filename):
        return  pd.DataFrame

    fm = pd.read_csv(fm_filename)
    fm_cols = [col for col in fm if col not in skip_cols]

    gne = pd.read_csv(gne_filename)
    gne_cols = [col for col in gne if col not in skip_cols]

    hnr = pd.read_csv(hnr_filename)
    hnr_cols = [col for col in hnr if col not in skip_cols]


    intt = pd.read_csv(intt_filename)
    intt_cols = [col for col in intt if col not in skip_cols]

  
    mfcc = pd.read_csv(mfcc_filename)
    mfcc_cols = [col for col in mfcc if col not in skip_cols]


    pitch = pd.read_csv(pitch_filename)
    pitch_cols = [col for col in pitch if col not in skip_cols]

    pause_segment = pd.read_csv(pause_segment_filename)
    pause_segment_cols = [col for col in pause_segment if col not in skip_cols]

    jitter = pd.read_csv(jitter_filename)
    jitter_cols = [col for col in jitter if col not in skip_cols]

    shimmer = pd.read_csv(shimmer_filename)
    shimmer_cols = [col for col in shimmer if col not in skip_cols]

    voice_frame_score = pd.read_csv(voice_frame_score_filename)
    voice_frame_score_cols = [col for col in voice_frame_score if col not in skip_cols]

    acoustic_df = fm.loc[:, ~fm.columns.isin(skip_cols)].copy()
    for el in gne_cols:
        acoustic_df[el] = gne[el]
    for el in hnr_cols:
        acoustic_df[el] = hnr[el]
    for el in intt_cols:
        acoustic_df[el] = intt[el]
    for el in mfcc_cols:
        acoustic_df[el] = mfcc[el]
    for el in pitch_cols:
        acoustic_df[el] = pitch[el]
    for el in pause_segment_cols:
        acoustic_df[el] = pause_segment[el]
    for el in jitter_cols:
        acoustic_df[el] = jitter[el]
    for el in shimmer_cols:
        acoustic_df[el] = shimmer[el]
    for el in voice_frame_score_cols:
        acoustic_df[el] = voice_frame_score[el]
    return acoustic_df.fillna(0)


def load():
    global videoIds 
    read_derivedAttr()
    read_derivedDf()


if __name__=="__main__":
    load()

