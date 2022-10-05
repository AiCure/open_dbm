---
id: facial-asymmetry
title: Facial Asymmetry
---

Using facial landmark detection described in Section 5.1.1, an additional measurement that is made is that of facial asymmetry. Frame-wise and overall asymmetry in landmarks on the left vs. right side of the face is quantified and saved in the following raw and derived variables.

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_asymmaskmouth`      | **Mouth asymmetry.** Frame-wise asymmetry in the mouth area.    |
| `fac_asymmaskeye`      | **Eye asymmetry.** Frame-wise asymmetry in the eye area.    |
| `fac_asymmaskeyebrow`      | **Eyebrow asymmetry.** Frame-wise asymmetry in the Eyebrow area.    |
| `fac_asymmaskcom`      |  **Overall asymmetry.** Frame-wise asymmetry across the face.    |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_asymmaskmouth_mean`      | **Mouth asymmetry mean** across the video.     |
| `fac_asymmaskmouth_std`      | **Mouth asymmetry standard deviation** across the video.     |
| `fac_asymmaskeye_mean`      | **Eye asymmetry mean** across the video.     |
| `fac_asymmaskeye_std`      | **Eye asymmetry standard deviation** across the video.     |
| `fac_asymmaskeyebrow_mean`      | **Eyebrow asymmetry mean** across the video.     |
| `fac_asymmaskeyebrow_std`      | **Eyebrow asymmetry standard deviation** across the video.     |
| `fac_asymmaskcom_mean`      | **Overall asymmetry mean** across the video.     |
| `fac_asymmaskcom_std`      | **Overall asymmetry standard deviation** across the video.     |