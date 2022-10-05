---
id: eye-gaze-directionality
title: Eye Gaze Directionality
---

Eye gaze directionality is another output we get from OpenFace. The variables below allow for measurements of eye gaze behavior.

### Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `mov_lefteyex`      | x coordinate of the left eye at the current video frame. |
| `mov_lefteyey`      | y coordinate of the left eye at the current video frame. |
| `mov_lefteyez`      | z coordinate of the left eye at the current video frame. |
| `mov_righteyex`      | x coordinate of the right eye at the current video frame. |
| `mov_righteyey`      | y coordinate of the right eye at the current video frame. |
| `mov_righteyez`      | z coordinate of the right eye at the current video frame. |
| `mov_leyedisp`      | **Euclidean displacement in the left eye gaze** at the current video frame; this tells the overall movement in eye gaze direction in each frame. |
| `mov_reyedisp`      | **Euclidean displacement in the right eye gaze** at the current video frame; this tells the overall movement in eye gaze direction in each frame. |

### Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `mov_lefteyex_mean`      | **Mean x coordinate of the left eye** i.e. the average of the vector `mov_lefteyex`. |
| `mov_lefteyex_std`      | **Standard deviation of x coordinate of the left eye** i.e. the standard deviation of the vector `mov_lefteyex`. |
| `mov_lefteyey_mean`      | **Mean y coordinate of the left eye** i.e. the average of the vector `mov_lefteyey`. |
| `mov_lefteyey_std`      | **Standard deviation of y coordinate of the left eye** i.e. the standard deviation of the vector `mov_lefteyey`. |
| `mov_lefteyez_mean`      | **Mean z coordinate of the left eye** i.e. the average of the vector `mov_lefteyez`. |
| `mov_lefteyez_std`      | **Standard deviation of z coordinate of the left eye** i.e. the standard deviation of the vector `mov_lefteyez`. |
| `mov_righteyex_mean`      | **Mean x coordinate of the right eye** i.e. the average of the vector `mov_righteyex`. |
| `mov_righteyex_std`      | **Standard deviation of x coordinate of the right eye** i.e. the standard deviation of the vector `mov_righteyex`. |
| `mov_righteyey_mean`      | **Mean y coordinate of the right eye** i.e. the average of the vector `mov_righteyey`. |
| `mov_righteyey_std`      | **Standard deviation of y coordinate of the right eye** i.e. the standard deviation of the vector `mov_righteyey`. |
| `mov_righteyez_mean`      | **Mean z coordinate of the right eye** i.e. the average of the vector `mov_righteyez`. |
| `mov_righteyez_std`      | **Standard deviation of z coordinate of the right eye** i.e. the standard deviation of the vector `mov_righteyez`. |
| `mov_leyedisp_mean`      | **Mean euclidean displacement in the left eye gaze** over the course of the video. |
| `mov_leyedisp_std`      | **Standard deviation of euclidean displacement in the left eye gaze** over the course of the video. |
| `mov_reyedisp_mean`      | **Mean euclidean displacement in the right eye gaze** over the course of the video. |
| `mov_reyedisp_std`      | **Standard deviation of euclidean displacement in the right eye gaze** over the course of the video. |