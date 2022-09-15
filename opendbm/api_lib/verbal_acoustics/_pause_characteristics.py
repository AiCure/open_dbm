import pandas as pd

from opendbm.api_lib.model import AudioModel
from opendbm.dbm_lib import run_pause_segment


class PauseCharacteristics(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = [
            "aco_totaltime",
            "aco_speakingtime",
            "aco_numpauses",
            "aco_pausetime",
            "aco_pausefrac",
        ]

    @AudioModel.prep_func
    def _fit_transform(self, path, **kwargs):
        return run_pause_segment(path, ".", self.r_config, save=False)
