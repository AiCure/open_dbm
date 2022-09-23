import numpy as np
from pytest import mark


@mark.non_docker
@mark.speech
class SpeechTest:
    def test_dummy_3(self):
        assert True

    def test_get_transcribe(self, processing_speech_mp4, processing_speech_wav):
        actual_totaltime = 87.978685
        len_words_count = 57

        res_mp4 = processing_speech_mp4.get_transcribe().to_dataframe()
        audio_duration_mp4 = res_mp4["nlp_totalTime"].item()
        transcribed_text_mp4 = res_mp4["nlp_transcribe"].item()

        res_wav = processing_speech_wav.get_transcribe().to_dataframe()
        audio_duration_wav = res_wav["nlp_totalTime"].item()
        transcribed_text_wav = res_wav["nlp_transcribe"].item()

        # test if duration is matched
        assert np.isclose(audio_duration_mp4, actual_totaltime, rtol=0.1, atol=1e-8)
        assert np.isclose(audio_duration_wav, actual_totaltime, rtol=0.1, atol=1e-8)

        # test if there is transcribed text or not
        assert type(transcribed_text_mp4) == str
        assert type(transcribed_text_wav) == str

        # test the length of the text
        assert np.isclose(
            len(transcribed_text_mp4.split(" ")), len_words_count, rtol=0.5, atol=1e-8
        )
        assert np.isclose(
            len(transcribed_text_wav.split(" ")), len_words_count, rtol=0.5, atol=1e-8
        )

    def test_get_speech_features(self, processing_speech_mp4, processing_speech_wav):
        # actual = [
        #     1.0,
        #     2.0,
        #     2.0,
        #     1.0,
        #     1.0,
        #     6.0,
        #     6.0,
        #     11.0,
        #     11.0,
        #     5.0,
        #     5.0,
        #     15.0,
        #     15.0,
        #     -0.8256,
        #     0.08860759493670886,
        #     38.873052120437336,
        #     87.97868480725624,
        # ]

        res_mp4 = (
            processing_speech_mp4.get_speech_features()
            .to_dataframe()
            .drop(columns="dbm_master_url")
        )
        res_wav = (
            processing_speech_wav.get_speech_features()
            .to_dataframe()
            .drop(columns="dbm_master_url")
        )
        desired_mp4 = np.array((res_mp4.iloc[0]))
        desired_wav = np.array((res_wav.iloc[0]))

        # check if there is any zero value or not
        for v1, v2 in zip(desired_mp4, desired_wav):
            assert bool(v1)
            assert bool(v2)
