function [ shape2D_full, shape_hierarch, global_params, local_params, final_lhood, landmark_lhoods, view_used] = Fitting_from_bb_hierarch( Image, pdm_full, pdm_hierarch, patches, clmParams, shape2D_full, inds_full, inds_hierarch)

    % Perform hierarchical model fitting
    %, TODO this should be a loop?
    shape_hierarch = zeros(numel(pdm_hierarch.M)/3, 2);
        
    shape_hierarch(inds_hierarch,:) = shape2D_full(inds_full,:);

    % Get the hierarchical model parameters based on current parent
    % landmark locations
    [ a, R, T, ~, l_params, ~] = fit_PDM_ortho_proj_to_2D(pdm_hierarch.M, pdm_hierarch.E, pdm_hierarch.V, shape_hierarch);

    g_param = [a; Rot2Euler(R)'; T];

    bbox_hierarch = [min(shape_hierarch(:,1)), min(shape_hierarch(:,2)), max(shape_hierarch(:,1)), max(shape_hierarch(:,2))];

    [shape_hierarch, global_params, local_params, final_lhood, landmark_lhoods, view_used] = Fitting_from_bb(Image, [], bbox_hierarch, pdm_hierarch, patches, clmParams, 'gparam', g_param, 'lparam', l_params);

    % Now after detections incorporate the subset of the landmarks into the
    % main model, but only if we didn't upsample
    if(a > 0.9)
        shape2D_full(inds_full, :) = shape_hierarch(inds_hierarch,:);
        % Make sure the combined version can be expressed by the PDM
        [ ~, ~, ~, ~, ~, ~, shape2D_full] = fit_PDM_ortho_proj_to_2D(pdm_full.M, pdm_full.E, pdm_full.V, shape2D_full);    

    end    
    
end