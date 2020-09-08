clear;
load('trained/ccnf_patches_1_general.mat');

% now drop the first 17 points
visiIndex = visiIndex(:,18:end);

patch_experts.correlations = patch_experts.correlations(:,18:end);
patch_experts.rms_errors = patch_experts.rms_errors(:,18:end);
patch_experts.patch_experts = patch_experts.patch_experts(:,18:end);

Write_patch_experts_ccnf('trained/ccnf_patches_1.00_inner.txt',...
    'trained/ccnf_patches_1.00_inner.mat', trainingScale, centers,...
    visiIndex, patch_experts, normalisationOptions, [7,9,11,15]);