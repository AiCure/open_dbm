import tempfile

from opendbm.api_lib.model import OPENDBM_DATA, AudioModel
from opendbm.dbm_lib import run_speech_feature


class SpeechFeature(AudioModel):
    def __init__(self):
        super().__init__()
        self._params = [
            "nlp_numSentences",
            "nlp_singPronPerAns",
            "nlp_singPronPerSen",
            "nlp_pastTensePerAns",
            "nlp_pastTensePerSen",
            "nlp_pronounsPerAns",
            "nlp_pronounsPerSen",
            "nlp_verbsPerAns",
            "nlp_verbsPerSen",
            "nlp_adjectivesPerAns",
            "nlp_adjectivesPerSen",
            "nlp_nounsPerAns",
            "nlp_nounsPerSen",
            "nlp_sentiment_mean",
            "nlp_mattr",
            "nlp_wordsPerMin",
            "nlp_totalTime",
        ]

    @AudioModel.prep_func
    def _fit_transform(self, path):
        return run_speech_feature(
            path, f"{tempfile.gettempdir()}/", self.r_config, OPENDBM_DATA, save=False
        )
