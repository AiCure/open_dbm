import os
from collections import OrderedDict

from opendbm.api_lib.model import AudioModel
from opendbm.api_lib.util import check_file, check_isfile
from opendbm.dbm_lib.controller import process_feature as pf

from ._audio_intensity import AudioIntensity
from ._formant_frequency import FormantFrequency
from ._glottal_noise import GlottalNoiseRatio
from ._harmonic_noise import HarmonicsNoiseRatio
from ._jitter import Jitter
from ._mfcc import MFCC
from ._pause_characteristics import PauseCharacteristics
from ._pitch_frequency import PitchFrequency
from ._shimmer import Shimmer
from ._voice_prevalence import VoicePrevalence


class VerbalAcoustics(AudioModel):
    def __init__(self):
        super().__init__()
        self._auint = AudioIntensity()
        self._pitchfreq = PitchFrequency()
        self._forfreq = FormantFrequency()
        self._hnr = HarmonicsNoiseRatio()
        self._gne = GlottalNoiseRatio()
        self._jitter = Jitter()
        self._shimmer = Shimmer()
        self._pchar = PauseCharacteristics()
        self._vopre = VoicePrevalence()
        self._mfcc = MFCC()
        self._models = OrderedDict(
            {
                "audio_intensity": self._auint,
                "pitch_frequency": self._pitchfreq,
                "formant_frequency": self._forfreq,
                "harmonic_noise": self._hnr,
                "glottal_noise": self._gne,
                "jitter": self._jitter,
                "shimmer": self._shimmer,
                "pause_characteristics": self._pchar,
                "voice_prevalence": self._vopre,
                "mfcc": self._mfcc,
            }
        )

    def fit(self, path):
        """Fit a file in filepath to parselmouth Model.

        Parameters
        ----------
        path : string,
            File Path of Video/Sound file format.
        """
        check_isfile(path)
        path, is_wav = check_file(path)
        for k, v in self._models.items():
            if k in ["glottal_noise", "jitter", "shimmer"]:
                v._df = v._fit_transform(path, ff_df=self._pitchfreq._df)
            else:
                v._df = v._fit_transform(path)
        if not is_wav:
            os.remove(path)

    def get_audio_intensity(self):
        """
        Get the model object of Audio Intensity
        Returns:
        self: object
            Model Object
        """
        return self._auint

    def get_pitch_frequency(self):
        """
        Get the model object of Pitch Frequency
        Returns:
        self: object
            Model Object
        """
        return self._pitchfreq

    def get_formant_frequency(self):
        """
        Get the model object of Formant Frequency
        Returns:
        self: object
            Model Object
        """
        return self._forfreq

    def get_harmonic_noise(self):
        """
        Get the model object of Harmonic Noise
        Returns:
        self: object
            Model Object
        """
        return self._hnr

    def get_glottal_noise(self):
        """
        Get the model object of Glottal Noise
        Returns:
        self: object
            Model Object
        """
        return self._gne

    def get_jitter(self):
        """
        Get the model object of Jitter
        Returns:
        self: object
            Model Object
        """
        return self._jitter

    def get_shimmer(self):
        """
        Get the model object of Shimmer
        Returns:
        self: object
            Model Object
        """
        return self._shimmer

    def get_pause_characteristics(self):
        """
        Get the model object of Pause Characteristics
        Returns:
        self: object
            Model Object
        """
        return self._pchar

    def get_voice_prevalence(self):
        """
        Get the model object of Vocal Prevalence
        Returns:
        self: object
            Model Object
        """
        return self._vopre

    def get_mfcc(self):
        """
        Get the model object of MFCC
        Returns:
        self: object
            Model Object
        """
        return self._mfcc
