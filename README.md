<h1 align="center">
OpenDBM
</h1>

<div align="center">
  <img width="400" alt="GitHub Actions for deploying to GitHub Pages with Static Site Generators" src="https://raw.githubusercontent.com/AiCure/open_dbm/master/images/odbm.png">

[![PyPI Latest Release](https://img.shields.io/pypi/v/opendbm?style=plastic)](https://pypi.org/project/opendbm/)
[![Anaconda Latest Release](https://img.shields.io/badge/Anaconda.org-1.4.3-blue.svg?style=plastic)](https://anaconda.org/r/r-odbc)
[![PyPI - License](https://img.shields.io/pypi/l/odbm?style=plastic)](https://github.com/AiCure/open_dbm/blob/master/license.txt)
[![Test](https://raw.githubusercontent.com/AiCure/open_dbm/master/images/badges/test_status.svg)](https://github.com/AiCure/open_dbm/actions/workflows/open_dbm-code-checking.yml?query=branch%3Amaster++)
[![Coverage](https://raw.githubusercontent.com/AiCure/open_dbm/master/images/badges/code_coverage.svg)](https://github.com/AiCure/open_dbm/actions/workflows/open_dbm-code-checking.yml?query=branch%3Amaster++)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg?style=flat)](https://github.com/psf/black)
[![Imports: isort](https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336)](https://pycqa.github.io/isort/)
</div>

# Supported OS Platforms

OS                    | Build Status
----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Linux**                 | [![Build](https://raw.githubusercontent.com/AiCure/open_dbm/master/images/badges/linux_status.svg)](https://github.com/AiCure/open_dbm/actions/workflows/open_dbm-build-checking.yml)
**Windows**                 | [![Build](https://raw.githubusercontent.com/AiCure/open_dbm/master/images/badges/windows_status.svg)](https://github.com/AiCure/open_dbm/actions/workflows/open_dbm-build-checking.yml)
**macOS-Intel**                 | [![Build](https://raw.githubusercontent.com/AiCure/open_dbm/master/images/badges/macos_status.svg)](https://github.com/AiCure/open_dbm/actions/workflows/open_dbm-build-checking.yml)


# What is it
OpenDBM is a software package that allows for calculation of digital 
biomarkers of health and functioning from video or audio of an individual’s 
behavior. It integrates existing tools for behavioral measurements such as
facial activity, voice, speech, and movement into a single package for measurement 
of overall behavior.  Checkout the OpenDBM [**digital biomarker variables**](https://aicure.github.io/open_dbm/docs/biomaker-variables).

# More About OpenDBM

At a modular level, OpenDBM is a library that consists of the following components:

| Component | Description |
| ---- | --- |
| [**Facial**](https://aicure.github.io/open_dbm/api/facial-activity-api) | An OpenDBM module to get facial attributes |
| [**Movement**](https://aicure.github.io/open_dbm/api/movement-api) | An OpenDBM module to get movement attributes |
| [**Verbal Acoustic**](https://aicure.github.io/open_dbm/api/verbal-acoustics-api) | An OpenDBM module to get verbal acoustic attributes  |
| [**Speech & Language**](https://aicure.github.io/open_dbm/api/speech-api) | An OpenDBM module to get speech & language attributes |

Usually, OpenDBM is used for:

- A digital biomaker extraction app
- A helper tools to give insight of patient condition

# Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [⭐️ Installation](#%EF%B8%8F-installation)
  - [Prerequisites](#prerequisites)
    - [Install Dependencies](#install-dependencies)
  - [OpenDBM Installation](#opendbm-installation)
- [⭐️ Usage](#%EF%B8%8F-usage)
  - [Basic Usage](#basic-usage)
    - [*Try your first OpenDBM program*](#try-your-first-opendbm-program)
- [⭐️ More resources](#%EF%B8%8F-more-resources)
- [⭐️ License](#%EF%B8%8F-license)
- [⭐️ People](#%EF%B8%8F-people)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# ⭐️ Installation

## Prerequisites (Install Dependencies)
### With Conda Environment (recommended)
**Make sure to install conda first at** [anaconda](https://www.anaconda.com/)

**On Linux/macOS**
```bash
conda install -c conda-forge cmake ffmpeg sox
```
**On Windows**
```bash
#Make sure to run in Anaconda Prompt, or add conda to the path.
conda install -c conda-forge ffmpeg sox dlib
```
### Without Conda Environment
[Installation instructions](https://aicure.github.io/open_dbm/docs/dependencies-installation)
## OpenDBM Installation
```bash
pip install opendbm 
```

## Model Download ( Facial and Movement Components)
Make sure you have installed docker and already login to Docker Hub. 

If you haven't, Find the tutorial [here](https://aicure.github.io/open_dbm/docs/openface-docker-installation)
```bash
docker pull opendbmteam/dbm-openface
```

<div align="right">
<a href="#table-of-contents">Back to TOC ☝️</a>
</div>

# ⭐️ Usage
## Basic Usage
### *Try your first OpenDBM program*
```python
from opendbm import FacialActivity

#make sure Docker is active to access the model
model = FacialActivity()
path = "sample.mp4"
model.fit(path)
landmark = model.get_landmark()
```

To get the attribute like mean and std is as straighforward as `.mean()`:

```python
landmark.mean()
landmark.std()
landmark.to_dataframe() # convert results as pandas dataframe
```


For more in-depth tutorials about OpenDBM, you can check out:

-   [Introduction to OpenDBM](https://aicure.github.io/open_dbm/docs/getting-started)
-   [Digital Biomarker Variables](https://aicure.github.io/open_dbm/docs/biomaker-variables)
-   [API Documentation](https://aicure.github.io/open_dbm/api/api-doc)
-   [Contribution Guide](https://aicure.github.io/open_dbm/extras/extras)

<div align="right">
<a href="#table-of-contents">Back to TOC ☝️</a>
</div>

# ⭐️ More resources
-   [OpenDBM Github Pages]([https://github.com/AiCure/open_dbm/wiki](https://aicure.github.io/open_dbm/))
-   [OpenDBM 2.0 Documentation](https://docs.google.com/document/d/1zek5fBvOZ_OwPYpsD6pso4u1N4K-ZuTO7j9ycHJSB-s/edit?usp=sharing)
-   [AiCure page](https://aicure.com/opendbm/)

<div align="right">
<a href="#table-of-contents">Back to TOC ☝️</a>
</div>

# ⭐️ License
OpenDBM is published under the GNU AGPL 3.0 license.


# ⭐️ People
OpenDBM is maintained by the Clinical Data Science Team (including Andre Paredes, Director of OpenDBM) at AiCure. Current development and maintenance build on the efforts of Anzar Abbas and Vijay Yadav, alongside Vidya Koesmahargyo and Isaac Galatzer-Levy.  OpenDBM was made open source in October 2020. Email the community at opendbm@aicure.com.

<div align="right">
<a href="#table-of-contents">Back to TOC ☝️</a>
</div>




