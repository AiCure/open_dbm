---
id: windows-usage
title: Docker Windows Usage
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem';

## Windows

Here, we will walk you through how to use the pipeline on Windows. Unfortunately, this process is a little more involved than on Mac/Linux.

### Starting the container

After a successful build (see Section 2), running the following command should show you something like this:
```bash
> docker images
REPOSITORY   TAG       IMAGE ID       CREATED           SIZE
dbm          latest    91e593533c96   26 minutes ago    4.98GB
python       3.6       25bb503fe8c4   5 days ago        874MB
ubuntu       18.04     6526a1858e5d   3 weeks ago       64.2MB
```
The images have been created but there is still no container. Note the value under IMAGE ID for the **dbm** REPOSITORY and enter it in the command below:

```bash
> docker run -it <IMAGE ID for dbm REPOSITORY> /bin/bash
```
Once you create a new container from this image and execute the container, you can exit anytime by running:
```bash
root@<CONTAINER ID>:/app# exit
```
If the previous steps were done correctly, you should be able to see your container when running the following command:
```bash
> docker ps -a
CONTAINER ID    IMAGE          COMMAND       CREATED          STATUS     
7557af03538d    91e593533c96   "/bin/bash"   27 seconds ago   Exited (0)
```
You can now start the container by using the CONTAINER ID above.
```bash
> docker start <CONTAINER ID>
```
Next, you will need to enter the container to execute the pipeline. Remember you can exit the container by typing **exit**
```bash
> docker exec -it <CONTAINER ID> bash
```

### Running the main processing script

You are now ready to start processing data. Let’s test if we are set up properly by processing the sample data included in the Github repository. In this example, we will process files in the folder **sample_data**, and return the output to a folder on Desktop.

First you need to **move** the directory containing the data you want to process into the docker container in order to execute the pipeline. You can do this using:
```bash
> docker cp .../sample_data <CONTAINER ID>:/app/
```
Verify the location of the **sample_data** directory and its contents in the docker container:
```bash
> docker exec -it <CONTAINER ID> bash
root@<CONTAINER ID>:/app# cd sample_data
root@<CONTAINER ID>:/app/sample_data# ls
subj01_timepoint01.mp4
subj01_timepoint02.mp4
subj02_timepoint01.mp4
subj02_timepoint02.mp4
root@<CONTAINER ID>:/app/sample_data# cd ..
root@<CONTAINER ID>:/app#
```
This should put you back into the container root directory. This location contains the file  
**process_data.py**, and calling this script will process video and audio data using the given parameters.

In this example, calling the main processing script **process_data.py** will look like this:
```bash
root@<CONTAINER ID>:/app# python3 process_data.py 
--input_path sample_data/ 
--output_path sample_output/
--dbm_group facial acoustic movement speech 
--tr on
```
The parameters that need to be specified when calling the script are described below.

### Input path

The location of the files you want to process. If this path leads to a folder, all (supported) files will be processed, but it is also possible to have the path lead to a single file. The supported file formats are currently MP3 and WAV for audio files, and MP4 and MOV for video files. 
> **Note:** this path needs to be inside your docker container.

### Output path

The location of the folder where the processed data will be saved. If the folder does not already exist, the path will be generated with the output files saved within it. Similar to the input path, the output path will need to be located **inside** the docker container. Only after successfully running the processing script will you be able to move the output folder out of the container and into your system.

### DBM Group

The biomarker groups you want to calculate, including:

- **Facial, ** referring to measurements of facial behavior
- **Acoustic** , referring to measurements of vocal acoustics 
- **Speech, ** referring to measurement of language characteristics
- **Movement** , referring to motor and oculomotor functioning

For a list of all biomarkers within each group, see Section 5. If no group is passed, all possible biomarker groups will be calculated.

### Transcription

If the data passed contains speech, OpenDBM will transcribe and produce speech variables. ***However, the transcription itself will not be saved by default.*** If you are processing sensitive patient data, you should know that transcribed speech is still considered PHI. In case you are *sure* you’d like to save a copy of the speech transcription, you can turn this toggle **on**.

### Retrieving the output

If you navigate to the output path within the docker container you should see the output folder you passed earlier containing both a raw and derived output directory. 
```bash
root@<CONTAINER ID>:/app# cd sample_output/
root@<CONTAINER ID>:/app/sample_output# ls
root@<CONTAINER ID>:/app/sample_output#
raw_variables/ derived_variables/
```
You won’t be able to see these files in your system as long as they are in the container, so you need to run the following command to copy them back into your system.
```bash
root@<CONTAINER ID>:/app# exit
> docker cp <CONTAINER ID>:/app/sample_output Desktop/sample_data
```
Your processed files will be located in the path Desktop/sample_data/sample_output. You’re all set with using OpenDBM! In the next section, we will go over how the outputs are structured. 