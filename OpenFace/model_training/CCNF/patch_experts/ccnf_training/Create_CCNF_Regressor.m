function [alphas, betas, thetas, similarities, sparsities] = Create_CCNF_Regressor(samples, labels, patch_length, similarity_types, sparsity_types, normalisation_options)
%CREATESVMCLASSIFIER creating a CCNF (LNF) patch expert given labeled
%training samples

% Add the CCNF library
addpath('../../CCNF/lib');

%% Preparing the similarity and sparsity function
   
% this will create a family of similarity neighbour node connections
similarities = {};
    
for i=1:size(similarity_types, 1)
    type = similarity_types{i};
    neighFn = @(x) similarity_neighbor_grid(x, sqrt(patch_length), type);
    similarities = [similarities; {neighFn}];
end

sparsities = {};

% this will create a family of sparsity (inhibition) neighbour node
% connections
for i=1:size(sparsity_types, 1)

    spFn = @(x) sparsity_grid(x, sqrt(patch_length), sparsity_types(i,1), sparsity_types(i,2));
    sparsities = [sparsities; {spFn}];
end

%% Default training hyper-parameters
thresholdX = 1e-8;
thresholdFn = 1e-4;
max_iter = 200;

input_layer_size  = size(samples, 1)-1;
   
% Some rule of thumb hyper-parameters if similarities are defined or not
if(numel(similarities) == 0)
    best_lambda_a = 10000;
    best_lambda_b = 0;
    best_lambda_th = 0.1;
    best_num_layer = 5;
else
    best_lambda_a = 100;
    best_lambda_b = 1000;
    best_lambda_th = 0.1;
    best_num_layer = 5;
end

% Checking if hyper-parameters are specified to be overriden
if(isfield(normalisation_options, 'lambda_a'))
    best_lambda_a = normalisation_options.lambda_a;
end

if(isfield(normalisation_options, 'lambda_b'))
    best_lambda_b = normalisation_options.lambda_b;
end

if(isfield(normalisation_options, 'lambda_th'))
    best_lambda_th = normalisation_options.lambda_th;
end

if(isfield(normalisation_options, 'num_layers'))
    best_num_layer = normalisation_options.num_layers;
end

% Initial parameter values
alphas = 1 * ones(best_num_layer,1);
betas = 1 * ones(numel(similarities) + numel(sparsities), 1);    
initial_Theta = randInitializeWeights(input_layer_size, best_num_layer);

num_seqs = size(samples, 2)/patch_length;
labels = reshape(labels, patch_length, num_seqs);

% Actual training
[alphas, betas, thetas] = CCNF_training_bfgs(thresholdX, thresholdFn, samples, labels, alphas, betas, initial_Theta, best_lambda_a, best_lambda_b, best_lambda_th, similarities, sparsities, 'const', true, 'reinit', true, 'num_reinit', 20, 'num_seqs', num_seqs, 'lbfgs', 'max_iter', max_iter);

end