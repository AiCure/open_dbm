Code for facial landmark detection validation (knowing if detection succeeded), to be use for face tracking in videos so as not to do face detection every frame.

To create the training data run:
Create_data_train.m and Create_data_test.m

The data generation code requires you to have the patch expert training data (Menpo, Multi-PIE and 300W data, not included) for positive examples, and inriaperson dataset for negative samples (not included as well). 

To train Convolutional Neural Network based face landmark validation model use:
Train_face_checker_cnn.m

This will produce trained/face_checker_cnn_*.mat and trained/face_checker_cnn_*.txt files that can be used in C++ and matlab versions of OpenFace for face validation. Old versions can also be found in trained folder (they are simpler CNN models trained on smaller datasets).

This will also produces tris*.txt files that can be used in the C++ version of the OpenFace,just place it in the lib\local\LandmarkDetector\model\detection_validation folder and edit the appropriate "main_*.txt" files. 

The code uses piece-wise affine warping to a neutral shape with an CNN regressor for error estimation (see http://www.cl.cam.ac.uk/~tb346/ThesisFinal.pdf Section 4.6.2 for a very similar model but with SVR regressor)

Dependencies:
- vlfeat-0.9.20 and extract it in the current directory (http://www.vlfeat.org/download.html)
- MatConvNet from http://www.vlfeat.org/matconvnet/ (tested with version 1.0-beta24), and install following the instructions

Change the setup.m to match the locations of vlfeat and MatConvNet