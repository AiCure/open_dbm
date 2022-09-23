import numpy as np
from numpy.testing import assert_allclose
from pytest import mark


@mark.non_docker
@mark.acoustic
class AcousticTest:
    def test_get_audio_intensity(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = 52.867660826299
        actual_std = 6.357796

        res_mp4 = processing_verbal_acoustics_mp4.get_audio_intensity()
        res_wav = processing_verbal_acoustics_wav.get_audio_intensity()

        # testing mean actual vs desired
        assert np.isclose(res_mp4.mean().item(), actual_mean, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.mean().item(), actual_mean, rtol=0.1, atol=1e-8)

        # testing std actual vs desired
        assert np.isclose(res_mp4.std().item(), actual_std, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.std().item(), actual_std, rtol=0.1, atol=1e-8)

    def test_get_pitch_frequency(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = 27.270735
        actual_std = 58.073703

        res_mp4 = processing_verbal_acoustics_mp4.get_pitch_frequency()
        res_wav = processing_verbal_acoustics_wav.get_pitch_frequency()

        assert np.isclose(res_mp4.mean().item(), actual_mean, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.mean().item(), actual_mean, rtol=0.1, atol=1e-8)

        assert np.isclose(res_mp4.std().item(), actual_std, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.std().item(), actual_std, rtol=0.1, atol=1e-8)

    def test_get_formant_frequency(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = [679.47914618, 1788.237625, 2931.83885151, 4075.29506138]
        actual_std = [366.35888699, 472.92129736, 543.15256087, 431.39331643]

        res_mp4 = processing_verbal_acoustics_mp4.get_formant_frequency()
        res_wav = processing_verbal_acoustics_wav.get_formant_frequency()

        assert_allclose(res_mp4.mean(), actual_mean, rtol=0.1, atol=1e-8)
        assert_allclose(res_wav.mean(), actual_mean, rtol=0.1, atol=1e-8)

        assert_allclose(res_mp4.std(), actual_std, rtol=0.1, atol=1e-8)
        assert_allclose(res_wav.std(), actual_std, rtol=0.1, atol=1e-8)

    def test_get_harmonic_noise(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = 3.154794
        actual_std = 7.389723

        res_mp4 = processing_verbal_acoustics_mp4.get_harmonic_noise()
        res_wav = processing_verbal_acoustics_wav.get_harmonic_noise()

        assert np.isclose(res_mp4.mean().item(), actual_mean, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.mean().item(), actual_mean, rtol=0.1, atol=1e-8)

        assert np.isclose(res_mp4.std().item(), actual_std, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.std().item(), actual_std, rtol=0.1, atol=1e-8)

    def test_get_glottal_noise(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = 0.86287177
        actual_std = 0.106516901

        res_mp4 = processing_verbal_acoustics_mp4.get_glottal_noise()
        res_wav = processing_verbal_acoustics_wav.get_glottal_noise()

        assert np.isclose(res_mp4.mean().item(), actual_mean, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.mean().item(), actual_mean, rtol=0.1, atol=1e-8)

        assert np.isclose(res_mp4.std().item(), actual_std, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.std().item(), actual_std, rtol=0.1, atol=1e-8)

    def test_get_jitter(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = 0.041403506
        actual_std = 0.026209854

        res_mp4 = processing_verbal_acoustics_mp4.get_jitter()
        res_wav = processing_verbal_acoustics_wav.get_jitter()

        assert np.isclose(res_mp4.mean().item(), actual_mean, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.mean().item(), actual_mean, rtol=0.1, atol=1e-8)

        assert np.isclose(res_mp4.std().item(), actual_std, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.std().item(), actual_std, rtol=0.1, atol=1e-8)

    def test_get_shimmer(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = 0.2018721891
        actual_std = 0.0584668629

        res_mp4 = processing_verbal_acoustics_mp4.get_shimmer()
        res_wav = processing_verbal_acoustics_wav.get_shimmer()

        assert np.isclose(res_mp4.mean().item(), actual_mean, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.mean().item(), actual_mean, rtol=0.1, atol=1e-8)

        assert np.isclose(res_mp4.std().item(), actual_std, rtol=0.1, atol=1e-8)
        assert np.isclose(res_wav.std().item(), actual_std, rtol=0.1, atol=1e-8)

    def test_get_pause_characteristics(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = [84.76, 28.84, 32, 55.92, 0.65974516]

        res_mp4 = processing_verbal_acoustics_mp4.get_pause_characteristics()
        res_wav = processing_verbal_acoustics_wav.get_pause_characteristics()

        assert_allclose(res_mp4.mean(), actual_mean, rtol=0.1, atol=1e-8)
        assert_allclose(res_wav.mean(), actual_mean, rtol=0.1, atol=1e-8)

    def test_get_voice_prevalence(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = [1865.0, 8794.0, 21.207641573800316]

        res_mp4 = processing_verbal_acoustics_mp4.get_voice_prevalence()
        res_wav = processing_verbal_acoustics_wav.get_voice_prevalence()

        assert_allclose(res_mp4.mean(), actual_mean, rtol=0.1, atol=1e-8)
        assert_allclose(res_wav.mean(), actual_mean, rtol=0.1, atol=1e-8)

    def test_get_mfcc(
        self, processing_verbal_acoustics_mp4, processing_verbal_acoustics_wav
    ):
        actual_mean = [
            491.835,
            -37.714,
            82.164,
            64.293,
            -33.829,
            54.35,
            6.563,
            -6.669,
            31.392,
            -8.672,
            9.302,
            8.096,
        ]
        actual_std = [
            71.555,
            83.91,
            65.506,
            32.296,
            38.059,
            35.283,
            30.122,
            23.462,
            21.292,
            21.183,
            18.607,
            17.101,
        ]

        res_mp4 = processing_verbal_acoustics_mp4.get_mfcc()
        res_wav = processing_verbal_acoustics_wav.get_mfcc()

        assert_allclose(res_mp4.mean(), actual_mean, rtol=0.1, atol=1e-8)
        assert_allclose(res_wav.mean(), actual_mean, rtol=0.1, atol=1e-8)

        assert_allclose(res_mp4.std(), actual_std, rtol=0.1, atol=1e-8)
        assert_allclose(res_wav.std(), actual_std, rtol=0.1, atol=1e-8)

    def test_dummy_1(self):
        assert True

    def test_dummy_2(self):
        assert True
