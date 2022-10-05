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
<p> Install sox </p>

```shell
brew install sox
```

</TabItem>
<TabItem value="windows">

## Standalone installation

> [Follow this guide to install sox in windows.](https://www.tutorialexample.com/a-step-guide-to-install-sox-sound-exchange-on-windows-10-python-tutorial/)

</TabItem>
<TabItem value="linux">

<p> Install sox </p>

```shell
sudo apt-get install sox
```

<p> Install libsndfile1 </p>

```shell
sudo apt-get install libsndfile1
```

</TabItem>
</Tabs>

</TabItem>
</Tabs>
