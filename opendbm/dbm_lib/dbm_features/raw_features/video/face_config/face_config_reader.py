"""
file_name: face_config_reader
project_name: DBM
created: 2020-20-07
"""

import os

import yaml

DBMLIB_PATH = os.path.dirname(__file__)
DBMLIB_FACE_CONFIG = os.path.abspath(
    os.path.join(DBMLIB_PATH, "../../../../../resources/services/face_util.yml")
)


class ConfigFaceReader(object):
    """Summary
    Read sevice end ponit
    """

    def __init__(self, service_config_yml=None):
        """Summary
        Args:
            service_config_yml (None, optional): yml file defined service configuration
        """

        if service_config_yml is None:
            service_config = DBMLIB_FACE_CONFIG
        else:
            service_config = service_config_yml

        with open(service_config, "r") as ymlfile:
            config = yaml.load(ymlfile, Loader=yaml.CLoader)
            self.ACTION_UNITS = config["cdx_face_config"]["ACTION_UNITS"]
            self.NEG_ACTION_UNITS = config["cdx_face_config"]["NEG_ACTION_UNITS"]
            self.POS_ACTION_UNITS = config["cdx_face_config"]["POS_ACTION_UNITS"]
            self.NET_ACTION_UNITS = config["cdx_face_config"]["NET_ACTION_UNITS"]
            self.LOWER_ACTION_UNITS = config["cdx_face_config"]["LOWER_ACTION_UNITS"]
            self.UPPER_ACTION_UNITS = config["cdx_face_config"]["UPPER_ACTION_UNITS"]
            self.happiness = config["cdx_face_config"]["happiness"]
            self.sadness = config["cdx_face_config"]["sadness"]
            self.surprise = config["cdx_face_config"]["surprise"]
            self.fear = config["cdx_face_config"]["fear"]
            self.anger = config["cdx_face_config"]["anger"]
            self.disgust = config["cdx_face_config"]["disgust"]
            self.contempt = config["cdx_face_config"]["contempt"]
            self.pain = config["cdx_face_config"]["pain"]
            self.cai = config["cdx_face_config"]["CAI"]
            self.SELECTED_FEATURES = config["cdx_face_config"][
                "SELECTED_FEATURES"
            ].split(",")
            self.face_expr_dir = config["cdx_face_config"]["face_expr_dir"]
            self.face_asym_dir = config["cdx_face_config"]["face_asym_dir"]
            self.AU_fl = config["cdx_face_config"]["AU_filters"]
            self.au_int = config["cdx_face_config"]["au_intensity"]
            self.au_prs = config["cdx_face_config"]["au_presence"]

    def get_action_unit(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.ACTION_UNITS

    def get_neg_action_unit(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.NEG_ACTION_UNITS

    def get_pos_action_unit(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.POS_ACTION_UNITS

    def get_net_action_unit(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.NET_ACTION_UNITS

    def get_selected_feature(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.SELECTED_FEATURES

    def get_happiness(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.happiness

    def get_sadness(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.sadness

    def get_surprise(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.surprise

    def get_fear(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.fear

    def get_anger(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.anger

    def get_disgust(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.disgust

    def get_contempt(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.contempt

    def get_cai(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.cai
