function [ responses ] = CCNF_ncc_response( patches, patch_experts, normalisation_options, window_size, patch_length)
%PATCHRESPONSESVM Computing a patch response from a CCNF patch expert
%   Using convolution, for testing purposes and not for actual speed

    SigmaInv = patch_experts.SigmaInv;
    
    patchSize = normalisation_options.patchSize;
    
    if(~iscell(patches))       
        patches = {patches};
    end
    
    num_modalities = numel(patches);
    
    responses = zeros(size(patches{1},1), patch_length);
    
    % prepare the patches by normalising them to zscore (if used)
    if(normalisation_options.zscore)
        for i=1:num_modalities
            patches{i} = zscore(patches{i});
        end
    end
    
    for i = 1:size(patches{1},1)
        
        norm_cross_corr = normalisation_options.useNormalisedCrossCorr == 1;
        
        b = zeros(patch_length,1);

        hl_per_modality = size(patch_experts.thetas,1);
        
        for p=1:num_modalities
            smallRegionVec = patches{p}(i,:);
            smallRegion = reshape(smallRegionVec, window_size(1), window_size(2));                

            for hls = 1:hl_per_modality

                % because the normalised cross correlation calculates the
                % responses from a normalised template and a normalised image,
                % normalise the thetas here and then apply the normalisation to
                % the response
                
                w = patch_experts.thetas(hls, 2:end, p);
                norm_w = norm(w);
                w = w/norm(w);
                w = reshape(w, patchSize);

                response = -norm_w * Cross_corr_resp(smallRegion, w, norm_cross_corr, patchSize) - patch_experts.thetas(hls,1,p);

                % here we include the bias term as well, as it wasn't added
                % during the response calculation
                h1 = 1./(1 + exp(response(:)));
                b = b + (2 * patch_experts.alphas((p-1)*hl_per_modality + hls) * h1);

            end
        end
        response = SigmaInv \ b;
         
        responses(i,:) = response(:);
        
    end
    responses = responses';
    responses = responses(:);
end

function response = Cross_corr_resp(region, patchExpert, normalise_x_corr,patchSize)

    if(normalise_x_corr)
        [response] = normxcorr2(patchExpert, region);
        response = response(patchSize(1):end-patchSize(1)+1,patchSize(2):end-patchSize(2)+1);       
    else        
        % this assumes that the patch is already normed, so just use
        % cross-correlation
        template = rot90(patchExpert,2);
        response = conv2(region, template, 'valid');
        
    end
end
