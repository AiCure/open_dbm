---
id: jitter
title: Jitter
---

The jitter of an audio signal is the parameter of frequency variation from cycle to cycle[^1], and is affected mainly by the lack of control over vocal cord vibration.

[^1]: https://en.wikipedia.org/wiki/Jitter

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_jitter`      | **Jitter.** Frame-wise measurements of jitter.    |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_jitter_mean`      | **Jitter mean.** Mean of `aco_jitter` across the audio file.     |
| `aco_jitter_std`      | **Jitter standard deviation.** Standard deviation of `aco_jitter` across the audio file.     |
