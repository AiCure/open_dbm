---
id: rate-of-speech
title: Rate of Speech
---

Rate of speech is simply a measure of words spoken per given unit of time. We measure this in words spoken per minute. However, for convenience, we are also outputting as a variable simply the length of the file that was analyzed and hence multiplying `nlp_wordsPerMin_mean` by `nlp_totalTime_mean` will give the total number of words spoken. 

> Please note that the latter measurement is in seconds, so one would have to divide it by 60 first :)

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `nlp_wordsPerMin_mean`      | **Rate of speech**, in average number of words spoken per minute.    |
| `nlp_totalTime_mean`      | **Total time in seconds**, of the video or audio file from which the rate of speech measurement was acquired.    |
