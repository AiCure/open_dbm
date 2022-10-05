---
id: sentiment-of-speech
title: Sentiment of Speech
---

This refers to the emotional valence of the transcribed text based. This determination is based on pre-trained models found in the [vaderSentiment](https://pypi.org/project/vaderSentiment/    ) library. Positive values of sentiment indicate positive emotional valence, while negative values indicate negative emotional valence.

## Derived Variables

| Variable      | Description |
| ----------- | ----------- |
| `nlp_sentiment_mean_mean`      | **Sentiment of speech**, ranging from -1 to 1, with -1 indicative negatively valenced speech and +1 indicative positively valenced speech.    |
