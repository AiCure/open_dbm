clear
% define the root name of database
root = '../data_preparation/prepared_data/';

% which scales we're doing
sigma = 1;
num_samples = 5e5;

scales = [0.25,0.35,0.5];
frontalView = 1;

profileViewInds = [];

version = 'cofw';
ratio_neg = 5;
norm = 1;

data_loc = 'cofw_';
rng(0);

% where to save generated patches for external training
% (e.g. for training CEN patches)
patches_loc = './patches/';
patch_folder = [patches_loc version '/'];

for s=scales
    Save_all_patches(root, frontalView, profileViewInds,...
        s, sigma, version, patch_folder, 'ratio_neg', ratio_neg,...
        'num_samples', num_samples, 'data_loc', data_loc,...
        'normalisation_size', 19);
end

