function [ patches, pdm, clmParams, inds_full, inds_inner ] = Load_CLNF_inner()
%LOAD_CLNF_Inner Summary of this function goes here
%   Detailed explanation goes here

    % 51 landmark model of a face (a subset of 68 landmark model without
    % the face outline)
    clmParams = struct;
    clmParams.window_size = [19,19];
    clmParams.numPatchIters = size(clmParams.window_size,1);
    
    % the PDM created from in the wild data
    pdmLoc = ['../models/hierarch_pdm/pdm_51_inner.mat'];

    load(pdmLoc);

    pdm = struct;
    pdm.M = double(M);
    pdm.E = double(E);
    pdm.V = double(V);
    
    % the default model parameters to use
    clmParams.regFactor = 2.5;               
    clmParams.sigmaMeanShift = 1.75;
    clmParams.tikhonov_factor = 2.5;
    
    clmParams.startScale = 1;
    clmParams.num_RLMS_iter = 5;
    clmParams.fTol = 0.01;
    clmParams.useMultiScale = true;
    clmParams.use_multi_modal = 1;
    
    [patches] = Load_Patch_Experts( '../models/general/', 'ccnf_patches_*general_no_out.mat', [], [], clmParams);
    clmParams.multi_modal_types  = patches(1).multi_modal_types;

    % Corresponding indices between the 68 point and the 51 point version
    inds_full = 18:68;
    inds_inner = 1:51;
    
end

