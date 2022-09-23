# import numpy as np
from numpy.testing import assert_allclose
from pytest import mark


# @mark.smoke
# @mark.body
@mark.movement
class MovementTest:
    def test_get_head_movement(self, processing_movement):
        actual_mean = [1.3946, 0.3011, -0.1183, 0.003, 0.0094]
        actual_std = [1.2644, 0.0786, 0.0649, 0.0342, 0.008]
        res = processing_movement.get_head_movement()

        assert_allclose(actual_mean, res.mean(), rtol=0.1, atol=1e-8)
        assert_allclose(actual_std, res.std(), rtol=0.1, atol=1e-8)

    def test_get_eye_blink(self, processing_movement):
        actual_mean = [0.1101, 455.5, 2.2931, 29.0]
        actual_std = [0.0241, 311.8611, 1.1407, 0.0]
        res = processing_movement.get_eye_blink()

        assert_allclose(actual_mean, res.mean(), rtol=0.1, atol=1e-8)
        assert_allclose(actual_std, res.std(), rtol=0.1, atol=1e-8)

    def test_get_eye_gaze(self, processing_movement):
        actual_mean = [0.2292, 0.4174, -0.8761, 0.0209, 0.4191, -0.9046, 0.0145, 0.0132]
        actual_std = [0.0546, 0.048, 0.0218, 0.0462, 0.0542, 0.0243, 0.0156, 0.0169]
        res = processing_movement.get_eye_gaze()

        assert_allclose(actual_mean, res.mean(), rtol=0.1, atol=1e-8)
        assert_allclose(actual_std, res.std(), rtol=0.1, atol=1e-8)

    def test_get_facial_tremor(self, processing_movement):
        actual_mean = [
            8.5948,
            3.8759,
            0.7286,
            0.2546,
            3.7195,
            2.8068,
            0.7231,
            0.4562,
            6.7215,
            3.5861,
            0.8253,
            0.3912,
            2.8608,
            2.1741,
            0.8614,
            0.6464,
            3.6781,
            2.6698,
            0.887,
            0.5783,
            0.0,
            0.0,
            0.6772,
            1.0,
            0.7655,
            0.5476,
            0.7504,
            0.8978,
            1.9713,
            1.4991,
            0.9381,
            0.7761,
            2.706,
            2.019,
            0.9885,
            0.7138,
        ]

        res = processing_movement.get_facial_tremor()

        assert_allclose(actual_mean, res.mean(), rtol=0.1, atol=1e-8)

    def test_get_vocal_tremor(self, processing_movement):
        actual_mean = [4.23, 9.437, 7.634, 7.38, 61.642, 54.287]

        res = processing_movement.get_vocal_tremor()

        assert_allclose(actual_mean, res.mean(), rtol=0.1, atol=1e-8)

    def test_dummy_movement(self):
        assert True
