--------------------------------------- OpenFace Matlab runners -----------------------------------------------------------------------------	

These are provided for recreation of some of the experiments described in the publications and to demonstrate the command line interface by calling the C++ executables from Matlab.

======================== Demos ==================================

Shows examples of running OpenFace executables from the command line interface and loading the output results into Matlab. Each script shows a different use case of OpenFace.

For extracting head pose, facial landmarks, gaze HOG features and Facial Action Units look at the following demos:
	feature_extraction_demo_img_seq.m - Running the FeatureExtraction project, it demonstrates how to specify parameters for extracting a number of features from a sequence of images in a folder and how to read those features into Matlab.	
	feature_extraction_demo_vid.m - Running the FeatureExtraction project, it demonstrates how to specify parameters for extracting a number of features from a video and how to read those features into Matlab.	
	
======================== Head Pose Experiments ============================
To run them you will need to have the appropriate datasets and to change the dataset locations.

run_head_pose_tests_OpenFace_CECLM.m - runs CE-CLM on the 3 head pose datasets (Boston University, Biwi Kinect, and ICT-3DHP you need to acquire the datasets yourself)
run_head_pose_tests_OpenFace_CLNF - runs CLNF on the 3 head pose datasets (Boston University, Biwi Kinect, and ICT-3DHP you need to acquire the datasets yourself)

======================== Feature Point Experiments ============================

300W

    run_OpenFace_feature_point_tests_300W.m runs CE-CLM, CLNF, and CLM on the in the wild face datasets acquired from  http://ibug.doc.ic.ac.uk/resources/300-W/ 

    The code uses the already defined bounding boxes of faces (these are produced using the 'ExtractBoundingBoxes.m' script on the in the wild datasets). The code relies on there being a .txt file of the same name as the image containing the bounding box. (Note that if the bounding box is not provided the code will use MTCNN face detector)

    To run the code you will need to download the 300-W challenge datasets and run the bounding box extraction script, then replace the database_root with the dataset location.

    This script also includes code to draw a graph displaying error curves of the CE-CLM, CLNF and CLM methods trained on in the wild data.

YTCeleb

    run_yt_dataset.m run the CE-CLM and CLNF models on the YTCeleb Database (https://sites.google.com/site/akshayasthana/Annotations), you need to get the dataset yourself though.

300VW
    run_300VW_dataset_OpenFace.m runs CE-CLM model on the 300VW dataset (you will need to acquire it yourself) and compares the results to a number of recent facial landmark detection approaches

======================== Action Unit Experiments ============================

Evaluating our Facial Action Unit detection system on Bosphorus, BP4D, DISFA, FERA2011 and SEMAINE datasets.

As the models were partially trained/validated on DISFA, FERA2011, BP4D, UNBC, Bosphorus, and SEMAINE datasets the results might not generalise across datasets. However, this demonstrates how AU prediction can be done with our system.

======================== Gaze Experiments ============================

Evaluating our gaze estimation on the MPIIGaze dataset, run the extract_mpii_gaze_test.m script in the Gaze Experiments folder

Note that the dataset evaluated on is NOT publicly available.