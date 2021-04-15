function [ clmParams, pdm_right, pdm_left ] = Load_CLM_params_eye_28() 
%LOAD_CLM_PARAMS_WILD Summary of this function goes here
%   Detailed explanation goes here
    clmParams.window_size = [17,17; 15,15; 13,13;];
    clmParams.numPatchIters = size(clmParams.window_size,1);
    
    % the PDM created from in the wild data
    pdmLoc = ['../models/hierarch_pdm/pdm_28_r_eye.mat'];

    load(pdmLoc);

    pdm_right = struct;
    pdm_right.M = double(M);
    pdm_right.E = double(E);
    pdm_right.V = double(V);

    pdmLoc = ['../models/hierarch_pdm/pdm_28_l_eye.mat'];

    load(pdmLoc);

    pdm_left = struct;
    pdm_left.M = double(M);
    pdm_left.E = double(E);
    pdm_left.V = double(V);
    
    % the default model parameters to use
    clmParams.regFactor = 2.0;               
    clmParams.sigmaMeanShift = 1.5;
    clmParams.tikhonov_factor = 0;

    clmParams.startScale = 1;
    clmParams.num_RLMS_iter = 10;
    clmParams.fTol = 0.01;
    clmParams.useMultiScale = true;
    clmParams.use_multi_modal = 0;
    clmParams.tikhonov_factor = 0;
end

