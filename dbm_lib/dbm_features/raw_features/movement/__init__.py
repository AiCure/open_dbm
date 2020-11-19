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
DBMLIB_VTREMOR_LIB = os.path.abspath(os.path.join(DBMLIB_PATH,
                                                  '../../../../resources/libraries/voice_tremor.praat'))
