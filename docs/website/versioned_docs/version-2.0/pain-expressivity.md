---
id: pain-expressivity
title: Pain Expressivity
---

Similar to emotion expressivity, pain expressivity is calculated using a combination of action units as defined in the Facial Action Coding System (FACS)[^1]. The following action units have been found to be associated with pain according to reports in the scientific literature: 4 + 6 + 7 + 9 + 10 + 12 + 20 + 26.[^2] 

[^1]: https://en.wikipedia.org/wiki/Facial_Action_Coding_System
[^2]: Prkachin, Kenneth M. (1992). The consistency of facial expressions of pain: a comparison across modalities. Pain, 51(3), 297–306.

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_paiintsoft`      | **Pain intensity ‘soft’.** Continuous vector indicating intensity of pain in each video frame regardless of whether *all* action units for that emotion are present. Range is between 0 and 1.    |
| `fac_paiinthard`      | **Pain intensity ‘hard’.** Continuous vector indicating intensity of pain in each video frame, only providing non-zero value if *all* action units for that emotion are present. Range is between 0 and 1.    |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_paiintsoft_pct`      | Percentage of frames where at least one of the pain AUs were detected.     |
| `fac_paiintsoft_mean`      | **Pain expressivity ‘soft’ mean,** equal to the average of all `fac_paiintsoft` values.     |
| `fac_paiintsoft_std`      | **Pain expressivity ‘soft’ standard deviation.**   |
| `fac_paiinthard_mean`      | **Pain expressivity ‘hard’ mean,** equal to the average of all fac_paiinthard values.     |
| `fac_paiinthard_std`      | **Pain expressivity ‘hard’ standard deviation.**      |
