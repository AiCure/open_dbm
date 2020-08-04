clear
% define the root name of database
root = '../data_preparation/prepared_data/';


% which scales we're doing
sigma = 1;
num_samples = 5e5;

scales = [0.25,0.35,0.5];
frontalView = 1;

profileViewInds = [2,3,4];

version = 'multi_pie';
ratio_neg = 5;
norm = 1;

data_loc = 'mpie_';
rng(0);

similarities = {[1,2]; [3, 4]};
sparsity = 1;
sparsity_types = [4,6];

lambda_a = 100;
lambda_b = 1000;
lambda_th = 1;
num_layers = 7;
    
for s=scales

    Train_all_patch_experts(root, frontalView, profileViewInds,...
        s, sigma, version, 'ratio_neg', ratio_neg,...
        'num_samples', num_samples, 'data_loc', data_loc,...
        'normalisation_size', 19, 'similarity_types', similarities, 'sparsity', sparsity,...
        'sparsity_types', sparsity_types, 'lambda_a', lambda_a, 'lambda_b', lambda_b, 'lambda_th', lambda_th, 'num_layers', num_layers);
end