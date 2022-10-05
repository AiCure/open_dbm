---
id: emotional-expressivity
title: Emotional Expressivity
---

Continuing to lean on FACS, action unit presence and intensity values are used to measure presence and intensity of emotional expressions, given that combinations of different action units refer to individual emotions as outlined in the table below:

|   Emotion	| EMO	| Action Units  |
| ----------- | ----------- | ---- | 
|   Happiness	| hap |	6 + 12  |
|   Sadness	  | sad |	1 + 4 + 15  |
|   Surprise	| sur |	1 +2 + 5 + 26 |
|   Fear	  | fea	  | 1 + 2 + 4 + 5 + 7 + 20 + 26 |
|   Anger	  | ang |	4 + 5 + 7 + 23  |
|   Disgust | dig | 9 + 15 + 16 |
|   Contempt  |	con	  | 12 + 14 |

For each of the emotions listed in the table above, the tables below list the raw and derived variables that are calculated for each, with EMO in the variable names referring to any of the seven major emotions as per the short forms in the table above.

## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_EMOpres`      | **Emotion presence.** Binary vector indicating the presence/absence of an emotion in each video frame, with presence being 1 if all action units for that emotion are present.     |
| `fac_EMOintsoft`      | **Emotion intensity ‘soft’.** Continuous vector indicating intensity of the emotion in each video frame regardless of whether all action units for that emotion are present. Range is between 0 and 1.     |
| `fac_EMOinthard`      | **Emotion intensity ‘hard’.** Continuous vector indicating intensity of the emotion in each video frame, only providing non-zero value if all action units for that emotion are present. Range is between 0 and 1.     |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_EMOpres_pct`      | **Emotion presence percentage.** Percentage of frames in the video where the emotion was present, as defined by all action units being present for a given emotion.     |
| `fac_EMOintsoft_mean`      | **Emotional expressivity ‘soft’ mean.** Mean of all fac_EMOintsoft values calculated from the video.     |
| `fac_EMOintsoft_std`      | **Emotional expressivity ‘soft’ standard deviation** of all fac_EMOintsoft values calculated from the video.  
| `fac_EMOinthard_mean`      | **Emotional expressivity ‘hard’ mean.** Mean of all fac_EMOinthard values calculated from the video. |

