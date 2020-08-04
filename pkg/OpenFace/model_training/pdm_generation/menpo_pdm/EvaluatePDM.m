clear
load('Noise_PDM/noise_0.2.mat');
addpath('../PDM_helpers');

xs_orig = data_orig(:,1:end/2);
ys_orig = data_orig(:,end/2+1:end);

xs_noise = data_noise(:,1:end/2);
ys_noise = data_noise(:,end/2+1:end);

num_imgs = size(xs_noise, 1);

errs_orig = zeros(1,num_imgs);
errs_noise = zeros(1,num_imgs);
probs_orig = zeros(1,num_imgs);
probs_noise = zeros(1,num_imgs);

pdmLoc = ['pdm_68_aligned_menpo_v5.mat'];

load(pdmLoc);

pdm = struct;
pdm.M = double(M);
pdm.E = double(E);
pdm.V = double(V);

for i=1:num_imgs
    
    labels_curr_orig = cat(2, xs_orig(i,:)', ys_orig(i,:)') * 100;
    labels_curr_orig(labels_curr_orig==-200) = 0;

    [ a, R, T, ~, l_params, err, shapeOrtho] = fit_PDM_ortho_proj_to_2D(pdm.M, pdm.E, pdm.V, labels_curr_orig);
    errs_orig(i) = err/a;
    probs_orig(i) = sum(log(exp((-l_params.^2)./(pdm.E.^2))./(sqrt(2*pi.*pdm.E))));
    labels_curr_noise = cat(2, xs_noise(i,:)', ys_noise(i,:)') * 100;
    labels_curr_noise(labels_curr_orig==0) = 0;

    [ a, R, T, ~, l_params, err, shapeOrtho] = fit_PDM_ortho_proj_to_2D(pdm.M, pdm.E, pdm.V, labels_curr_noise);
    errs_noise(i) = err/a;
    probs_noise(i) = sum(log(exp((-l_params.^2)./(pdm.E.^2))./(sqrt(2*pi.*pdm.E))));
    
end

% Current error is 2.1728 on the training data
% After cleanup and smaller steps it is 1.5388
% After training on it we have 1.1999
% V2 - 1.1392
% V3 - 1.1406