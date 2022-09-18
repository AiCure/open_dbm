import tempfile

from opendbm.api_lib.model import VideoModel
from opendbm.dbm_lib import run_face_asymmetry


class Asymmetry(VideoModel):
    def __init__(self):
        super().__init__()
        self._params = [
            "fac_asymmaskmouth",
            "fac_asymmaskeye",
            "fac_asymmaskeyebrow",
            "fac_asymmaskcom",
        ]

    def _fit_transform(self, path):
        return run_face_asymmetry(
            path, f"{tempfile.gettempdir()}/", self.r_config, save=False
        )
