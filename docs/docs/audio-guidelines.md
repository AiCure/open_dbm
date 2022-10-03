---
id: audio-guidelines
title: Audio Guidelines
---

Similar to video, the assumption here is that it is the voice and speech of a patient that is being characterized. OpenDBM calculates acoustic measures from the sound wave that it is getting. So, if there is any sound in the audio file that is not the patient’s voice, OpenDBM does not separate that out, and any subsequent measurements (think: the loudness of the sound, frequency of the waveform, and other acoustic features like the harmonics to noise ratio) will be from of all the sound in the audio file––and not just the patient’s voice. Similarly, if our objective is to characterize aspects of the speech, OpenDBM is transcribing all the speech that it can hear. So, if more than one person is speaking in the audio file, you’re calculating variables from all of that speech––not just the patient’s. Below are some points to take into consideration.

## Empty/quiet spaces 

If there is empty space at the beginning and end of an audio file, it is advised that the file is cropped at the head and the tail to ensure that the empty space does not contribute to downstream calculations. However, this does not mean that all empty space during speech should be cropped out considering those pauses in speech may actually be biomarkers of health and functioning. However, if the user's audio file contains separate sections of speech, then it is recommended that the file is trimmed accordingly.

## Background noise

Given the package will process variables from any audio that is inputted, that includes any background noise that may be part of the file. Background noise will lead to a lower signal-to-noise ratio for all audio marker calculations and should be minimized whenever possible. If an audio file has sustained background noise (e.g. a fan, a murmur in a room), it will affect the accuracy of the calculations. Future versions of this package may conduct additional steps to remove background noise but for now, the user must be cognizant of how other sounds in the audio file may be impacting the measurements.

## Video data quality

Please be cognizant of data quality. This includes ensuring that the face is close enough to the camera that individual features are distinguishable, that lighting is consistent across the face e.g. there are no strong shadows, etc. that are going across the face, which could affect the calculations. It is also important that the entirety of the face is in the frame, which can sometimes be an issue if the face is too close to the camera e.g. if the individual is recording on a smartphone front-facing camera and brings it close to their face to speak.

## Persons per audio

Similar to Section 6.2.2, OpenDBM’s assumption is that only one person is represented in the audio. Hence, if the audio contains the voice and/or speech of persons other than the individual whose behavior the user is trying to measure, then it is the user’s responsibility to crop out those parts of the audio. In such cases, the user can crop out all relevant sections, save them separately, and process them separately as individual files––or they can concatenate them after cropping and process them as one file. In either case, the final measurements are not affected, so we suggest doing whatever is more convenient and requires less manual work.
