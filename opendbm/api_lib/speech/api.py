import logging
import os

from opendbm.api_lib import DEEEPSPEECH_URL, DEEPSPEECH_MODELS, OPENDBM_DATA, AudioModel
from opendbm.api_lib.util import check_file, check_isfile, download_url

from ._speech_features import SpeechFeature
from ._transcribe import Transcribe

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


class Speech(AudioModel):
    def __init__(self):
        super().__init__()
        self._transcribe = Transcribe()
        self._speech_features = SpeechFeature()
        self._models = {
            "transcribe": self._transcribe,
            "speech_features": self._speech_features,
        }

    def fit(self, path):
        """Fit a file in filepath to Deepspeech Model.

        Parameters
        ----------
        path : string,
            File Path of Video/Sound file format.
        """
        check_isfile(path)
        self._check_model_exists()
        path, is_wav = check_file(path)
        for v in self._models.values():
            v._df = v._fit_transform(path)
        if not is_wav:
            os.remove(path)

    @staticmethod
    def _check_model_exists():
        """
        Check if deepspeech model is exists. if not, download to OPENDBM Directory.
        """
        if not OPENDBM_DATA.exists():
            os.mkdir(OPENDBM_DATA)
        for dm in DEEPSPEECH_MODELS:
            pt = OPENDBM_DATA / dm
            if not pt.exists():
                logger.info(
                    f"{dm} not exists. Automatically downloading to {OPENDBM_DATA}/"
                )
                download_url(f"{DEEEPSPEECH_URL}/{dm}", pt)
            else:
                continue

    def get_transcribe(self):
        """
        Get the model object of Transcribe
        Returns:
        self: object
            Model Object
        """
        return self._transcribe

    def get_speech_features(self):
        """
        Get the model object of Speech Features
        Returns:
        self: object
            Model Object
        """
        return self._speech_features
