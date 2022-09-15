from opendbm.api_lib.model import AudioModel
from opendbm.dbm_lib import run_mfcc


class MFCC(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = ["aco_mfcc" + str(i) for i in range(1, 13)]

    @AudioModel.prep_func
    def _fit_transform(self, path, **kwargs):
        return run_mfcc(path, ".", self.r_config, save=False)
