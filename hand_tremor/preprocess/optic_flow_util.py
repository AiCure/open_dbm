"""
file_name: optic_flow_util.py
project_name: hand tremor
created: 05/25/21
user: vijay yadav
"""

import numpy as np
import pandas as pd
import os
from os.path import expanduser, join, isdir, dirname, basename, exists
from scipy.misc import imread, imsave
from scipy.misc import imresize
import torch
from torch.autograd import Variable
from skimage.transform import resize
from datetime import datetime
import pytz

from path_util import mkdir_p, save_pkl, get_white_list_files

import sys
sys.path.insert(0, os.path.expanduser('pytorch_flownet2'))  
from FlowNet2_src import FlowNet2

class OpticFlow():
    """
    OpticalFlow processing on input image
    
    Parameters:
    -----------
    
    ann_frm_root: Image frame directory for all videos
    ann_res_root: annotation directory location
    crop_root: output location to save each segment
    
    """
    
    def __init__(self, in_root_path=None, out_root_path=None, of_model_path=None):
        
        self.IMG_EXT = ('.jpg', '.jpeg', '.png', '.tiff', '.bmp')
        self.in_root_path = in_root_path
        self.seg_fpath = join(self.in_root_path, 'segment_stats_6smallest') #check if seg12 is available
        self.out_root_path = out_root_path
        self.of_model_path = of_model_path
        self.model_im_wh_ratio = 1080./720. #hard coded image size to used trained optical flow model
        
        #from pre-trained flownet required input size
        self.of_sz = (384, 512, 3) # optic flow map height, width, channel
        self.of_h = 384.
        self.of_w = 512.
        self.of_w_h_ratio = self.of_w / self.of_h
        
        self.seg_num_per_video = 5
        self.segment_size = 64 #ns * fps + 4
        self.in_sz = 64
        
        self.process_params = {
            'in_path': self.in_root_path,
            'out_path': self.out_root_path,
            'seg_sz': self.segment_size,
            'in_sz': self.in_sz,
            'FOV': 'full'
        }
        
    def run_of_image(self, flownet2, ref_im, mov_im):
    
        ref_shape = ref_im.shape
        mov_shape = mov_im.shape

        #ignore warning of this deprecated, and use resize, resize return float 0-1, not original uint8 values
        of_im1 = imresize(ref_im, self.of_sz) 
        of_im2 = imresize(mov_im, self.of_sz)

        # B x 3(RGB) x 2(pair) x H x W
        ims = np.array([[of_im1, of_im2]]).transpose((0, 4, 1, 2, 3)).astype(np.float32)
        ims = torch.from_numpy(ims)
        ims_v = Variable(ims.cuda(), requires_grad=False)

        pred_flow = flownet2(ims_v).cpu().data
        pred_flow = pred_flow[0].numpy().transpose((1,2,0))
        
        return pred_flow


    def load_model(self): 
        # Build model
        flownet2 = FlowNet2()
        pretrained_dict = torch.load(self.of_model_path)['state_dict']
        model_dict = flownet2.state_dict()
        pretrained_dict = {k: v for k, v in pretrained_dict.items() if k in model_dict}
        model_dict.update(pretrained_dict)
        flownet2.load_state_dict(model_dict)
        flownet2.cuda()

        return flownet2

    def process_one_segment(self, seg_path, seg_name, flownet2):
        
        uvseg_fpath = join(self.process_params['out_path'], seg_name+'.pkl')
        if exists(uvseg_fpath): 
            print('{} exist, skip...'.format(uvseg_fpath))
            return 

        mkdir_p(dirname(uvseg_fpath))

        img_fpaths = get_white_list_files(join(self.in_root_path,seg_path), white_list_extensions = self.IMG_EXT)
        img_fpaths.sort() #for consecutive

        h, w = self.of_sz[:2] #height = 384, width = 512 
        s = self.process_params['seg_sz'] 
        
        if s != len(img_fpaths):
            print('WARNING: image in segment not {}'.format(s))

        u_seg = np.ndarray(shape = (s, h, w), dtype=np.float32)
        v_seg = np.ndarray(shape = (s, h, w), dtype=np.float32)

        for j in range(s-1):
            ref_afile = img_fpaths[j]
            mov_afile = img_fpaths[j+1]

            uv_mat = self.run_of_image(flownet2, 
                                  imread(join(self.in_root_path, seg_path, ref_afile)), 
                                  imread(join(self.in_root_path, seg_path, mov_afile)))

            u_seg[j] = uv_mat[:,:,0]
            v_seg[j] = uv_mat[:,:,1]

            if 'right_hand' in seg_path: #model only trained with left hand
                u_seg[j] = np.fliplr(u_seg[j])
                v_seg[j] = np.fliplr(v_seg[j])

        us = resize(u_seg, (self.process_params['seg_sz'], self.process_params['in_sz'], self.process_params['in_sz']))
        vs = resize(v_seg, (self.process_params['seg_sz'], self.process_params['in_sz'], self.process_params['in_sz']))

        """
        arranage u, v such that u, v are different channels, 
        and [segment_size,in_size,in_size] for a 3D image 
        where segment_size is the number of frames in a segment
        """
        uv_seg = np.concatenate((us[np.newaxis,...], vs[np.newaxis,...]), axis=0)
        save_pkl(uv_seg, uvseg_fpath)

    def correct_seg_mov(self, row):
        crop_w = row['xbr'] - row['xtl'] + row['mov_l'] + row['mov_r']
        crop_h = row['ybr'] - row['ytl'] + row['mov_t'] + row['mov_b']

        seg_mov = 0.
        if crop_w >= self.of_w_h_ratio * crop_h: # tight crop by w, considering flownet input ratio
            seg_mov = row['mov_l'] + row['mov_r']
        else: # tight crop by h, considering flownet input ratio
            seg_mov = row['mov_t'] + row['mov_b']

        return seg_mov

    def process_all_selected_segments(self, flownet2):

        csv_paths = get_white_list_files(self.seg_fpath, white_list_extensions = ('.csv',))

        for acsv in csv_paths:
            print('Processing {}'.format(acsv))

            sdf = pd.read_csv(join(self.seg_fpath, acsv), index_col=False)
            sdf['seg_mov_c'] = sdf.apply(self.correct_seg_mov, axis=1)
            sdf = sdf.sort_values(by=['seg_mov_c']).reset_index().iloc[:self.seg_num_per_video]

            for index, row in sdf.iterrows():
                img0_fpath = eval(row['name'])[0]
                img_path = join(*(img0_fpath.split('/')[2:-1]) + [basename(img0_fpath)[:-4]])
                img_name = (img0_fpath.split('/')[2:-1])[0] + '_' + basename(img0_fpath)[:-4]

                img_fpaths = get_white_list_files(join(self.in_root_path, img_path), white_list_extensions = self.IMG_EXT)
                self.process_one_segment(img_path, img_name, flownet2)

        print('All Done!')
        
        
        