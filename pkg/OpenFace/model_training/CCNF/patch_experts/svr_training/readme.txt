The script that will train the SVR patch experts is:
Script_Training_wild.m for the 300-W results
Script_Training_mpie.m for training on Multi-PIE data
Script_Training_general.m for combined dataset training

However, you will first need to generate the training data, found in ../data_preparation

The code also relies on you having a compiled liblinear library and have it in 'C:/liblinear/' folder, you can change the location where matlab looks for it in the Train_SVR.m script.