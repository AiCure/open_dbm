---
id: formant-frequencies
title: Formant Frequencies
---

## Formant Frequencies (f<sub>1-4</sub>)

Formants are spectral peaks in the sound spectrum that are typically distributed in bands across different frequencies[^1]. OpenDBM outputs values for the first four formants (f<sub>1-4</sub>), with N in the variable names in the tables below referring to the formant number.


[^1]: https://en.wikipedia.org/wiki/Fundamental_frequency

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_fmN`      | **Formant frequency.** Frame-wise formant frequency (f<sub>N</sub>) measurements, with N being 1, 2, 3, or 4, referring to the 1st, 2nd, 3rd, or 4th formant respectively.    |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_fmN_mean`      | **Formant frequency mean.** Mean of the Nth formant (f<sub>N</sub>) across all audio frames.     |
| `aco_fmN_std`      | **Formant frequency standard deviation.** Standard deviation of the Nth formant (f<sub>N</sub>) across all audio frames.     |
