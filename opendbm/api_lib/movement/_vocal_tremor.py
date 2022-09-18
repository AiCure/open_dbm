from opendbm.api_lib.model import VideoModel
from opendbm.dbm_lib.dbm_features.raw_features.movement.voice_tremor import run_vtremor


class VocalTremor(VideoModel):
    def __init__(self):
        super().__init__()
        self._params = [
            "mov_freqtremfreq",
            "mov_freqtremindex",
            "mov_freqtrempindex",
            "mov_amptremfreq",
            "mov_amptremindex",
            "mov_amptrempindex",
        ]

    def _fit_transform(self, path):
        return run_vtremor(path, ".", self.r_config, save=False)
