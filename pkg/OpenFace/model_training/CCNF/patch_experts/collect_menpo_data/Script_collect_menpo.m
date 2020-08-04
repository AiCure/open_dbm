clear
% define the root name of database
root = '../data_preparation/prepared_data/';


% which scales we're doing
sigma = 1;
num_samples = 4.5e6; % Making sure all data is used

scales = [0.25,0.35,0.5,1.0];
frontalView = 1;

profileViewInds = [2,3,4];

version = 'menpo_train';
ratio_neg = 10;
norm = 1;

data_loc = 'menpo_train_';
rng(0);

for s=scales

    Collect_all_patches(root, frontalView, profileViewInds,...
        s, sigma, version, 'ratio_neg', ratio_neg,...
        'num_samples', num_samples, 'data_loc', data_loc,...
        'normalisation_size', 19);
end

version = 'menpo_valid';
data_loc = 'menpo_valid_';
rng(0);

for s=scales

    Collect_all_patches(root, frontalView, profileViewInds,...
        s, sigma, version, 'ratio_neg', ratio_neg,...
        'num_samples', num_samples, 'data_loc', data_loc,...
        'normalisation_size', 19);
end