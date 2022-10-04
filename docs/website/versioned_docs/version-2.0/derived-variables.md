---
id: opendbm-docker-output
title: Derived Variables
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

## OpenDBM Output

In the previous chapter, we went over how to process data using OpenDBM and learned that when we do so, we save a folder called **output** in the location we specify. This chapter is all about what’s in that folder and all the wonderful things we can do with it. 

The first thing you’ll see is that the **output** folder is divided into `raw_variables` and `derived_variables`. As Chapter 5 explains, for each biomarker, both **raw variables** and **derived variables** are calculated. Raw variables are often frame-wise values containing measurements according to the temporal resolution of the inputted file (e.g. happiness expressivity in each frame of video in an inputted video file or audio intensity for each audio frame in an audio file). Derived variables are abstractions of their respective raw variables (e.g. average happiness expressivity across a video or standard deviation of audio intensity over the course of the audio file). Chapter 5  goes into more detail and lists all raw and derived biomarker variables. The purpose of this chapter is to first just explain the structure of the data output from OpenDBM.

## Derived Variables

For derived variables, a single CSV file is outputted. This CSV file, named derived_output.csv, contains a row for each video/audio file that was inputted. If only a single file was processed, the CSV file will have only one row. If several were inputted, then several rows will be outputted.

And, in case you forgot what files and/or excel sheets look like, here are some illustrations:
<figure>
  <img src="/docs/assets/derived_var_1.png" width="1000" alt="Screenshot of output file" />
  <figcaption>Screenshot of output file.</figcaption>
</figure>

Essentially, the derived variables CSV file is the best place to go for most simple analyses. [In this instructional video](https://www.youtube.com/watch?v=QQY_QA1Y5BM), we conduct a sample data analysis in a made-up experiment and use the derived variable output to test effects of a ‘treatment’ on emotional expressivity in the face.