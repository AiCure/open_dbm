My re-implementation of MTCNN face detector (https://github.com/kpzhang93/MTCNN_face_detection_alignment) using Matlab and MatcConvNet.

It uses MatConvNet to speed up face detection, and is able to use GPU support. Alternatively, if MatConvNet is not installed the approach will use Matlab native functions for processing (much slower).

MatConvNet version used:
- MatConvNet from http://www.vlfeat.org/matconvnet/ (tested with version 1.0-beta24), and install following the instructions
