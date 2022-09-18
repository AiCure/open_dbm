import pandas as pd

from opendbm.api_lib.model import AudioModel
from opendbm.dbm_lib import run_formant


class FormantFrequency(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = ["aco_fm1", "aco_fm2", "aco_fm3", "aco_fm4"]

    @AudioModel.prep_func
    def _fit_transform(self, path, **kwargs):
        return run_formant(path, ".", self.r_config, save=False)
