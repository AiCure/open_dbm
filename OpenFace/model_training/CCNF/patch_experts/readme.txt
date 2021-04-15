This code is in support of the "Constrained Local Neural Fields for robust facial landmark detection in the wild" paper by Tadas Baltrusaitis, Peter Robinson, and Louis-Philippe Morency.

This code provides the code for training the patch experts used in the experiments reported in the paper.

You have to have the relevant datasets, to run the code, the in-the-wild datasets can be found at http://ibug.doc.ic.ac.uk/resources/facial-point-annotations/), the annotations are provided. The Multi-PIE dataset can be acquired from - http://www.multipie.org/, you will need to ask the authors of the dataset for the annotations. 

./data_preparation/ folder contains scripts to prepare data for CCNF (CLNF) and SVR patch expert training

./ccnf_training/ and ./svr_training/ folders contain the training code itself.

I suggest starting with dataset preparation then with SVR and CCNF patch expert training.

The trained patch experts can then be used with the Matlab and C++ OpenFace landmark detection algorithms