import pandas as pd

from opendbm.api_lib.model import AudioModel
from opendbm.dbm_lib.dbm_features.raw_features.audio.hnr import run_hnr


class HarmonicsNoiseRatio(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = ["aco_hnr"]

    @AudioModel.prep_func
    def _fit_transform(self, path, **kwargs):
        return run_hnr(path, ".", self.r_config, save=False)
