The project was tested on Matlab 2015a and 2015b on 64 bit Windows 7 and Windows 8 machines (can't guarantee compatibility with other configurations, but should work with newer versions).
Comes prepackaged with all the necessary code and some of the data (that I'm allowed to share). You have to respect nrsfm, OpenCV and other licenses.

To download the CEN models go to - https://www.dropbox.com/sh/o8g1530jle17spa/AADRntSHl_jLInmrmSwsX-Qsa?dl=0, place all of .mat files to ./models/cen and .dat files to ./lib/local/LandmarkDetector/model/patch_experts/

--------------------------------------- Copyright information -----------------------------------------------------------------------------	

Copyright can be found in the copyright.txt

--------------------------------------- Code Layout -----------------------------------------------------------------------------

//======================= Core ========================//
./fitting - Where the actual CLM and CLNF model fitting happens
./models - the pre-trained models for CE-CLM, and Constrained Local Neural Fields, this includes Point Distribution Model, Patch experts, landmark validation
./CCNF - the libraries that contain CCNF functions needed for landmark detection

//======================= Demos and experiments =======//
./demo - contains a number of useful scripts that demonstrate the running of CLM, CLNF, and CE-CLM models on videos and images
	face_image_demo - running CE-CLM, CLNF or CLM on images of faces
	face_image_demo_eyes - running CE-CLM, CLNF or CLM on images of faces + eye landmark detection
	face_image_depth_demo - running CLM-Z on grayscale and range images of faces
	face_video_demo - running CE-CLM, CLNF or CLM on videos of faces
./experiments_300VW - These are provided for recreation of experiments on 300VW dataset
./experiments_300W - These are provided for recreation of some of the experiments described in the papers on 300W dataset
./experiments_JANUS - These are provided for recreation of some of the experiments described in the papers on IJB-FL dataset 
./experiments_menpo - These are provided for recreation of some of the experiments described in the papers on the menpo dataset (both cross and within data)

//======================= Utilities ===================//
./face_detection - Provides utilities for face detection, possible choices between two detectors: MTCNN (requires MatConvNet for speed), and Matlab inbuilt one
    ./mtcnn - a recent and accurate face detector, MTCNN face detector based on the paper "Joint Face Detection and Alignment using Multi-task Cascaded Convolutional Neural Networks" by Zhang et al.
./face_validation - A module for validating face detections (training and inference), it is used for tracking in videos so as to know when reinitialisation is needed
./PDM_helpers - utility functions that deal with PDM fitting, Jacobians and other shape manipulations
	
--------------------------------------- Results -----------------------------------------------------------------------------	
	
Results that you should expect on running the code on the publicly available datasets can be found in:

./results folders in each of the experiment* folders

--------------------------------------- Final remarks -----------------------------------------------------------------------------	

I did my best to make sure that the code runs out of the box but there are always issues and I would be grateful for your understanding that this is research code. However, if you encounter any problems please raise an issue on github.