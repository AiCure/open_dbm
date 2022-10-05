---
id: head-movement
title: Head Movement
---

## Movement

OpenDBM focuses on computer vision-based measurements of movement. This refers to movement that can be detected in videos of individuals, focusing primarily on their head and face. Future versions of OpenDBM will hopefully include additional measurements as well.

## Head Movement

Head movement is measured in two ways. The first is a Euclidean measurement i.e. in the *   * plane. The position of the head in x, y, and z coordinates is calculated as a raw variable in each frame. These raw variables are then used to measure overall head movement in the *xyz* plane.

The second method to measure head movement is by measuring angular changes in radians. The position of the head’s pitch, roll, and yaw is calculated as a raw variable in each frame. These variables are then used to measure overall change in head pitch, yaw, and roll as derived variables.

Only image frames where the OpenFace confidence score is greater than 20% are used for all downstream calculations (OpenFace confidence scores were explained in Section 5.1)

### Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `mov_headvel`      | **Euclidean head movement.** Frame-wise Euclidean displacement of the head in the xyz plane. |
| `mov_hposepitch`      | **Head pitch angle.** Frame-wise pitch angle of the head.  |
| `mov_hposeyaw`      | **Head yaw angle.** Frame-wise yaw angle of the head.     |
| `mov_hposeroll`      | **Head roll angle.**  Frame-wise roll angle of the head.    |
| `mov_hposedist`      | **Angular head movement.**  Frame-wise change in head angle, combining pitch, yaw, and roll movements.     |

### Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `mov_headvel_mean`      | **Euclidean head movement mean.**  Mean of `mov_headvel` across the video in mm/frame.  |
| `mov_headvel_std`      | **Euclidean head movement standard deviation.**  Standard deviation of `mov_headvel` across the video.  |
| `mov_hposepitch_mean`      | **Head pitch movement mean.**  Mean of the pitch angle of the head across the video.  |
| `mov_hposepitch_std`      | **Head pitch movement standard deviation.** Standard deviation of the pitch angle of the head across the video i.e. amount of head movement in the pitch direction.   |
| `mov_hposeyaw_mean`      | **Head yaw movement mean.**  Mean of the yaw angle of the head across the video.  |
| `mov_hposeyaw_std`      | **Head yaw movement standard deviation.**  Standard deviation of the yaw angle of the head across the video i.e. amount of head movement in the yaw direction.  |
| `mov_hposeroll_mean`      | **Head roll movement mean.** Mean of the roll angle of the head across the video.  |
| `mov_hposeroll_std`      | **Head roll movement standard deviation.**  Standard deviation of the roll angle of the head across the video i.e. amount of head movement in the roll direction.  |
| `mov_hposedist_mean`      | **Angular head movement mean.**  Mean of `mov_hposedist` across the video.  |
| `mov_hposedist_std`      | **Angular head movement standard deviation.** Standard deviation of mov_hposedist across the video.   |

