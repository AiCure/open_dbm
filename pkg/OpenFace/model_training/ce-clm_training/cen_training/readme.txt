The code in this folder trains CEN patch experts for use with the CE-CLM
landmark detector. First generate the patches for training, using the code
in ../patch_generation.

Then run the training code via train_cen.py. Each patch expert is trained for a single scale, view and landmark.

python train_cen.py (location of patches) (model to train) (scale to train) (view to train) (landmark to train) (minibatch size) (folder to save models to) (menpo or general/300W patches)


other options:
--num_epochs : number of epochs to train (default 50)
--outfile : file to save training history to (default acc.txt)
--acc_file : file to load training history from to resume (set this flag in order to resume training)


e.g.
python train_cen.py menpo_data/ arch6 0.35 profile3 5 256 model_saves menpo --num_epochs 100 --outfile menpo_acc_120.txt --acc_file menpo_acc_20.txt


Subsequently, run the keras2matlab.py for getting your model in matlab format. Each landmark patch detector needs to be converted into a matlab input file using this script. The script takes in an input file which would be one output output of the train_cen code. Then it turns it into matlab object. The code is written for architecture 4, if you are using other architecture you need to copy and paste the architecture to build_model. 
