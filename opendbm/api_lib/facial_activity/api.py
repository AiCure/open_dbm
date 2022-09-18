import shutil
import tempfile
from collections import OrderedDict

from opendbm.api_lib.model import VideoModel
from opendbm.api_lib.util import check_isfile

from ._action_unit import ActionUnit
from ._asymmetry import Asymmetry
from ._expressivity import Expressivity
from ._landmark import Landmark


class FacialActivity(VideoModel):
    def __init__(self):
        super().__init__()

        self._landmark = Landmark()
        self._action_unit = ActionUnit()
        self._asymmetry = Asymmetry()
        self._expressivity = Expressivity()

        self._models = OrderedDict(
            {
                "landmark": self._landmark,
                "action_unit": self._action_unit,
                "asymmetry": self._asymmetry,
                "expressivity": self._expressivity,
            }
        )

    def fit(self, path):
        """Fit a file in filepath to OpenFace Model. Make sure to set the Docker to be active first.
        For installation, see https://aicure.github.io/open_dbm/docs/openface-docker-installation

        Parameters
        ----------
        path : string,
            File Path of MP4/MOV file.
        """

        check_isfile(path)
        result_path, bn = super()._fit(path, "facial")

        for k, v in self._models.items():
            v._df = v._fit_transform(result_path)

        shutil.rmtree(f"{tempfile.gettempdir()}/{bn}/")

    def get_landmark(self):
        """
        Get the model object of Landmark
        Returns:
        self: object
            Model Object
        """
        return self._landmark

    def get_action_unit(self):
        """
        Get the model object of Action Unit
        Returns:
        self: object
            Model Object
        """
        return self._action_unit

    def get_asymmetry(self):
        """
        Get the model object of Facial Asymmetry
        Returns:
        self: object
            Model Object
        """
        return self._asymmetry

    def get_expressivity(self):
        """
        Get the model object of Facial Expressivity
        Returns:
        self: object
            Model Object
        """
        return self._expressivity
