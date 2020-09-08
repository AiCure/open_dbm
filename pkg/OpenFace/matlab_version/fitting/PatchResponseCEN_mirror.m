function [ responses ] = PatchResponseCEN_mirror(patches, patch_experts_class, visibilities, patchExperts, window_size)
% As frontal faces are roughly symmetrical can compute the responses for
% two patches at the same time using only one of the landmark patch experts

    normalisationOptions = patchExperts.normalisationOptionsCol;
    patchSize = normalisationOptions.patchSize;
                  
    responses = cell(size(patches, 1), 1);
    empty = zeros(window_size(1)-patchSize(1)+1, window_size(2)-patchSize(2)+1);
    
    % These landmark responses can be computed together
    mirror_inds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
                  32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
                  61,65;62,64;68,66];
              
    for i = 1:numel(patches(:,1))
        if visibilities(i)
            % Do it only if not mirrored
            if(isempty(find(mirror_inds(:,2)==i, 1)))            
                responses{i} = empty;

                col_norm = normalisationOptions.useNormalisedCrossCorr == 1;

                smallRegionVec = patches(i,:);
                smallRegion = reshape(smallRegionVec, window_size(1), window_size(2));

                patch = im2col_mine(smallRegion, patchSize)';

                % Add the mirrored version as well (it will be applied the
                % same way)
                mirr_id = mirror_inds(find(mirror_inds(:,1)==i,1),2);
                if(~isempty(mirr_id))
                    responses{mirr_id} = empty;
                    smallRegionVec_mirr = patches(mirr_id,:);
                    smallRegion_mirr = reshape(smallRegionVec_mirr, window_size(1), window_size(2));
                    patch_mirr = im2col_mine(fliplr(smallRegion_mirr), patchSize)';
                    patch = cat(1, patch, patch_mirr);
                end                
                
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
                % If no mirroring took place
                if(isempty(mirr_id))
                    responses{i}(:) = reshape(patch_normed', window_size(1)-patchSize(1)+1, window_size(2)-patchSize(2)+1);
                else
                    patch_normed_1 = patch_normed(1:end/2);
                    patch_normed_2 = patch_normed(end/2+1:end);
                    responses{i}(:) = reshape(patch_normed_1', window_size(1)-patchSize(1)+1, window_size(2)-patchSize(2)+1);
                    responses{mirr_id}(:) = fliplr(reshape(patch_normed_2', window_size(1)-patchSize(1)+1, window_size(2)-patchSize(2)+1));
                end
            end
        end
    end
    
end
