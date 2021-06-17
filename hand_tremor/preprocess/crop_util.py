"""
file_name: crop_util.py
project_name: hand tremor
created: 05/25/21
user: vijay yadav
"""

import cv2
import os
import numpy as np
import os
import glob
from os.path import join, basename, expanduser, dirname, splitext, exists
from skimage import io
import pandas as pd
import matplotlib.pyplot as plt
import pickle
from path_util import mkdir_p, get_white_list_files, save_pkl, load_pkl

class CropHandAnnaotation():
    """
    Cropping hand ROI using annotation
    
    Parameters:
    -----------
    
    ann_frm_root: Image frame directory for all videos
    ann_res_root: annotation directory location
    crop_root: output location to save each segment
    
    """
    
    def __init__(self, ann_frm_root=None, ann_res_root=None, crop_root=None):
        
        self.ann_frm_root = ann_frm_root#expanduser('data/frames')
        self.ann_res_root = ann_res_root#expanduser('data/annotation/')
        self.crop_root = crop_root#expanduser('data/grouped_crop_frames/')
        
        self.of_h = 384.
        self.of_w = 512.
        self.of_w_h_ratio = self.of_w / self.of_h

        self.seg_size = 64
        self.step_size = 8
        self.crop_ratio = 0.05 #additional margin on each side in addition of actual mov ratio

        self.annotate_min_consecutive_frames = 48
        self.sel_seg_num = int(np.round(self.annotate_min_consecutive_frames / self.step_size))

        self.segment_stats_path = join(self.crop_root,'segment_stats')
        self.segment_stats_small_path = join(self.crop_root, 'segment_stats_'+ str(self.sel_seg_num) + 'smallest')
        print(self.segment_stats_small_path)


    def split_video(self, input_file, output_file):
        """
        Splitting input videos into image frames

        Args:
            input_file: video file path
            output_file: image frame path
        """

        vidcap = cv2.VideoCapture(input_file)
        success,image = vidcap.read()
        count = 0
        EXTN = ".png"

        while success:
            newimage = cv2.resize(image,(1280,720))
            filename = str(count).zfill(6) + EXTN
            cv2.imwrite(output_file + '/' + filename, newimage)     # save frame    
            success,image = vidcap.read()
            #print('Read a new frame: ', success)
            count += 1

    def calc_crop_coords(self, mov_l, mov_r, mov_t, mov_b, w0, w1, h0, h1, width, height, fname):
        """
        Calculating cropping coordinates for each images
        """
        avg_w = w1-w0
        avg_h = h1-h0

        crop_l = (mov_l + self.crop_ratio) * avg_w
        crop_r = (mov_r + self.crop_ratio) * avg_w
        crop_t = (mov_t + self.crop_ratio) * avg_h
        crop_b = (mov_b + self.crop_ratio) * avg_h

        crop_w = avg_w + crop_l + crop_r
        crop_h = avg_h + crop_t + crop_b

        # crop to flownet input ratio to keep original x,y ratio for flow(u,v) calculation
        if crop_w / crop_h >= self.of_w_h_ratio:
            crop_h0, crop_h1 = calc_crop_coords_1d(h0, h1, crop_w/self.of_w_h_ratio, crop_t, crop_b, height-1, fname)
            crop_w0, crop_w1 = calc_crop_coords_1d(w0, w1, crop_w, crop_l, crop_r, width-1, fname)
        else:
            crop_h0, crop_h1 = calc_crop_coords_1d(h0, h1, crop_h, crop_t, crop_b, height-1, fname)
            crop_w0, crop_w1 = calc_crop_coords_1d(w0, w1, crop_h*self.of_w_h_ratio, crop_l, crop_r, width-1, fname)

        return crop_h0, crop_w0, crop_h1, crop_w1

    def crop_and_save(self, row, video_path):
        """
        Cropping and saving image frames(hand)
        
        Args:
            row: annotation dataframe with normalized movement
            video:path: Location of image frames
        """
        img_s0_fname = basename(row['name'][0])

        crop_h0,crop_w0,crop_h1,crop_w1 = self.calc_crop_coords(row['mov_l'], row['mov_r'], row['mov_t'], row['mov_b'],
                                                           row['xtl'], row['xbr'], row['ytl'], row['ybr'],
                                                           row['width'], row['height'],img_s0_fname)

        # save one segment
        cnt = 0
        for img_name in row['name']:
            img_fname = basename(img_name)
            img = io.imread(join(self.ann_frm_root, video_path, img_fname))

            crop_img = img[crop_h0:crop_h1, crop_w0:crop_w1]
            seg_fname = img_fname[:-4] + "_crop.png"

            out_path = join(self.crop_root, video_path, img_s0_fname[:-4])
            mkdir_p(out_path)
            io.imsave(join(out_path, seg_fname), crop_img)

    def group_and_crop_video_frames(self, video_path, video_df):
        """
        Segmenting cropped video frames
        
        Args:
            video_path: Image frame path for a video
            video_df: Annotstion dataframe with hand roi annotations
        """
        
        mkdir_p(join(self.crop_root, video_path))
        w = video_df['width'].iloc[0]
        h = video_df['height'].iloc[0]

        sel_df = pd.DataFrame()
        for i in range(0, video_df.shape[0]-self.seg_size, self.step_size):    
            if not check_consecutive_annotate(video_df['name'].iloc[i:i+self.seg_size]):
                continue

            # Note: check annotation continuity
            xtls = video_df['xtl'].iloc[i:i+self.seg_size]
            xbrs = video_df['xbr'].iloc[i:i+self.seg_size]
            ytls = video_df['ytl'].iloc[i:i+self.seg_size]
            ybrs = video_df['ybr'].iloc[i:i+self.seg_size]

            mov_l, mov_r, mov_t, mov_b = calc_mov_ratio(xtls, xbrs, ytls, ybrs)
            seg_mov = np.amax([mov_l+mov_r, self.of_w_h_ratio*(mov_t+mov_b)])
            sel_df = sel_df.append({'name': video_df['name'].iloc[i:i+self.seg_size].tolist(), 'width': w, 'height': h,
                           'xtl': xtls.mean(), 'xbr': xbrs.mean(), 'ytl': ytls.mean(), 'ybr': ybrs.mean(),
                           'mov_l': mov_l, 'mov_r': mov_r, 'mov_t': mov_t, 'mov_b': mov_b, 'seg_mov': seg_mov}, 
                           ignore_index=True
                         )

        sel_csv_fpath = join(self.segment_stats_path, '__'.join(video_path.split('/'))+'.csv')
        sel_small_csv_fpath = join(self.segment_stats_small_path, 
                                   str(self.sel_seg_num) + 'small_' + '__'.join(video_path.split('/'))+'.csv')

        sel_df.to_csv(sel_csv_fpath, index=False)

        if sel_df.shape[0] < self.sel_seg_num:
            sel_df_nsmall = sel_df
            print('{} does not have {} steady segments!!!'.format(video_path, self.sel_seg_num))
        else:
            sel_df_nsmall = sel_df.nsmallest(self.sel_seg_num, 'seg_mov')

        sel_df_nsmall.to_csv(sel_small_csv_fpath, index=False)
        sel_df_nsmall.apply(lambda row: self.crop_and_save(row, video_path), axis=1)



    def crop_hand_frame(self):
        """
        Cropping image frame based on hand annotations
        """
        
        mkdir_p(self.segment_stats_path)
        mkdir_p(self.segment_stats_small_path)
        
        # load annotation
        res_csvs = get_white_list_files(self.ann_res_root, white_list_extensions = ('csv',))
        for acsv in res_csvs:
            res_df = pd.read_csv(join(self.ann_res_root, acsv), sep="|")#.head(83)remove head on real data
            res_df['video'] = res_df['name'].apply(lambda x: '/'.join(x.split('/')[2:-1]))

            for video, video_df in res_df.groupby('video'):
                print('Processing {}, shape=({},{})'.format(video, video_df.shape[0], video_df.shape[1]))
                self.group_and_crop_video_frames(video, video_df)
                
def check_consecutive_annotate(names):
    """
    Check for consecutive image frames
    
    Args:
        names: image frame location pandas series based on segment size
        
    - If there is no consecutive sequences of image frame, this function 
      will not allow to create segments for such image frames
    """
    f_nums = names.apply(lambda x: int(basename(x)[:-4]))
    #print(list(f_nums))
    return sum(np.diff(sorted(list(f_nums))) == 1) == f_nums.shape[0]-1  

def calc_mov_ratio(xtls, xbrs, ytls, ybrs):
    """
    Calculating normalized hand movement specific to each segment to remove noise in cropping
    
    Args:
        xtls: x-axis left side; xbrs: x-axis right side
        ytls: y-axis left side; ybrs: y-axis right side
        
    """
    avg_xtl = xtls.mean()
    avg_xbr = xbrs.mean()
    avg_ytl = ytls.mean()
    avg_ybr = ybrs.mean()

    d_xtl_min = avg_xtl - xtls.min()
    d_xbr_max = xbrs.max() - avg_xbr
    d_ytl_min = avg_ytl - ytls.min()
    d_ybr_max = ybrs.max() - avg_ybr

    avg_w = avg_xbr - avg_xtl
    mov_ratio_w_left = d_xtl_min / avg_w
    mov_ratio_w_right = d_xbr_max / avg_w

    avg_h = avg_ybr - avg_ytl
    mov_ratio_h_top = d_ytl_min / avg_h
    mov_ratio_h_bot = d_ybr_max / avg_h

    return mov_ratio_w_left, mov_ratio_w_right, mov_ratio_h_top, mov_ratio_h_bot

def calc_crop_coords_1d(v0, v1, crop_sz, crop_0, crop_1, vmax, fname):
    """
        Calculating cropping coordinates for each images
    """
    numerical_tol = 0.5
    diff = crop_sz - (v1-v0)
    if (crop_0+crop_1) < diff-numerical_tol: #extended crop on this direction
        crop_0 = diff*crop_0/(crop_0+crop_1)
        crop_1 = diff*crop_1/(crop_0+crop_1)

    v0_n = max(0,   v0-crop_0)
    v1_n = min(vmax, v1+crop_1)
    cur_sz = v1_n - v0_n

    gap = crop_sz - cur_sz
    if gap > 0:
        if v0_n >= gap:
            v0_n -= gap
        elif v1_n <= vmax-gap:
            v1_n += crop_sz - cur_sz 
        else: # get the best crop it can be 
            rest = gap - v0_n
            v0_n = 0
            v1_n = min(v1_n + rest, vmax)
            if v1_n-v0_n < crop_sz-1.:
                print('WARNING: cannot crop to model size for {}, v0:{}, v1:{}, vmax: {}, crop_sz: {}'.format(
                    fname,v0,v1,vmax,crop_sz ))
    return int(np.round(v0_n)), int(np.round(v1_n))            