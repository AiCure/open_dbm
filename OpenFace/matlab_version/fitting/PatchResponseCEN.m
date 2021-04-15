function [ responses ] = PatchResponseCEN(patches, patch_experts_class, visibilities, patchExperts, window_size)
%PATCHRESPONSESVM Summary of this function goes here
%   Detailed explanation goes here

    normalisationOptions = patchExperts.normalisationOptionsCol;
    patchSize = normalisationOptions.patchSize;
                  
    responses = cell(size(patches, 1), 1);
    empty = zeros(window_size(1)-patchSize(1)+1, window_size(2)-patchSize(2)+1);
    
    for i = 1:numel(patches(:,1))
        responses{i} = empty;
        if visibilities(i)
                        
            col_norm = normalisationOptions.useNormalisedCrossCorr == 1;

            smallRegionVec = patches(i,:);
            smallRegion = reshape(smallRegionVec, window_size(1), window_size(2));

            patch = im2col_mine(smallRegion, patchSize)';
            
            % Normalize
            if(col_norm)
                mean_curr = mean(patch, 2);
                patch_normed = patch - repmat(mean_curr, 1, patchSize(1)* patchSize(2));

                % Normalising the patches using the L2 norm
                scaling = sqrt(sum(patch_normed.^2,2));
                scaling(scaling == 0) = 1;

                patch_normed = patch_normed ./ repmat(scaling, 1, 11 * 11);

                patch = patch_normed;
            end
            patch = patch';
            % Add bias
            patch_normed = cat(1, ones(1, size(patch,2)), patch);
            weights = patch_experts_class{i};
            % Where DNN will happen
            for w =1:numel(weights)/2
                
                % mult and bias
                patch_normed = weights{(w-1)*2+1}' * patch_normed + repmat(weights{(w-1)*2+2}', 1, size(patch_normed,2));

                if w < 3
%                    patch_normed(patch_normed < 0) = 0;
                   patch_normed = max(0, patch_normed);
                else
                   patch_normed = 1./(1+exp(-patch_normed));
                end

            end
            
            responses{i}(:) = reshape(patch_normed', window_size(1)-patchSize(1)+1, window_size(2)-patchSize(2)+1);
            
        end
    end
    
end
