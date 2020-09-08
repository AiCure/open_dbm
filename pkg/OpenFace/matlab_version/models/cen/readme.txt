Scripts for creating CEN patch experts from already trained models.

1. To create one from 300W + MultiPIE - create_cen_experts_gen.m
2. To create one from 300W + MultiPIE + Menpo - create_cen_experts_menpo.m

Please note that items 1 and 2 use the output of the code from "OpenFace/model_training/ce-clm_training/cen_training/train_cen.py. The output of this code is fed as "MultiGeneral_arch4general_%s_[frontal,profilex]_%d_512.mat'" in file 1 which can be decoded as follows: we call the training procedure MultiGeneral. It uses arch4 and is trained on 300W + MultiPIE (called general). Hence the architecture and data are represented as arch4general. The first %s is the scale. When generating the data from "OpenFace/model_training/ce-clm_training/patch_generation/" you will have 4 scales of {'0.25', '0.35', '0.50', '1.00'}. The frontal means trained for frontal faces (patches from frontal images) and profilex means from profilex; x can be 1,2,3 or depending on how many different profiles you defined when generating the data. The %d means which landmark number the training has been done for. 512 denotes the minibatch size. If you decide to go with different names please replace the "MultiGeneral_arch4general_%s_[frontal,profilex]_%d_512.mat'" with your desired name. We didn't change it to demonstrate which architecture and configurations we used. This name should match the output of the script "OpenFace/model_training/ce-clm_training/patch_generation/" denoted with parameter <results_dir> where all the results are svaed. All the training epochs will be stored when training ce-clm model, you can simply pick the best one and use it for the scripts in this folder. 

To create one used in OpenFace for C++ code:
create_cen_experts_OF.m (this uses both the general and menpo experts to create a joint one, with general ones used when menpo unavailable for that view)

To dowload pretrained models, go to:
https://www.dropbox.com/sh/o8g1530jle17spa/AADRntSHl_jLInmrmSwsX-Qsa?dl=0
