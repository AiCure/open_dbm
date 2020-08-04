function [ responses ] = PatchResponseCEN_sparse(rois, patch_experts, visibilities, window_size, support_size)
%PatchResponseCEN_sparse computing response maps on the areas of interest
                  
    responses = cell(size(rois, 1), 1);
    empty = zeros(window_size(1)-support_size(1)+1, window_size(2)-support_size(2)+1);

    % Compute which indices to keep and which to remove
    to_rem_ids = [1:2:numel(empty)];
    to_keep_ids = setdiff(1:numel(empty), to_rem_ids);

    % Prepare the interpolation back to dense response
    [x_scattered, y_scattered] = ind2sub(size(empty), to_keep_ids);
    F = scatteredInterpolant(cat(2,y_scattered', x_scattered'), zeros(size(x_scattered))', 'natural');
    [yq, xq] = ind2sub(size(empty), 1:numel(empty));

    % The actual response accross patches
    for i = 1:numel(rois(:,1))
        responses{i} = empty;
        if visibilities(i)
                 
            smallRegionVec = rois(i,:);
            smallRegion = reshape(smallRegionVec, window_size(1), window_size(2));

            roi = im2col_mine(smallRegion, support_size)';
            
            % Normalize
            mean_curr = mean(roi, 2);
            roi_normed = roi - repmat(mean_curr, 1, support_size(1) * support_size(2));

            % Normalising the patches using the L2 norm
            scaling = sqrt(sum(roi_normed.^2,2));
            scaling(scaling == 0) = 1;

            roi_normed = roi_normed ./ repmat(scaling, 1, 11 * 11);

            roi = roi_normed;

            roi = roi';
            
            % Discard the support regions on which we will not evaluate
            roi = roi(:,to_keep_ids);

            % Add bias
            roi_normed = cat(1, ones(1, size(roi,2)), roi);
            output = roi_normed;
            weights = patch_experts{i};

            % Where forward pass of CEN happens
            for w =1:numel(weights)/2
                
                % mult and bias
                output = weights{(w-1)*2+1}' * output + repmat(weights{(w-1)*2+2}', 1, size(roi_normed,2));

                if w < 3
                   output = max(0, output);
                else
                   output = 1./(1+exp(-output));
                end

            end
            
            vals = double(output);
            
            % Now interpolate
            F.Values = vals';            
            responses{i}(:) = F(xq,yq);
        end
    end
    
end
