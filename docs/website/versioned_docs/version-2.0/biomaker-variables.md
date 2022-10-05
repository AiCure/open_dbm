---
id: biomaker-variables
title: Biomaker Variables
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

## Biomaker Variables

This chapter outlines the entire list of biomarkers that OpenDBM v2.0 calculates.

For each biomarker, both raw variables and derived variables are calculated. Raw variables are often frame-wise values containing measurements according to the temporal resolution of the inputted file (e.g. happiness expressivity in each frame of video in an inputted video file or audio intensity for each audio frame in an audio file). Derived variables are abstractions of their respective raw variables (e.g. average happiness expressivity across a video or standard deviation of audio intensity over the course of the audio file). 

It is helpful to think of raw variables as quantifications of behavioral characteristics, with derived variables being the ones acting as biomarkers of health and functioning. OpenDBM outputs both raw and derived variables when it is executed. However, it is possible that the user will only need to utilize the derived variable output for their research––unless they are interested in delving deeper into the data and making their own derived variable abstractions.

All variables are named according to a standard nomenclature. Raw variable names contain two sections, while derived variable names contain three sections. The figure below demonstrates what each section of the variable name, separated by underscores, refers to.

<figure>
  <img src="/docs/assets/biomaker-variables-1.png" width="1000" alt="Description of the standard nomenclature used to name all raw and derived variable outputs from OpenDBM, allowing for determination of variable contents without having to memorize all variable names." />
  <figcaption>Description of the standard nomenclature used to name all raw and derived variable outputs from OpenDBM, allowing for determination of variable contents without having to memorize all variable names.</figcaption>
</figure>