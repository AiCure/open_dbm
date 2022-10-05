---
id: verbal-acoustic
title: Verbal Acoustic
---

Verbal acoustics refer to measurements of the acoustic properties of an individual’s voice. 

It is important to note that OpenDBM does not yet filter out noise from voice. Hence, verbal acoustic variables are measurements of all audio that is inputted. Hence, inputted audio files must not have too much noise in order to obtain a high signal-to-noise ratio in the measurements.

All verbal acoustic variables outlined here are acquired through use of Parselmouth[^1], which is a python implementation of the Praat software library[^2], a commonly used software tool for quantification of verbal acoustics. Raw variables are calculated for each audio frame (with exception of pause characteristics and voice prevalence) and derived variables abstract those measurements at the level of the audio file.

[^1]: https://pypi.org/project/praat-parselmouth/
[^2]: http://www.fon.hum.uva.nl/praat/

