function [ patches, pdm, clmParams ] = Load_CLNF_general()
%LOAD_CLNF_GENERAL Summary of this function goes here
%   Detailed explanation goes here
    clmParams = struct;

    clmParams.window_size = [25,25; 23,23; 21,21];
    clmParams.numPatchIters = size(clmParams.window_size,1);

    [patches] = Load_Patch_Experts( '../models/general/', 'ccnf_patches_*_general.mat', [], [], clmParams);

    % the default PDM to use
    pdmLoc = ['../models/pdm/pdm_68_aligned_wild.mat'];
    load(pdmLoc);

    pdm = struct;
    pdm.M = double(M);
    pdm.E = double(E);
    pdm.V = double(V);

    % the default model parameters to use
    clmParams.regFactor = [35, 27, 20];
    clmParams.sigmaMeanShift = [1.25, 1.375, 1.5]; 
    clmParams.tikhonov_factor = [2.5, 5, 7.5];

    clmParams.startScale = 1;
    clmParams.num_RLMS_iter = 10;
    clmParams.fTol = 0.01;
    clmParams.useMultiScale = true;
    clmParams.use_multi_modal = 1;
    clmParams.multi_modal_types  = patches(1).multi_modal_types;

end

