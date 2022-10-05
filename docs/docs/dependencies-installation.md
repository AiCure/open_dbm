---
id: dependencies-installation
title: Dependencies Installation
description: 'OpenDBM needs you to install some dependencies before do any pip install'
hide_table_of_contents: true
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

This page will help you install the prerequisites for each OS platforms.

**If you are new to python environment**, the easiest way to get started is with Conda CLI. Conda is an open source package management system and environment management system that runs on Windows, macOS, Linux and z/OS. Conda quickly installs, runs and updates packages and their dependencies. Conda easily creates, saves, loads and switches between environments on your local computer. It was created for Python programs, but it can package and distribute software for any language.

**If you are already familiar with python environment**, you may to proceed install the dependencies using your <code>python</code> environment

<Tabs groupId="guide" defaultValue={constants.defaultGuide} values={constants.guides}>
<TabItem value="dep-install">

The instructions are a bit different depending on your development operating system.

#### Development OS

<Tabs groupId="os" defaultValue={constants.defaultOs} values={constants.oses} className="pill-tabs">
<TabItem value="macos">

## Install with conda 

```bash
conda install -c conda-forge cmake ffmpeg sox
```
## Standalone installation (without conda)

```bash
brew install cmake
brew install sox
brew install ffmpeg
```

</TabItem>
<TabItem value="windows">

## Install with conda 

```bash
conda install -c conda-forge ffmpeg sox dlib
```
## Standalone installation (without conda)

> [Install sox guide](https://www.tutorialexample.com/a-step-guide-to-install-sox-sound-exchange-on-windows-10-python-tutorial/)

> Follow either of this guide to install ffmpeg
> * [geeksforgeeks](https://www.geeksforgeeks.org/how-to-install-ffmpeg-on-windows/)
> * [wikihow](https://www.wikihow.com/Install-FFmpeg-on-Windows)

> [Install dlib guide](https://github.com/sachadee/Dlib)


</TabItem>
<TabItem value="linux">

## Install with conda 

```bash
conda install -c conda-forge cmake ffmpeg sox
```
## Standalone installation (without conda)

```bash
sudo apt-get install cmake
sudo apt-get install libsndfile1
sudo apt-get install ffmpeg
sudo apt-get install sox
```



</TabItem>
</Tabs>

</TabItem>
</Tabs>



