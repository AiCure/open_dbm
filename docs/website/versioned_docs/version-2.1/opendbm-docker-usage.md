---
id: opendbm-docker-usage
title: Docker Usage
---

## Mac / Linux

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

Congratulations, it’s way easier to use OpenDBM on Mac or Linux compared to Windows.

Essentially, all you need to do is run a single command from the **open_dbm** folder. Here it is: 

```bash
% bash process_dbm.sh --input_path=<...> --output_path=<...>
```

`bash` is the command that calls the script process_dbm.sh. 

There are two required parameters, the `--input_path` and the `--output_path`. We’ll go over these in Sections 3.1.1 and 3.1.2. There are also two useful optional parameters: `--dbm_group` and `--tr`. We’ll go over those in Sections 3.1.3 and 3.1.4.

### Input path

This is simply the path to the data you want to process. For example, let’s pretend you want to process all the videos in the **sample_data** folder that comes included with OpenDBM:

<figure>
  <img src="../docs/assets/mac_linux_1.png" width="1000" alt="Sample Data screenshot" />
  <figcaption>Sample Data screenshot</figcaption>
</figure>

The path to this data would be something like **/Users/JohnWick/open_dbm/sample_data**. So, for the `--input_path` parameter in the command, you’d put in the path to that folder like this: `--input_path=/Users/JohnWick/open_dbm/sample_data`. By doing so, you’re asking to process all four videos in that folder. 
> **Helpful tip:** On Mac, if you ‘copy’ the folder you want to process from **Finder** and ‘paste’ it into **Terminal**, it automatically pastes the path to that folder.

OpenDBM allows for processing of individual video/audio files or bulk processing of several video/audio files saved together in a folder. The input path can either lead to a single file, in which case only that file will be processed, or it can lead to a folder with several files, in which case all compatible files in that folder will be processed. This path can be anywhere.

All video files must be in **MP4** or **MOV** format and all audio files must be in **WAV** or **MP3** format. The current version of the package leaves the responsibility of converting file types to the correct format to the user; hopefully future versions will handle more file types. Please be careful when using online tools to convert video that may contain sensitive information. If the specified input path does not direct to any **MP4, MOV, WAV, or MP3** files, nothing will happen.

At this point, this is what our (incomplete) command would look like:
```bash
% bash process_dbm.sh 
--input_path=/Users/JohnWick/open_dbm/sample_data 
--output_path=<...> 
```
Just in case it’s causing any confusion to beginners, `--input_path` does not need to be on a new line here; I’m just showing it this way for clarity (you should enter everything on the same line). This applies to the whole document.

### Output Path

This is the path where a new folder named **output** will be created and all calculated digital biomarker data will be stored. The structure of the data output is described in Chapter 4.

Let’s say, in our example, we want to save our outputted variables on the **Desktop**. The processing command starts looking like this:
```bash
% bash process_dbm.sh 
--input_path=/Users/JohnWick/open_dbm/sample_data --output_path=/Users/JohnWick/Desktop 
```
`--input_path` and `--output_path` are the only two mandatory parameters of the processing function. You should be able to process data at this point. The next two sections go over two optional inputs that are probably pretty good to be familiar with.

### DBM Group

There are several categories of digital biomarkers (DBMs) that are calculated by OpenDBM: 

- **Facial,** referring to measurements of facial behavior
- **Acoustic** , referring to measurements of vocal acoustics 
- **Speech,** referring to measurement of language characteristics
- **Movement** , referring to motor and oculomotor functioning

By default, OpenDBM calculates all of these from any video that is inputted. If only audio is inputted, it calculates acoustic and speech variables. But the user may not be interested in all four types of variables (e.g., maybe they just want to calculate digital biomarkers related to vocal acoustics). In that case, the --dbm_group input can be used to limit the calculation to only that category of biomarker. This functionality exists both to reduce on processing time and to allow for simplicity during subsequent data analysis downstream (see Chapter 4). 

There are four possible inputs here: facial, acoustic, speech, and movement. 

So, if the user only wants acoustic biomarkers, the processing script would look like this:
```bash
% bash process_dbm.sh 
--input_path=/Users/JohnWick/open_dbm/sample_data --output_path=/Users/JohnWick/Desktop 
--dbm_group=’acoustic’
```
> **Note:** You do need to include the quotation marks around your input for --dbm_group.

If you want, you can also select more than one group of biomarkers. For example, if you wanted to calculate both acoustic and speech biomarkers but not facial or movement ones, your command would look like this:
```bash
% bash process_dbm.sh 
--input_path=/Users/JohnWick/open_dbm/sample_data --output_path=/Users/JohnWick/Desktop 
--dbm_group=’acoustic speech’
```

### Transcription

If the data being processed contains speech, OpenDBM will transcribe that speech into text and calculate a number of measurements from the transcribed text (see Section 5.3 for all speech biomarker variables). However, the speech transcription itself is not saved. This is because it may not always be in the interest of the user to save the transcribed speech. In cases where the user is processing sensitive patient data that may contain [Protected Health Information (PHI)](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html), **the transcribed speech is still considered PHI** and is subject to strict privacy regulations. Everything that is by default saved in the **output** folder is intentionally designed to not be PHI. 

Now, if the user *wants* the transcribed text, they have the *option* to save it in the **output** folder. They can do this using the `--tr` parameter, and setting it to ‘on’, as shown below. When they do this, the transcribed text is saved in the output folder as described in Section 4.2.2. 

We only advise that the user do this if the data output is being stored in a location where PHI data can be stored, and that the data output folder will never find its way to a place where PHI data can not be stored. I am not your lawyer, nor am I liable for the wrath of HIPAA and GDPR coming down upon you, but please know that transcribed speech is indeed considered PHI, and you do need to make sure you are following all regulations and have full patient consent for it.

```bash
% bash process_dbm.sh --input_path=/Users/JohnWick/open_dbm/sample_data --output_path=/Users/JohnWick/Desktop 
--dbm_group=’acoustic speech’
--tr=on
```
> **Note:** The ‘on’ in the `--tr` parameter does not require quotation marks. Why? VJ was lazy.

And that’s it! By executing the `bash process_dbm.sh` command as described in this chapter, you can process data and calculate digital biomarkers. Section 3.2 repeats all this information for folks on Windows. You can skip to Chapter 4, which details how the data output is structured.
