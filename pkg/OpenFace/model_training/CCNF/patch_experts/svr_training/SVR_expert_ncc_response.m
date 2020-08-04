function [ responses ] = SVR_expert_ncc_response( patches, patch_experts, normalisation_options, window_size, patch_length)
%PATCHRESPONSESVM Summary of this function goes here
%   Detailed explanation goes here

    % reshape the separate patches into proper images
        
    patchSize = normalisation_options.patchSize;
           
    responses = zeros(size(patches,1), (window_size(1)-patchSize(1)+1)^2);
    % prepare the patches through either turning them to gradients or 
%     if(normalisation_options.useNormalisedCrossCorr)
%         patches = zscore(patches);
%     end
    w = reshape(patch_experts(3:end), patchSize);
    
    v = [1];
    h = [-1 0 1];    
    
    for i = 1:size(patches,1)
        
        colNorm = normalisation_options.useNormalisedCrossCorr == 1;
            
        smallRegionVec = patches(i,:);       
        smallRegion = reshape(smallRegionVec, window_size(1), window_size(2));                
        
        if(strcmp(normalisation_options.patch_type, 'grad'))
            edgeX = conv2(conv2(smallRegion, v, 'same'), h, 'same');
            edgeY = conv2(conv2(smallRegion, v', 'same'), h', 'same');
            smallRegion = edgeX.^2 + edgeY.^2;
        end
        

        response = SVMresponse(smallRegion, w, colNorm, patchSize);   

        response = (exp(-(patch_experts(1)*response+patch_experts(2)))+1).^-1;    
         
        responses(i,:) = response(:);
        
    end
    responses = responses';
    responses = responses(:);
end

function response = SVMresponse(region, patchExpert, normalise_x_corr,patchSize)

    if(normalise_x_corr)
        [response] = normxcorr2(patchExpert, region);
        % the much faster mex version
%         [response] = normxcorr2_mex(patchExpert, region);

        response = response(patchSize(1):end-patchSize(1)+1,patchSize(2):end-patchSize(2)+1);       
    else        
        % this assumes that the patch is already normed, so just use
        % cross-correlation
        template = rot90(patchExpert,2);
        response = conv2(region, template, 'valid');
        
    end
end
