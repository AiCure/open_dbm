---
id: overall-expressivity
title: Overall expressivity
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

Overall expressivity is a measure of facial expressivity regardless of emotional state. All action unit values are combined to determine the overall expressivity of the face, typically useful for measurement of blunted affect or disruption of facial expression as a consequence of motor retardation.

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_comintsoft`      | **Overall expressivity ‘soft’,** equivalent to the average of all `fac_EMOintsoft` variables.    |
| `fac_cominthard`      | **Overall expressivity ‘hard’,** equivalent to the average of all `fac_cominthard` variables.    |
| `fac_comlowintsoft`      | **Overall expressivity ‘soft’,** for the lower half of the face.    |
| `fac_comlowinthard`      | **Overall expressivity 'hard',** for the lower half of the face.    |
| `fac_comuppintsoft`      | **Overall expressivity ‘soft’,** for the upper half of the face.    |
| `fac_comuppinthard`      | **Overall expressivity hard,** for the upper half of the face.    |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_comintsoft_pct`      | **Overall expressivity as measured through presence of emotions** i.e. the number of frames when any given emotion was being detected.     |
| `fac_comintsoft_mean`      | **Overall expressivity ‘soft’ mean,** equal to the average of all `fac_comintsoft` values.     |
| `fac_comintsoft_std`      | **Overall expressivity ‘soft’ standard deviation,** i.e. the standard deviation of `fac_comintsoft`. |
| `fac_cominthard_mean`      | **Overall expressivity ‘hard’ mean,** equal to the average of all fac_cominthard values. |
| `fac_cominthard_std`      | **Overall expressivity ‘hard’ standard deviation,** i.e. the standard deviation of `fac_comintsoft`. |
| `fac_comlowintsoft_pct`      | Percentage of frames where any given emotion was detected in the lower half of the face. |
| `fac_comlowintsoft_mean`      | **Overall expressivity ‘soft’ mean,** for the lower half of the face. |
| `fac_comlowintsoft_std`      | **Overall expressivity ‘soft’ standard deviation,** for the lower half of the face. |
| `fac_comuppinthard_mean`      | **Overall expressivity ‘hard’ mean,** for the upper half of the face. |
| `fac_comuppinthard_std`      | **Overall expressivity ‘hard’ standard deviation,** for the upper half of the face. |