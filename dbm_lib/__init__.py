"""
file_name: init
project_name: DBM
created: 2020-20-07
"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os

DBMLIB_PATH = os.path.dirname(__file__)
DBMLIB_SERVICE_CONFIG = os.path.abspath(os.path.join(DBMLIB_PATH, '../resources/services/services.yml'))
DBMLIB_FEATURE_CONFIG = os.path.abspath(os.path.join(DBMLIB_PATH, '../resources/features/raw_feature.yml'))
DBMLIB_DERIVE_FEATURE_CONFIG = os.path.abspath(os.path.join(DBMLIB_PATH, '../resources/features/derived_feature.yml'))