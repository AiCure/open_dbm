function [patches, pdm, clmParams, early_term_params] = Load_CECLM_menpo()
%LOAD_PATCH_EXPERTS Summary of this function goes here
%   Detailed explanation goes here
   
    % Load the patch experts/local detectors
    [patches] = Load_CECLM_Patch_Experts( '../models/cen/', 'cen_patches_*_menpo.mat');

    % the default PDM to use
    pdmLoc = ['../models/pdm/pdm_68_aligned_menpo.mat'];

    load(pdmLoc);

    pdm = struct;
    pdm.M = double(M);
    pdm.E = double(E);
    pdm.V = double(V);

    clmParams = struct;

    clmParams.window_size = [25,25; 23,23; 21,21; 21,21];
    clmParams.numPatchIters = size(clmParams.window_size,1);

    clmParams.regFactor = 0.9*[35, 27, 20, 20];
    clmParams.sigmaMeanShift = 1.5*[1.25, 1.375, 1.5, 1.5]; 
    clmParams.tikhonov_factor = [2.5, 5, 7.5, 7.5];

    clmParams.startScale = 1;
    clmParams.num_RLMS_iter = 10;
    clmParams.fTol = 0.01;
    clmParams.useMultiScale = true;
    clmParams.use_multi_modal = 1;
    clmParams.multi_modal_types  = patches(1).multi_modal_types;
    clmParams.numPatchIters = 4;
    
    % As the orientations are not equally reliable reweigh them
    load('../models/cen/cen_menpo_mapping.mat');    
end

