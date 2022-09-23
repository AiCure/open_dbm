import importlib
import sys

from pytest import fixture

from opendbm import FacialActivity, Movement, Speech, VerbalAcoustics

# sys.path.append("")
# Movement = importlib.import_module("api_lib.movement")
# Speech = importlib.import_module("api_lib.speech")
# Facial = importlib.import_module("api_lib.facial_activity")
# Verbal_acoustics = importlib.import_module("api_lib.verbal_acoustics")


class Model:
    def __init__(self, movement, speech, facial, verbal_acoustics):
        self._movement = movement
        self._speech = speech
        self._facial = facial
        self._verbal_acoustics = verbal_acoustics

    @property
    def movement(self):
        return self._movement()

    @property
    def speech(self):
        return self._speech()

    @property
    def facial(self):
        return self._facial()

    @property
    def verbal_acoustics(self):
        return self._verbal_acoustics()


@fixture(scope="session")
def get_model():
    m = Model(Movement, Speech, FacialActivity, VerbalAcoustics)
    return m
