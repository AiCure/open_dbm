---
id: getting-started
title: Introduction
description: This helpful guide lays out the prerequisites for learning OpenDBM, using these docs, and setting up your environment.
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

<div className="content-banner">
  <p>
    Welcome to the very start of your OpenDBM journey! If you're looking for straight install and usage instructions, you can move to <a href="dependencies-installation">this section</a>. Continue reading for an introduction of OpenDBM before installing.
  </p>
  <img className="content-banner-img" src="/docs/assets/aicure_white.png" alt=" " />
</div>

OpenDBM is an open-source tool for measurement of digital biomarkers from video and audio of patient behavior. It is built on existing software packages used to quantify behavioral characteristics. Our goal is to increase accessibility of methods in digital phenotyping to researchers trying to understand the relationship between neuropsychiatric illnesses and their behavioral manifestations. 

Through OpenDBM, a user can objectively and sensitively measure behavioral characteristics such as facial activity, vocal acoustics, characteristics of speech, patterns of movement, and oculomotion. From those behavioral characteristics, they can measure clinically meaningful symptomatology such as emotional expressivity, prosody of voice, valence of speech, and severity of tremor––among many others. 

We hope to encourage researchers to use objective quantification of symptomatology in their analyses and to inspire them to contribute their own code, leading to a central repository of methods. Only by doing so can academia, healthcare, and industry collaborate effectively on the advancement of digital measurement of health and create access to novel tools in digital phenotyping.


## How to use these docs

The purpose of this document is to fully detail the specifications of OpenDBM. 

- Chapter 2 describes how to install and set up OpenDBM on your system.
- Chapter 3 outlines how to use OpenDBM to calculate digital biomarkers from data.
- Chapter 4 provides information on how the data output is organized and analyzed.
- Chapter 5 lists and describes all digital biomarker variables outputted by OpenDBM.
- Chapter 6 details considerations to have in mind for any data that is being processed.
- Chapter 7 contains additional resources for the user and links to instructional videos.

## Prerequisites

To work with OpenDBM, you will need to have an understanding of Python fundamentals. If you’re new to Python or need a refresher, you can [dive in](https://docs.python.org/3/tutorial/) or [brush up](https://www.w3schools.com/python/) at your convenience.

> While we do our best to assume no prior knowledge of Python, these are valuable topics of study for the aspiring OpenDBM users. Where sensible, we have linked to resources and articles that go more in depth.

## Developer Notes

People from many different development backgrounds are learning OpenDBM. You may have different experience between researchers, data scientist and python engineer and more. We try to write for all enthutiast from all backgrounds. Sometimes we provide explanations specific to one platform or another like so:

<Tabs groupId="guide" defaultValue="researchers" values={constants.getLibraryNotesTabs(["researchers","data_scientist","engineer"])}>

<TabItem value="researchers">

> Clinical Researchers may be familiar with this concept.

</TabItem>
<TabItem value="data_scientist">

> Data scientist may be familiar with this concept.

</TabItem>
<TabItem value="engineer">

> Python developers may be familiar with this concept.

</TabItem>
</Tabs>

---

Now that you know how this guide works, it's time to get to start OpenDBM installation: [Dependencies Installation](dependencies-installation.md).
