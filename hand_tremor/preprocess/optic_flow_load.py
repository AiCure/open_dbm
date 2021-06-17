"""
file_name: optic_flow_load.py
project_name: hand tremor
created: 05/25/21
user: vijay yadav
"""

import os
from os.path import isdir, join, basename
import numpy as np
from collections import Counter
from path_util import load_pkl, json_to_dict

from PIL import Image
import torch
from torch.utils.data import Dataset
import torchvision.transforms.functional as TF

class OflowDlDataset(Dataset):
    """
    optical flow data generator
    """
    def __init__(self, dl_path, pkl_root, data_info_path, discard_list = None, seg_random_seed=None, 
                 no_aug_ratio = 1.0, 
                 rotate_degree = 10, 
                 scale=(0.9, 1.0), 
                 ratio=(0.8333, 1.2) #from 5/6 to 6/5
                ):
        super(OflowDlDataset, self).__init__()       
        
        self.pkl_root = pkl_root
        self.no_aug_ratio = no_aug_ratio
        self.rotate_degree = rotate_degree
        self.scale = scale
        self.ratio = ratio
       
        self.label_dic = json_to_dict(data_info_path)
        print('label_dic = {}'.format(self.label_dic))
        self.id2label_dic = dict(zip(self.label_dic.values(),self.label_dic.keys()))
        print('id to label: {}'.format(self.id2label_dic))
        
        dl_tuples = load_pkl(dl_path)
        print('dl_tuples = {}'.format(dl_tuples[:3]))
        dl_labels = [t[2] for t in dl_tuples]
        print('tuple label count = {}'.format(Counter(dl_labels)))
                             
        if discard_list is not None:
            new_dl_tuples = [x for x in dl_tuples if not any([dstr in x[0] for dstr in discard_list])]
            
            orig_set = set([x[0][:-18] for x in dl_tuples])
            new_set = set(x[0][:-18] for x in new_dl_tuples)
            
            #print('removed data: {}'.format(sorted(set(orig_set) - set(new_set))))
            
            dl_tuples = new_dl_tuples
            
        self.len = len(dl_tuples)
        
        if self.len == 0:
            raise ValueError('Error: empty input datalist')     
       
        if no_aug_ratio < -0.00001 or no_aug_ratio > 1.00001: 
            # TODO check other input params
            raise ValueError('Error: Data augment ratio should be between 0.0 to 1.0')
 
        self.dl_tuples = sorted(dl_tuples, key = lambda x: x[0]) #sort by file name
        if seg_random_seed is not None:
            np.random.shuffle(self.dl_tuples) 
      
        print('datalist len = {}'.format(self.len))
        
    def transform_img(self, data, rot, i, j, new_h, new_w):
        h, w = data.shape
        arr = np.uint8(np.round(data*255.))
        img = Image.fromarray(arr, mode='L')
        img = TF.rotate(img, rot, resample=Image.BILINEAR)
        img = TF.resized_crop(img, i=i, j=j, h=new_h, w=new_w, size=(h, w))
        return np.array(img.getdata()).astype(np.float32).reshape(h, w)/255.
        
    def transform_seg(self, np_data):
        c, t, h, w = np_data.shape
        
        # generate rotate, scale and crop transform
        cur_rot = np.random.randint(low = -self.rotate_degree, high = self.rotate_degree+1)
        cur_scale = np.random.uniform(low = self.scale[0], high = self.scale[1]) 
        cur_ratio = np.random.uniform(low = self.ratio[0], high = self.ratio[1])
        
        new_w = int(cur_scale*w)
        new_h = np.min([int(cur_ratio * new_w), h])
        
        i = np.random.randint(low = 0, high = h-new_h+1)
        j = np.random.randint(low = 0, high = w-new_w+1)
        
        # create Image
        for idx in range(np_data.shape[1]):  
            np_data[0,idx,:,:] = self.transform_img(np_data[0,idx,:,:], rot=cur_rot, i=i, j=j, new_h=new_h, new_w=new_w) 
            np_data[1,idx,:,:] = self.transform_img(np_data[1,idx,:,:], rot=cur_rot, i=i, j=j, new_h=new_h, new_w=new_w)
                       
        return np_data
            
    def __getitem__(self, index):
        afile = self.dl_tuples[index][0]
        np_data = load_pkl(join(self.pkl_root, afile))
        
        augmented_img = False
        if self.no_aug_ratio < 1.0 and np.random.uniform() > self.no_aug_ratio:
            np_data = self.transform_seg(np_data)
            augmented_img = True
                 
        data = torch.tensor(np_data, dtype=torch.float)
        y = self.dl_tuples[index][2]
        one_hot_y = self.to_onehot(y, len(self.label_dic.keys()))
        
        strs = basename(afile).split('_')
                                                                      
        return data, y, one_hot_y, afile, augmented_img
        
    def __len__(self):
        return self.len
                
    def to_onehot(self, idx, num_labels):
        y = np.zeros(num_labels, dtype=np.float32)
        y[int(idx)] = 1
        return y
    
    def get_label_dic(self):
        return self.label_dic
    
    def get_id2label_dic(self):
        return self.id2label_dic
