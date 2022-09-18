import tempfile

from opendbm.api_lib.model import OPENDBM_DATA, AudioModel
from opendbm.dbm_lib.dbm_features.raw_features.nlp.transcribe import run_transcribe


class Transcribe(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = ["nlp_transcribe", "nlp_totalTime"]

    @AudioModel.prep_func
    def _fit_transform(self, path):
        return run_transcribe(
            path, f"{tempfile.gettempdir()}/", self.r_config, OPENDBM_DATA, save=False
        )
