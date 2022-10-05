---
id: speech
title: Speech
---

The previous section focused on acoustic properties of speech. This section measures characteristics of language. First, any speech detected in the audio file is transcribed into text using [DeepSpeech](https://github.com/mozilla/DeepSpeech), an open-source speech transcription tool. From the transcribed text, a number of open source natural language processing tools are used to derive characteristics of speech.

Speech biomarkers are slightly different from the other categories of digital biomarkers as the ‘raw variables’ are really just the transcribed speech (on how to acquire the transcribed speech, see Section 3.1.4). For reasons that are unimportant, we do still calculate raw variables and derived variables separately here, but there is absolutely no difference between the raw and derived variables. Hence, we recommend conducting any analysis on speech data simply from the derived variables, listed below.