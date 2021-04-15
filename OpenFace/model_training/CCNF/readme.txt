These files contain the libraries needed to train and test Continuous Conditional Neural Fields (CCNF) and Continuous Conditional Random Fields (CCRF).

The project was tested on Matlab R2012b and R2013a (can't guarantee compatibility with other versions).

Some of the experiments rely on the availability of mex compiled liblinear (http://www.csie.ntu.edu.tw/~cjlin/liblinear/) and libsvm (http://www.csie.ntu.edu.tw/~cjlin/libsvm/) on your machine.

--------------- Copyright information ---------------------------------------

Copyright can be found in the Copyright.txt

--------------- Code Layout -------------------------------------------------


./CCNF - the training and inference libraries for CCNF
./CCRF - the training and inference libraries for CCRF

./patch_experts - training code for patch expert training (for facial landmark detection), the landmark detector that uses these patches can be found in https://github.com/TadasBaltrusaitis/CLM-framework.
    ccnf_training/ - training CCNF patch experts (for the Constrained Local Neural Fields for robust facial landmark detection in the wild paper)
    data_preparation/ - converting image and landmark datasets to the right formats
    svr_training/ - training SVR patch experts (the standard CLM patch experts)

------------- Final remarks ------------------------------------------------

I did my best to make sure that the code runs out of the box but there are always issues and I would be grateful for your understanding that this is research code.