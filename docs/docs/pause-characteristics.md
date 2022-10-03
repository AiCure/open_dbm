---
id: pause-characteristics
title: Pause Characteristics
---

Fundamental frequency is usually zero when there is no voice detected. Using this understanding, frames where voice is or is not present can be determined and used to characterize pauses during speech and silence during the audio file. These metrics are quantified here.

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_pausetime`      | **Pause time.** Length of time with no speech detected.    |
| `aco_totaltime`      | **Video length.** The length of the video.    |
| `aco_speakingtime`      | **Time spoken.** The total length of time with speech detected.    |
| `aco_numpauses`      | **Number of pauses.** Number of instances with no speech.    |
| `aco_pausefrac`      | **Pause time.** aco_pausetime divided by aco_totaltime.    |


## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `aco_pausetime_mean`      | **Pause time.** Length of time with no speech detected.    |
| `aco_totaltime_mean`      | **Video length.** The length of the video.     |
| `aco_numpauses_mean`      | **Number of pauses.** Number of instances with no speech.     |
| `aco_pausefrac_mean`      | **Fraction of video with pauses.** `aco_pausetime_mean` divided by `aco_totaltime_mean`.     |

> Note: The overlap between raw and derived variables for this section may be confusing; it’s a leftover effect of how our code is organized in the AiCure product, where several videos from the same individual at the same time point are averaged. For your purposes, simply rely on the derived variables here.