"""
file_name: config_derive_feature
project_name: DBM
created: 2020-20-07
"""

import yaml
from dbm_lib import DBMLIB_DERIVE_FEATURE_CONFIG

class ConfigDeriveReader(object):
    """Summary
    Read sevice end ponit
    """
    def __init__(self,
                 feature_config_yml=None):
        """Summary
        Args:
            feature_config_yml (None, optional): yml file defined service configuration
        """
        
        if feature_config_yml is None:
            feature_config = DBMLIB_DERIVE_FEATURE_CONFIG
        else:
            feature_config = feature_config_yml

        with open(feature_config, 'r') as ymlfile:
            config = yaml.load(ymlfile)
            self.base_derive = config
            