"""
file_name: path_util.py
project_name: hand tremor
created: 05/25/21
user: vijay yadav
"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import errno
import os
import pickle
import json
from collections import OrderedDict

def mkdir_p(path):
    """
    make dir if it doesn't exist, do nothing if it does

    Args:
        path: (str) a full path name

    Raises:
        an exception if os.makedirs failes for a reason other then path existing

    """
    try:
        os.makedirs(path)
    except OSError as e:  # Python >2.5
        if e.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


def load_pkl(filepath):
    """ load a pickle

    Args:
        filepath: (str) path of pkl file to load

    Returns:
        the loaded object

    """
    try:
        with open(filepath, 'rb') as f:
            return pickle.load(f)
    # The except clause is intended to deal with a problem unpickling numpy arrays saved in py2 in py3
    # https://stackoverflow.com/questions/28218466/unpickling-a-python-2-object-with-python-3
    # Not a perfect solution, it might produce unexpected results when pickle contains non-ISO-8859 characters
    except UnicodeDecodeError:
        with open(filepath, 'rb') as f:
            return pickle.load(f, fix_imports=True, encoding='latin1')


def save_pkl(obj, filepath):
    """ save as pickle
    Args:
        obj: (object) to be pickled
        filepath: (str) path of pkl file to save

    Returns:

    """
    with open(filepath, 'wb') as f:
        # we use protocol 2 to ensure backwards compatibility for py2.7
        pickle.dump(obj, f, protocol=2)
        
def json_to_dict(json_fname):
    """
    load model json file (use original key order)
    Args:
        model_json: input model json file path

    Returns:

    """
    with open(json_fname) as json_data:
        json_dict = json.load(json_data, object_pairs_hook=OrderedDict)
        return json_dict

def save_to_json(obj, json_fname):
    with open(json_fname, 'w') as fp:
        json.dump(obj, fp, indent=2)
        
def get_white_list_files(directory, white_list_extensions, follow_links=False):
    """    
    Args:
        directory: (str) root to start search 
        white_list_extensions: (iterable) with extensions of interest case is ignored.
                               e.g. for images it could be {'png', 'jpg', 'jpeg', 'bmp', 'tiff', 'tif'}
        follow_links: (bool) whether to follow soft links        

    Returns:
        (iterable[str]) relative path to `directory` for files matching the white list extensions         

    """
    res = []
    white_list_extensions = [ext.lower() for ext in white_list_extensions]
    for root, _, files in sorted(os.walk(directory, followlinks=follow_links), key=lambda x: x[0]):
        for fname in sorted(files):
            _, ext = os.path.splitext(fname)
            if ext.lower() in white_list_extensions or ext.lower()[1:] in white_list_extensions:
                res.append(os.path.relpath(os.path.join(root, fname), directory))
    return res


