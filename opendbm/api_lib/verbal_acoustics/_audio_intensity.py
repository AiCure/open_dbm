from opendbm.api_lib.model import AudioModel
from opendbm.dbm_lib import run_intensity


class AudioIntensity(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = ["aco_int"]

    @AudioModel.prep_func
    def _fit_transform(self, path, **kwargs):
        return run_intensity(path, ".", self.r_config, save=False)
