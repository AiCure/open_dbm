---
id: eye-blink-behavior
title: Eye Blink Behavior
---

Eye blinks are measured by first calculating a variable called eye aspect ratio (EAR), which we get from [here](http://dlib.net/face_landmark_detection.py.html), and is basically just a quantification of how open the eye is. Over the course of a video, the EAR ends up being a vector whose troughs most likely signify individual eye blinks. The troughs are identified using a *find peaks* function and for each trough, the EAR value is outputted along with the other raw variables described below.

### Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `mov_blink_ear`      | **Eye aspect ratio** i.e. a vector derived from [this model](http://dlib.net/face_landmark_detection.py.html) at points in the video where an eye blink was detected. |
| `mov_blinkframe`      | **Eye blink times** are indices of the video frames where an eye blink was detected.  |
| `mov_blinkdur`      | **Durations between blinks** is the time spanned between the current blink and the previous blink in seconds.     |

### Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `mov_blink_ear_mean`      | **Eye aspect ratio mean**  i.e. the mean of the vector `mov_blink_ear`.  |
| `mov_blink_ear_std`      | **Eye aspect ratio standard deviation**  i.e. the standard deviation of the vector `mov_blink_ear`.  |
| `mov_blink_count`      | **Number of blinks**  measured over the course of the video.  |
| `mov_blinkdur_mean`      | **Mean duration between eye blinks** measured in seconds.   |
| `mov_blinkdur_std`      | **Standard deviation of duration between eye blinks**  measured in seconds.  |