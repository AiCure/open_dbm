clear;

% Make sure we have the dependencies for convolution
od = cd('../../face_validation');
setup;
cd(od);

img = imread('test1.jpg');

[bboxes, lmarks, confidences] = detect_face_mtcnn(img);