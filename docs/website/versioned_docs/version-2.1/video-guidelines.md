---
id: video-guidelines
title: Video Guidelines
---

Generally speaking––and forgive me if this is too obvious––OpenDBM is meant to calculate behavioral characteristics and subsequently derive digital biomarkers from video of an individual’s head/face area and there is a basic expectation that the video will be of that individual (e.g. patient during a clinical interview) facing generally towards the direction of the camera lens. Some key points to consider regarding video that is processed are detailed below.

## Direction of head

If for some frames of the video, the head is not pointing towards the camera, it is possible that no visual biomarker variables will be processed for those frames. Hence, it is recommended that most if not all of the video be of the face pointing towards the camera. To find out which frames in a video were or were not processed, go through the raw variable output and locate any **nan** entries: those are likely because there was no face detected in those frames (there’s more on this in Section 5.1).

## Persons per video

Each video should be unique to one person. If more than one person is present in any given frame of video, the package will get confused and only make measurements on one of the heads/faces, with no real way to determine which one of the individuals is being used to make the measurements. Furthermore, even if one head is shown at a time but the same video contains more than one unique person, then the derived variable measurements will be disrupted in that they will be averaged for all faces shown, instead of limiting calculations to a unique face.

In many cases, the user may be processing videos of a clinician-patient interview and that video either contains shots of both the interviewer and the patient’s face (such as [this one](https://youtu.be/7_gmIvbjt3w?t=138)). The user must spatially crop the video to ensure that only the face of the individual whose behavior the user is interested in measuring (I’m assuming it’s the patient) is in the video––not the interviewer. In other cases, the video may cycle between the patient and interviewer (such as [this one](https://www.youtube.com/watch?v=4YhpWZCdiZc&t=302s)). Here, the user must temporally crop the video so that only shots that contain the patient’s face are processed, and not the ones of the interviewer’s face. It can also be the case that a caretaker or guardian is sitting next to the patient during the interview (such as [this one](https://youtu.be/I7QiPXqL9pY?t=117)). Here, too, the user must spatially crop the video to only include the face of the individual whose behavior they want to measure.

## Video data quality

Please be cognizant of data quality. This includes ensuring that the face is close enough to the camera that individual features are distinguishable, that lighting is consistent across the face e.g. there are no strong shadows, etc. that are going across the face, which could affect the calculations. It is also important that the entirety of the face is in the frame, which can sometimes be an issue if the face is too close to the camera e.g. if the individual is recording on a smartphone front-facing camera and brings it close to their face to speak.
