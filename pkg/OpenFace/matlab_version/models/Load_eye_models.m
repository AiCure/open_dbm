function [ clmParams_eye, pdm_right_eye, pdm_left_eye, ...
    patches_left_eye, patches_right_eye,...
    left_eye_inds_in_68, right_eye_inds_in_68,...
    left_eye_inds_in_28, right_eye_inds_in_28] = Load_eye_models() 

    clmParams_eye.window_size = [17,17; 15,15; 13,13;];
    clmParams_eye.numPatchIters = size(clmParams_eye.window_size,1);
    
    % the PDM created from in the wild data
    pdmLoc = ['../models/hierarch_pdm/pdm_28_r_eye.mat'];

    load(pdmLoc);

    pdm_right_eye = struct;
    pdm_right_eye.M = double(M);
    pdm_right_eye.E = double(E);
    pdm_right_eye.V = double(V);

    pdmLoc = ['../models/hierarch_pdm/pdm_28_l_eye.mat'];

    load(pdmLoc);

    pdm_left_eye = struct;
    pdm_left_eye.M = double(M);
    pdm_left_eye.E = double(E);
    pdm_left_eye.V = double(V);
    
    % the default model parameters to use
    clmParams_eye.regFactor = 2.0;               
    clmParams_eye.sigmaMeanShift = 1.5;
    clmParams_eye.tikhonov_factor = 0;

    clmParams_eye.startScale = 1;
    clmParams_eye.num_RLMS_iter = 10;
    clmParams_eye.fTol = 0.01;
    clmParams_eye.useMultiScale = true;
    clmParams_eye.use_multi_modal = 0;
    clmParams_eye.tikhonov_factor = 0;

    [patches_right_eye] = Load_Patch_Experts( '../models/hierarch/', 'ccnf_patches_*_synth_right_eye.mat', [], [], clmParams_eye);
    [patches_left_eye] = Load_Patch_Experts( '../models/hierarch/', 'ccnf_patches_*_synth_left_eye.mat', [], [], clmParams_eye);
    clmParams_eye.multi_modal_types  = patches_right_eye(1).multi_modal_types;
    right_eye_inds_in_68 = [43,44,45,46,47,48];
    left_eye_inds_in_68 = [37,38,39,40,41,42];

    right_eye_inds_in_28 = [9 11 13 15 17 19];
    left_eye_inds_in_28 = [9 11 13 15 17 19];

end