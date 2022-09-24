# import numpy as np
import pandas as pd
from numpy.testing import assert_allclose
from pytest import mark


# @mark.smoke
# @mark.body
@mark.facial
class FacialTest:
    def test_get_landmark(self, processing_facial_activity):
        df_act = pd.read_csv("tests/test_data/landmark.csv")
        res = processing_facial_activity.get_landmark()

        assert_allclose(df_act.mean(), res.mean(), rtol=0.1, atol=1e-8)
        assert_allclose(df_act.std(), res.std(), rtol=0.1, atol=1e-8)

    def test_get_action_unit(self, processing_facial_activity):

        df_act = pd.read_csv("tests/test_data/action_unit.csv")
        res = processing_facial_activity.get_action_unit()

        assert_allclose(df_act.mean(), res.mean(), rtol=0.1, atol=1e-8)
        assert_allclose(df_act.std(), res.std(), rtol=0.1, atol=1e-8)

    def test_get_asymmetry(self, processing_facial_activity):
        actual_mean = [2.58260995, 3.34416172, 3.0563894, 2.94777878]
        actual_std = [1.74161635, 2.17995634, 2.19173686, 1.82435901]
        res = processing_facial_activity.get_asymmetry()

        assert_allclose(actual_mean, res.mean(), rtol=0.1, atol=1e-8)
        assert_allclose(actual_std, res.std(), rtol=0.1, atol=1e-8)

    def test_get_expressivity(self, processing_facial_activity):
        df_act = pd.read_csv("tests/test_data/expressivity.csv")
        res = processing_facial_activity.get_expressivity()

        assert_allclose(df_act.mean(), res.mean(), rtol=0.35, atol=1e-8)
        assert_allclose(df_act.std(), res.std(), rtol=0.35, atol=1e-8)
