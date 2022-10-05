---
id: action-units
title: Action units
---

Action units (AUs) are individual facial musculature arrangements specified in the [Facial Action Coding System (FACS)](https://en.wikipedia.org/wiki/Facial_Action_Coding_System), combinations of which can account for all possible facial expressions[^1]. OpenDBM outputs framewise values for AU presence and intensity for the following AUs: 

| Action unit number      | Description |
| ----------- | ----------- |
| AU1      | Inner brow raiser       |
| AU2   | Outer brow raiser        |
| AU4   |  Brow lowerer |
| AU5   |  Upper lid raiser |
| AU6   |  Cheek raiser |
| AU7   |  Lid tightener    |
| AU9   |  Nose wrinkler    |
| AU12  |  Lip corner puller    |
| AU15  |  Lip corner depressor |
| AU16  |  Lower lip depressor  |
| AU20  |  Lip stretcher    |
| AU23  |  Lip tightener    |
| AU26  |  Jaw drop |

For each of the AUs in the table above, the following raw variables are calculated:

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_auXXpres`      | **Action Unit presence,** where XX refers to the action unit. This is a binary (1/0) variable, where 1 signifies presence of the action unit and 0 signifies its absence as determined by OpenFace.      |
| `fac_auXXint`      | **Action Unit intensity,** where XX refers to the action unit. This is a continuous (0-5) variable, where 0 signifies no presence and 5 signifies maximum presence, as determined by OpenFace.     |
## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_auXXpres_pct`      | **Action Unit presence percentage.** Using the binary vector fac_auXXpres, the percentage of video frames where an AU was present is calculated into this variable.      |
| `fac_auXXint_mean`      | **Action Unit intensity mean.** Mean value of fac_auXXint over the course of the video.       |
| `fac_auXXint_std`      | **Action Unit intensity standard deviation.** Standard deviation of fac_auXXint over the course of the video.       |


[^1]: Ekman, R. (1997). What the face reveals: Basic and applied studies of spontaneous expression using the Facial Action Coding System (FACS). Oxford University Press, USA.