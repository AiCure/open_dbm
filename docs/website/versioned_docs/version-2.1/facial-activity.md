---
id: facial-activity
title: Facial Activity
---

Facial activity biomarkers relate to visually observable characteristics of the face i.e. movements and arrangements of facial musculature that can––for example––comprise emotional expressions. All facial features are acquired through use of the [OpenFace software library](https://cmusatyalab.github.io/openface/). 

Along with everything else, OpenFace outputs ‘confidence scores’ that delineate how confident it is that it is indeed seeing a face in an image from a video. If the confidence score for an image frame is below 80%, we do not process any facial activity variables for those frames and the framewise raw variable output does not contain values. All derived facial variables that are then calculated from the raw variables only reflect image frames where the confidence was >80%. 
