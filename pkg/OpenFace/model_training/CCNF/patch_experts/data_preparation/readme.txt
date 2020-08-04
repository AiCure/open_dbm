The code here prepares the training images and labels into a format that can be easilly used to train SVR and CCNF regressors.

Just run "scripts/Prepare_data_wild_all.m" for data needed to train patch experts for in-the-wild experiments.(you have to have the relevant datasets, but they are all available online at http://ibug.doc.ic.ac.uk/resources/facial-point-annotations/) 

Run "scripts/Prepare_data_Multi_PIE_all.m" (you have to have the multi-pie dataset and labels)

Run "scripts/Prepare_data_general_all.m" (you have to have both of the datasets, and you have to run "scripts/Prepare_data_wild_all.m" and scripts/Prepare_data_Multi_PIE_all.m" first.

Run "scripts/Prepare_data_menpo_all.m" (you have to have the Menpo challenge training data - https://ibug.doc.ic.ac.uk/resources/2nd-facial-landmark-tracking-competition-menpo-ben/)

PDM model used is trained on 2D landmark labels using Non-Rigid-Structure for motion (code can be found http://www.cl.cam.ac.uk/~tb346/res/ccnf/pdm_generation.zip)