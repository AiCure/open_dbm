---
id: opendbm-python-api
title: OpenDBM Python API
---



When we use OpenDBM python API, all the source codes come from the opendbm folder in our GitHub repo. opendbm folder is the main 
package we use to process input data. opendbm has four folders that consist of api_lib, dbm_lib, pkg, and resources.

To make it clear in the beginning, you will know that our structure in our repo reflects what is already documented in <a href="../docs/biomaker-variables">Variables</a> Section.

<figure>
  <img src="../img/extras/api-docs-1.png" width="100%" alt="OpenDBM Folder" />
  <figcaption>OpenDBM Folder</figcaption>
</figure>


### 1. dbm_lib
<figure>
  <img src="../img/extras/api-docs-2.png" width="100%" alt="dbm_lib Folder" />
  <figcaption>dbm_lib folder @ dbm_lib/dbm_features/raw_features</figcaption>
</figure>


When we mention dbm_lib for python API documentation, we refer to the folder “dbm_lib/dbm_features/raw_features.” 
dbm_lib is where all core modules are implemented. All the processing components must be stored here because this 
folder is where we can use the components either with the Docker command or Python API


Each children's folder (audio, movement, nlp, and video) represents the dbm group. In every children folder, 
there will be modules where we perform the processing/inferring of our input data. 
For example, below are the modules that live inside the movement folder.


<figure>
  <img src="../img/extras/api-docs-3.png" width="100%" alt="movement Folder in dbm_lib" />
  <figcaption>movement Folder in dbm_lib</figcaption>
</figure>

The goal of each module here is to perform one task/processing. For instance, facial_tremor.py 
will have a functionality to detect the facial tremor of the input data. If we want to add another functionality 
in openDBM, for example, motion detection, we should create a new module in this folder (assumed motion detection 
is part of movement dbm_group).

The design we explained for the movement package also applied to other dbm groups such as video, nlp, and audio.

Lastly, in the same level of the dbm group folder, there is the util folder, which contains all utility functions used 
by all modules that need it. If we want to create/modify the modules in dbm_lib, please check all the utility 
functions first so we don't need to reinvent the wheel.


### 2. api_lib
<figure>
  <img src="../img/extras/api-docs-4.png" width="100%" alt="api_lib Folder" />
  <figcaption>api_lib Folder</figcaption>
</figure>

api_lib is a  supporting package created so that we can use openDBM core modules with the python API call. 
Looking in the api_lib folder, we can see four folders (facial_activity, movement, speech, verbal_acoustics), 
which represent the dbm group, the same as we saw in the dmb_lib folder. In the same level of the dbm group folder, 
there are also two modules that have functionality as follows:

#### a. model.py

This module has the functionality to create the base model object that can be used after we execute the fit method 
in our Python API. This module also has a class to perform a processing/fit method in a dbm_group level.

#### b. util.py

This module is where all the utility functions are stored, related to the api_lib folder.


<figure>
  <img src="../img/extras/api-docs-5.png" width="100%" alt="movement Folder in api_lib" />
  <figcaption>movement Folder in api_lib</figcaption>
</figure>


All the dbm group folders inside api\_lib consistently have the same design as other folders. 
If we look in the movement folder, we can see all the private modules (with the prefix “\_”) that have 
the same name/structure as the one in the dbm_lib folder.

All these private modules will execute the same as their respective modules in the dbm_lib folder. For example, module “_vocal_tremor.py” will execute processing “vocal_tremor.py”. The difference is that in these private modules, we assign the function to the class that will be used for our python API.

The “api.py” module is a module where we implement the python API call tailored to each of the dbm_group. 




### 3. pkg


is where the model files are stored. In most of our processing/inferring, we get the weight from this pkg folder.

<b>Note for the developer</b>; if you want to make the user download a new model file, you can direct the download path to the pkg folder. But if the model file is big (ex: 2GB), please consider directing the download path to their local path. The reason is users might try to use OpenDBM in many virtual environments. Their memory storage will be exhausted if we store large model files in the pkg folder in many virtual environments.


### 4. resources

This folder is created initially as a configuration to rename, clean, and structure OpenFace output. To make it consistent, if we need to add other configurations for processing a new model, please create it in this folder.