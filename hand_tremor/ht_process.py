"""
file_name: ht_process.py
project_name: hand tremor
created: 05/25/21
user: vijay yadav
"""
import glob
import os
import sys

sys.path.insert(0, os.path.expanduser('preprocess'))  
import crop_util as cu
import path_util as pu
import split_util as su
import optic_flow_util as of_util

sys.path.insert(0, os.path.expanduser('training')) 
import ht_training as ht

in_path = '/home/ubuntu/Vijay/hand_tremor/data/videos'
out_path = '/home/ubuntu/Vijay/hand_tremor/data/frames'
ann_path = '/home/ubuntu/Vijay/hand_tremor/data/annotation/hand_crop/'
crop_path = '/home/ubuntu/Vijay/hand_tremor/data/grouped_crop_frames/'
of_out_path = '/home/ubuntu/Vijay/hand_tremor/data/tremor_hand_of/fp_uv_segments/segments'
of_model_path = '/home/ubuntu/Vijay/hand_tremor/pytorch_flownet2/FlowNet2_src/pretrained/FlowNet2_checkpoint.pth.tar'

def crop_video(in_path, ann_path, out_path, crop_path):
    """
    cropping input videos
    
    Args:
        in_path: video directory path
        out_path: image frame path
    """
    vid_dir = glob.glob(in_path + '/*.mp4')
    crop_hand = cu.CropHandAnnaotation(out_path, ann_path, crop_path)
    
    for vid in vid_dir:
        
        fl_name,_ = os.path.splitext(os.path.basename(vid))
        out_loc = os.path.join(out_path, fl_name)
        pu.mkdir_p(out_loc)
        
        #Splitting video
        crop_hand.split_video(vid, out_loc)
        
        
    #Cropping hand section
    crop_hand.crop_hand_frame()
    
def run_optic(crop_path, of_out_path, of_model_path):
    """
    Optic Flow execution
    """
    optic_exe = of_util.OpticFlow(crop_path, of_out_path, of_model_path)
    flownet2 = optic_exe.load_model()
    
    optic_exe.process_all_selected_segments(flownet2=flownet2)
    
def split_data(of_out_path):
    """
    Splitting data into training, testing and validation samples.
    """
    out_path = os.path.dirname(of_out_path)
    split_sample = su.SplitTrainValTest(out_path)
    
    split_sample.split_data()

crop_video(in_path, ann_path, out_path, crop_path)
run_optic(crop_path, of_out_path, of_model_path)    
split_data(of_out_path)