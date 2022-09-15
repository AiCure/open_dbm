import tempfile

from opendbm.api_lib.model import VideoModel
from opendbm.dbm_lib import run_face_landmark


def r_num_fmt(fmt, rnum):
    return list(map(lambda x: fmt.format(i="%02d" % x), rnum))


lcols = []
for vr in ["r", "c", "X", "Y", "Z"]:
    lcols += r_num_fmt(f"fac_LMK{{i}}{vr}", range(68))


class Landmark(VideoModel):
    def __init__(self):
        super().__init__()
        self._params = lcols

    def _fit_transform(self, path):
        return run_face_landmark(
            path, f"{tempfile.gettempdir()}/", self.r_config, save=False
        )
