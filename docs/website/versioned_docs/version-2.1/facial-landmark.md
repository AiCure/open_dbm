---
id: facial-landmark
title: Facial Landmark
---

Facial landmarks refer to specific regions of the face, with x, y, and z coordinates for each facial landmark variable indicating where in the image frame that specific region of the face is located. 

<figure>
  <img src="../docs/assets/facial-landmark-1.png" width="500" alt="Visual representation of the facial landmarks calculated by OpenDBM, which relies on OpenFace and OpenCV for its measurements." />
  <figcaption>Visual representation of the facial landmarks calculated by OpenDBM, which relies on OpenFace and OpenCV for its measurements.</figcaption>
</figure>

OpenDBM calculates overall change in facial landmark positioning and in doing so measures facial musculature movements at the level of individual facial landmarks. Individual movement of a total of 68 facial landmarks is measured using the raw and derived variables listed in the tables below.


## Raw Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_lmkXXdisp`      | **Landmark displacement.** Frame-wise change in landmark positioning i.e. the euclidean distance in the xyz plane, where XX can be any number between 01 and 68, referring to all individual facial landmarks.       |

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `fac_lmkXXdisp_mean`      | **Landmark displacement mean.** The mean value of fac_lmkXXdisp for the inputted video.       |
| `fac_lmkXXdisp_std`      | **Landmark displacement standard deviation.** The standard deviation value of fac_lmkXXdisp for the inputted video.       |