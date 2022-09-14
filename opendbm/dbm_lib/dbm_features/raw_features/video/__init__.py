"""
file_name: __init__
project_name: DBM
created: 2020-20-07
"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os

DBMLIB_PATH = os.path.dirname(__file__)
DBMLIB_FACE_CONFIG = os.path.abspath(os.path.join(DBMLIB_PATH, '../../../../resources/services/face_util.yml'))