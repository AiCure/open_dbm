This code is in support of the "Convolutional experts constrained local model 
for 3d facial landmark detection" paper by Amir Zadeh, Yao Chong Lim,
Tadas Baltrusaitis, and Louis-Philippe Morency. The code is based on
support code of the "Constrained Local Neural Fields for robust facial
landmark detection in the wild" paper by Tadas Baltrusaitis, Peter Robinson, and Louis-Philippe Morency.

This folder provides the code for generating patches used in training the patch experts.

You have to have the relevant datasets, to run the code, the in-the-wild
datasets can be found at http://ibug.doc.ic.ac.uk/resources/facial-point-annotations/),
the annotations are provided. The Multi-PIE dataset can be acquired from -
http://www.multipie.org/, you will need to ask the authors of the dataset for the annotations. 

./data_preparation/ folder contains scripts to prepare data for patch generation

./scripts/ contains the scripts to generate the patches for training.
