import tempfile

from opendbm.api_lib.model import VideoModel
from opendbm.dbm_lib import run_head_movement


class HeadMovement(VideoModel):
    def __init__(self):
        super().__init__()
        self._params = [
            "mov_headvel",
            "mov_hposepitch",
            "mov_hposeyaw",
            "mov_hposeroll",
            "mov_hposedist",
        ]

    def _fit_transform(self, path):
        return run_head_movement(path, f"{tempfile.gettempdir()}/", self.r_config)
