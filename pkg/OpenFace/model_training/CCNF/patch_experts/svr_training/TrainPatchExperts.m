function [correlations, rms_errors, patch_experts, visi_index, centres, normalisation_options] ...
    = TrainPatchExperts(trainingLoc, view, scale, sigma, patch_type, ratio_neg, num_samples, varargin)
	
    % Training patch experts for all of the landmarks for a particular view
    % and scale
    
    % Get the training parameters
    normalisation_options = Parse_settings( sigma, patch_type, ratio_neg, num_samples, varargin{:});
    
    % Load the training data
    if(sum(strcmp(varargin,'data_loc')))       
        ind = find(strcmp(varargin,'data_loc')) + 1;
        data_loc = varargin{ind};
        data_loc = sprintf(['%s/' data_loc '%s_%s.mat'], trainingLoc, num2str(scale), num2str(view));
    else        
        data_loc = sprintf('%s/wild_%s_%s.mat', trainingLoc, num2str(scale), num2str(view));
    end    
    
    load(data_loc);
    examples = all_images;
    visi_index = visiIndex;       
    
    clear 'all_images'
    
    numPoints = size(landmark_locations,2);
    
    correlations = zeros(1, numPoints);
    rms_errors = zeros(1, numPoints);
    
    patch_experts = zeros(1, numPoints, normalisation_options.patchSize(1)*normalisation_options.patchSize(2)+2);       
    
    for j=1:numPoints
        
        % can only do mirroring if there is no yaw
        if((numPoints == 68 || numPoints == 29 )&& centres(2) == 0)
            % Do not redo a mirror feature (just flip them)
            if(numPoints == 68)
                mirrorInds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
                      32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
                      61,65;62,64;68,66];     
            else
                mirrorInds = [1,2; 3,4; 5,7; 6,8; 9,10; 11,12; 13,15; 14,16; 17,18; 19,20; 23,24];                
            end
            mirror_idx = j;
            if(any(mirrorInds(:,1)==j))
                mirror_idx = mirrorInds(mirrorInds(:,1)==j,2);
            elseif(any(mirrorInds(:,2)==j))
                mirror_idx = mirrorInds(mirrorInds(:,2)==j,1);
            end

            if(mirror_idx~=j & correlations(1,mirror_idx) ~= 0)

                correlations(1,j) = correlations(1,mirror_idx);
                rms_errors(1, j) = rms_errors(1,mirror_idx);
                
                % Bias and scaling are the same
                patch_experts(1, j, 1:2) = patch_experts(1, mirror_idx, 1:2);
                
                % flip the support weights
                w = patch_experts(1, mirror_idx, 3:end);

                w = reshape(w, normalisation_options.patchSize(1), normalisation_options.patchSize(2));
                w = fliplr(w);
                w = reshape(w, normalisation_options.patchSize(1)*normalisation_options.patchSize(2),1);
                
                patch_experts(1, j, 3:end) = w;

                fprintf('Feature %d done\n', j);

                continue;

            end
        end        
        
        if(visi_index(j)) 
            % instead of loading the patches compute them here:
            numSamples = normalisation_options.numSamples;

            [curr_examples, currentLabels, unnormed_samples] = ExtractTrainingSamples(examples, landmark_locations, sigma, normalisation_options.normalisationRegion, normalisation_options.patchSize, numSamples, j, normalisation_options);

            [ patchExpert, correlation, rmsError ] = CreatePatchExpert( curr_examples, currentLabels, unnormed_samples, normalisation_options);

            correlations(1,j) = correlation;
            rms_errors(1, j) = rmsError;
            patch_experts(1, j, :) = patchExpert(:);

            fprintf('Feature %d done\n', j);
        end
    end
    
end