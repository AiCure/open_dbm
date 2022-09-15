"""
file_name: config_reader
project_name: DBM
created: 2020-20-07
"""

import os

import yaml

DBMLIB_PATH = os.path.dirname(__file__)
DBMLIB_SERVICE_CONFIG = os.path.abspath(
    os.path.join(DBMLIB_PATH, "../../resources/services/services.yml")
)


class ConfigReader(object):
    """Summary
    Read sevice end ponit
    """

    def __init__(self, service_config_yml=None):
        """Summary
        Args:
            service_config_yml (None, optional): yml file defined service configuration
        """
        if service_config_yml is None:
            service_config = DBMLIB_SERVICE_CONFIG
        else:
            service_config = service_config_yml

        with open(service_config, "r") as ymlfile:
            config = yaml.load(ymlfile, Loader=yaml.CLoader)
            self.input_dir = config["cdx_configuration"]["input_dir"]
            self.output_dir = config["cdx_configuration"]["output_dir"]
            self.out_derived_dir = config["cdx_configuration"]["out_derived_dir"]
            self.of_path = config["cdx_configuration"]["open_face_path"]
            self.facial_landmarks = config["cdx_configuration"]["facial_landmarks"]
            self.feature_group = config["cdx_configuration"]["feature_group"]

    def get_open_face_path(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.of_path

    def get_input_dir(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.input_dir

    def get_output_dir(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.output_dir

    def get_out_derived_dir(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.out_derived_dir

    def get_fac_landmark_path(self):
        """Summary
        Returns:
            TYPE: end point
        """
        return self.facial_landmarks
