---
id: voice-prevalence
title: Voice Prevalence
---

Using knowledge on which audio frames do and do not contain voice, the prevalence of voice as opposed to silence across the audio file is also calculated simply as a derived variable.

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_voiceframe`      | **Voice frames.** Number of frames in the audio where speech was detected.    |
| `aco_totvoiceframe`      | **Total frames.** Total number of frames in the audio.    |
| `aco_voicepct`      | **Percentage of frames with voice.** `aco_voiceframe` divided by `aco_totvoiceframe`.    |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_voicepct_mean`      | **Percentage of frames with voice mean.**   |