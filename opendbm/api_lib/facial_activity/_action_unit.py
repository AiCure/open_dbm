import tempfile

from opendbm.api_lib.model import VideoModel
from opendbm.dbm_lib.dbm_features.raw_features.video.face_au import run_face_au


class ActionUnit(VideoModel):
    def __init__(self):
        super().__init__()
        self._params = [
            "fac_AU01int",
            "fac_AU02int",
            "fac_AU04int",
            "fac_AU05int",
            "fac_AU06int",
            "fac_AU07int",
            "fac_AU09int",
            "fac_AU10int",
            "fac_AU12int",
            "fac_AU14int",
            "fac_AU15int",
            "fac_AU17int",
            "fac_AU20int",
            "fac_AU23int",
            "fac_AU25int",
            "fac_AU26int",
            "fac_AU45int",
            "fac_AU01pres",
            "fac_AU02pres",
            "fac_AU04pres",
            "fac_AU05pres",
            "fac_AU06pres",
            "fac_AU07pres",
            "fac_AU09pres",
            "fac_AU10pres",
            "fac_AU12pres",
            "fac_AU14pres",
            "fac_AU15pres",
            "fac_AU17pres",
            "fac_AU20pres",
            "fac_AU23pres",
            "fac_AU25pres",
            "fac_AU26pres",
            "fac_AU28pres",
            "fac_AU45pres",
        ]

    def _fit_transform(self, path):
        return run_face_au(path, f"{tempfile.gettempdir()}/", self.r_config, save=False)
