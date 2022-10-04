---
id: opendbm-python-api-add-new-variable
title: OpenDBM API - Add New Variable
---

#### Prerequisites read
* [OpenDBM Python API](opendbm-python-api)
* [OpenDBM API - Unit Test](opendbm-python-api-unittest)

<figure>
  <img src="../img/extras/api-add-var-5.png" width="70%" alt="OpenDBM Folder" />
  <figcaption>Simple Architecure Diagram on How to Add New Module</figcaption>
</figure>

## Scenario
We want to add a pose detector in OpenDBM API. The model file that we will use to do the pose detector is 2 GB in size. Here is the steps on how to do it

### 1. Consider the category of pose detector

We have existing dbm group folders that consist of Facial, Movement, Speech, and Verbal Acoustics. 
Compared to other categories, it will make sense if the pose detector is added to the Movement group. So with that in mind, 
we will create the core module in the movement folder, to be precise, in  **“dbm_lib/dbm_features/raw_features/movement”**.

For the module name, there is no convention on how to create the module name. The only important thing is it needs to be explicit.
In this case, we will name our module **pose_detection.py**

### 2. Create the core module
In general, this module is where we use the model to generate the final output as a pandas dataframe object.

Specifically, The final function of the pose_detection module needs to have two capabilities:
1. Keyword argument for saving the output.
This is essential because you need the module to be used with the Docker command approach. To develop this, 
please use the save_output function from the util library so you don’t have to create the same function.
2. Should return the final output as pandas dataframe.


In code, the end of the final function should look like this.

<figure>
  <img src="../img/extras/api-add-var-1.png" width="100%" alt="OpenDBM Folder" />
  <figcaption>End Code of eye_blink Module in Movement dbm group</figcaption>
</figure>

### 3. Store the Model File

Now store your model file in the pkg/local folder, depending on the file size (see pkg folder explanation here). You 
also need to create a function where openDBM API can download the model file if the user doesn’t have it yet. 
The function must be made in the **util.py** module in the api_lib folder. 

### 4. Add pose_detection to Python API

Below are the steps to add your newly created pose_detection module to Python API that lives inside api_lib folder.

#### a. Create the private module.
Based on our scenario, we should create “_pose_detection.py” in the movement folder inside api_lib 

#### b. Create a class inside the private module
If we look at all the private modules, the code has the same pattern as others. So all we need to do is to modify it a little bit.

Below is the code inside “_eye_blink.py” inside the movement folder.

<figure>
  <img src="../img/extras/api-add-var-2.png" width="100%" alt="_eye_blink.py" />
  <figcaption>_eye_blink.py</figcaption>
</figure>

As a starter, we copy-paste all codes from “_eye_blink.py” to “_pose_detection.py”. Then in;
* Line 1: change DLIB_SHAPE_MODEL to POSE_DETECTION_MODEL. This object is a path to where the Pose detector model lives.
* Line 2: change the import module from eye_blink to pose_detection, and also change run_eye_blink to your final function name (ex: run_pose_detection)
* Line 5: Change the class name from EyeBlink to PoseDetection
* Line 8: create a list that contains the name of the numerical field of your processed dataframe.
* Line 11: change the _fit_transform method to return the result of your function, in this case, run_pose_detection(args1,args2, …)

The final codes in **_pose_detection.py** should be look like this, for example;
```python
from opendbm.api_lib.model import POSE_DETECTION_MODEL, VideoModel
from opendbm.dbm_lib.dbm_features.raw_features.movement.pose_detection import run_pose_detection


class PoseDetection(VideoModel):
    def __init__(self):
        super().__init__()
        self._params = ["mov_pose_head", "mov_pose_body", "mov_pose_hand", "mov_pose_foot"]

    def _fit_transform(self, path):
        return run_pose_detection(path, ".", self.r_config, POSE_DETECTION_MODEL, save=False)
```

#### c. Export the newly created module to api.py

Now we go and take a look at codes in module api.py. After that, all we have to do is add pose_detection with the following steps:

#### Import the private pose module 

Following the pattern, we just need to add **from ._pose_detection import PoseDetection**
```python
from ._eye_blink import EyeBlink
from ._eye_gaze import EyeGaze
from ._facial_tremor import FacialTremor
from ._head_movement import HeadMovement
from ._vocal_tremor import VocalTremor
from ._pose_detection import PoseDetection # <-- new code added for pose_detection
```

#### Initiate the model class
Following the pattern, create a new variable in a new line **self._pose_detection = PoseDetection()**

```python
class Movement(VideoModel):
    def __init__(self):
        super().__init__()
        self._eye_blink = EyeBlink()
        self._eye_gaze = EyeGaze()
        self._facial_tremor = FacialTremor()
        self._head_movement = HeadMovement()
        self._vocal_tremor = VocalTremor()
        self._pose_detection = PoseDetection() # <-- new code added for pose_detection
```
#### Add the new pose variable to models dictionary.


```python
self._models = OrderedDict(
            {
                "eye_blink": self._eye_blink,
                "eye_gaze": self._eye_gaze,
                "facial_tremor": self._facial_tremor,
                "head_movement": self._head_movement,
                "vocal_tremor": self._vocal_tremor,
                "pose_detection": self._pose_detection # <-- new code added for pose detection
            }
        )
```
#### Create a new method to get the result of pose_detection.
By following the function pattern in the code below, our function name will be **get_pose_detection**, which will return **self._pose_detection**

```python
    def get_vocal_tremor(self):
        """
        Get the model object of Vocal Tremor
        Returns:
        self: object
            Model Object
        """
        return self._vocal_tremor

### Below is the new code to get the result of pose_detection
    def get_pose_detection(self):
        """
        Get the model object of Pose Detection
        Returns:
        self: object
            Model Object
        """
        return self.pose_detection
```

That is how to add a new component to OpenDBM API. The only leftover is,

### 5. Add pose_detection to unit test (pytest).

Considering you have already read the Unit test design, you need to create a function to test your newly created API.

In our case, in “test_api_movement.py,” we will create a test function named “test_get_pose_detection,” and you should configure your unit testing there.