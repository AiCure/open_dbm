---
id: openface-docker-installation
title: OpenFace Installation
description: 'OpenDBM needs you to install OpenFace Model before running OpenDBM Facial and Movement components'
hide_table_of_contents: true
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

This page will help you install OpenFace model that is stored as Docker Image, starting from on how to install the docker.


<Tabs groupId="guide" defaultValue={constants.defaultGuideDocker} values={constants.guidesDocker}>
<TabItem value={constants.defaultGuideDocker}>

## If you have installed Docker 

**NOTE**: Make sure to sign in first so you can download the docker image

<figure>
  <img src="../docs/assets/docker-signin.png" width="30%" alt="OpenDBM Folder" />

</figure>

And then execute this command to download OpenFace model
```bash
docker pull opendbmteam/dbm-openface
```
Done!
## If you haven't, here's the instruction on how to install Docker


The instructions are a bit different depending on your development operating system.

#### Development OS

<Tabs groupId="os" defaultValue={constants.defaultOs} values={constants.oses} className="pill-tabs">
<TabItem value="macos">

Follow the instruction in the [official website](https://docs.docker.com/desktop/install/mac-install/)

</TabItem>
<TabItem value="linux">

Follow the instruction in the [official website](https://docs.docker.com/desktop/install/linux-install/)


</TabItem>
<TabItem value="windows">

1. Follow the instruction in the [official website](https://docs.docker.com/desktop/install/windows-install/)

    **IMPORTANT NOTE**: 
   * Please follow the instructions to install **WSL-2** as system requirements instead of Hyper-V. Because we relying on WSL command to execute OpenFace Model.
   * After you installed WSL in [Linux kernel update package](https://docs.microsoft.com/en-us/windows/wsl/install):
     * Make sure to execute "wsl --set-default-version 2"
     * Make sure to choose Ubuntu as Linux distribution of choice
       * **wsl -l -o** to list distribution
       * **wsl --install -d Ubuntu-18.04** to install Ubuntu Distribution

<figure>
  <img src="../docs/assets/ubuntu-wsl.png" width="70%" alt="OpenDBM Folder" />
  <figcaption>Example on how to List Distribution and Install Ubuntu</figcaption>
</figure>

2. After WSL and Docker is installed. check if Docker use WSL Integration by go to the Settings > Resources > WSL Integrations, and then enable Ubuntu as our Linux Distribution.
<figure>
  <img src="../docs/assets/ubuntu-enable-docker.png" width="100%" alt="OpenDBM Folder" />
  <figcaption>WSL Integration in Docker Setting</figcaption>
</figure>



3. Make sure check and set wsl distributions to Linux distributions of your choice. In powershell/command prompt:
    * Type **wsl --list** to check WSL distributions list
    * **wsl --setdefault {Distribution Name}** to set the default distribution **(Use Ubuntu)**
    * **wsl --list** again to check if wsl default is set
   
<figure>
  <img src="../docs/assets/ubuntu-set-dist.png" width="100%" alt="OpenDBM Folder" />
  <figcaption>Set Default WSL</figcaption>
</figure>


4. And it's done! Now you can go to the next step by pulling the docker image from the step [above](#top)



</TabItem>
</Tabs>

</TabItem>
</Tabs>



