"""
file_name: split_util.py
project_name: hand tremor
created: 05/25/21
user: vijay yadav
"""

import os
from os.path import join, expanduser, dirname, basename, exists
import numpy as np
from six import iteritems
from collections import Counter

from path_util import mkdir_p, get_white_list_files, save_pkl

class SplitTrainValTest():
    """
    Splitting training, validation and testing samples
    
    """
    
    def __init__(self, out_seg_path=None):
        
        self.out_seg_path = out_seg_path
        self.frm_step = 16
        self.tot_pids = ['tremor{0:0d}'.format(pid) for pid in range(1,6,1)] #patient data specific to this use case
        self.test_pids = ['tremor5']
        self.val_pids = ['tremor4']
        self.out_pkl_path = join(self.out_seg_path, 'segments/')
        self.test_str = '_'.join(self.test_pids)
        self.val_str = '_'.join(self.val_pids)
        self.out_dl_fpath = join(self.out_seg_path, 'dl_Test_{}-Val_{}'.format(self.test_str, self.val_str))
        self.out_dl_train_fpath = self.out_dl_fpath + '_train.pkl'
        self.out_dl_val_fpath = self.out_dl_fpath + '_val.pkl'
        self.out_dl_test_fpath  = self.out_dl_fpath + '_test.pkl'
        self.train_pids = list(set(self.tot_pids) - set(self.test_pids) - set(self.val_pids))
        self.label_id_dic = {'tremor1': 1, 
                             'tremor2': 1, 
                             'tremor3': 0,
                             'tremor4': 1,
                             'tremor5': 0}#replace it with csv for larger dataset/currently binary class.
        
    def split_data(self):
        train_dl = []
        val_dl = []
        test_dl = []
        
        seg_fpaths = get_white_list_files(self.out_pkl_path, white_list_extensions = ('pkl',))
        label_str = 'tremor' #indicator for labeling based on filename in ground truth scores
        
        for aseg in seg_fpaths:
            label = [l for l in aseg.split('_') if l.startswith(label_str)][0]

            #save path relative to out_pkl_path
            if any([pid in aseg for pid in self.train_pids]):        
                train_dl.append((aseg, label, self.label_id_dic[label]))
            elif any([pid in aseg for pid in self.val_pids]):
                val_dl.append((aseg, label, self.label_id_dic[label]))
            elif any([pid in aseg for pid in self.test_pids]):
                test_dl.append((aseg, label, self.label_id_dic[label]))
        
        #Saving train, test and val pkl objects
        save_pkl(train_dl, self.out_dl_train_fpath)
        save_pkl(val_dl , self.out_dl_val_fpath)
        save_pkl(test_dl , self.out_dl_test_fpath)