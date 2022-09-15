import tempfile

from opendbm.api_lib.model import VideoModel
from opendbm.dbm_lib import fac_tremor_process


class FacialTremor(VideoModel):
    def __init__(self):
        super().__init__()
        self._params = [
            "fac_features_mean_5",
            "fac_tremor_median_5",
            "fac_disp_median_5",
            "fac_corr_5",
            "fac_features_mean_12",
            "fac_tremor_median_12",
            "fac_disp_median_12",
            "fac_corr_12",
            "fac_features_mean_8",
            "fac_tremor_median_8",
            "fac_disp_median_8",
            "fac_corr_8",
            "fac_features_mean_48",
            "fac_tremor_median_48",
            "fac_disp_median_48",
            "fac_corr_48",
            "fac_features_mean_54",
            "fac_tremor_median_54",
            "fac_disp_median_54",
            "fac_corr_54",
            "fac_features_mean_28",
            "fac_tremor_median_28",
            "fac_disp_median_28",
            "fac_corr_28",
            "fac_features_mean_51",
            "fac_tremor_median_51",
            "fac_disp_median_51",
            "fac_corr_51",
            "fac_features_mean_66",
            "fac_tremor_median_66",
            "fac_disp_median_66",
            "fac_corr_66",
            "fac_features_mean_57",
            "fac_tremor_median_57",
            "fac_disp_median_57",
            "fac_corr_57",
        ]

    def _fit_transform(self, path):
        return fac_tremor_process(
            path, f"{tempfile.gettempdir()}/", self.r_config, save=False
        )
