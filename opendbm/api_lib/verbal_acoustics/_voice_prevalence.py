import pandas as pd

from opendbm.api_lib.model import AudioModel
from opendbm.dbm_lib.dbm_features.raw_features.audio.voice_frame_score import run_vfs


class VoicePrevalence(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = ["aco_voiceframe", "aco_totvoiceframe", "aco_voicepct"]

    @AudioModel.prep_func
    def _fit_transform(self, path, **kwargs):
        return run_vfs(path, ".", self.r_config, save=False)
