% This is the main script runner for training, it collects the
% training samples, followed by model training

clear

% define the root name of database
root = '../data_preparation/prepared_data/';

% which scales we're doing
scales = [0.25, 0.35, 0.5];

% the data generation parameters
sigma = 1;
num_samples = 5e5;
ratio_neg = 5;
norm = 1;
normalisation_size = 19;

patch_types = {'reg', 'grad'};
 
% Should a frontal view be created
frontalView = [1];

% The other views to be used
profileViewInds = [2];
upDownViewInds = [];

version = 'wild';

% the naming of
wild_loc = 'wild_';

for s=scales
    Train_all(root, frontalView, profileViewInds, upDownViewInds, s,...
        sigma, version, norm, 'ratio_neg', ratio_neg,...
        'num_samples', num_samples, 'data_loc', wild_loc,...
        'patch_types', patch_types, 'normalisation_size', normalisation_size);
end
