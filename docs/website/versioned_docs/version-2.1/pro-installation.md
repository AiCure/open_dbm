---
id: pro-installation
title: Installation for Pro
description: Pro Installation
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';
import ThemedImage from '@theme/ThemedImage';

**NOTE for Windows User**: Please use the instruction [here](openface-docker-installation#if-you-havent-heres-the-instruction-on-how-to-install-docker) to install docker and/or enable WSL 2 as Docker Integration

Clone OpenDBM onto your system. Make sure you have docker installed and running. From the repo, run  
```bash
docker build --tag dbm . 
```
to install the docker image. Then, you’re good to go.

---

Now that you’ve covered OpenDBM installation, let’s dive deeper on some of these core modules by looking at [Usage](opendbm-docker-usage).