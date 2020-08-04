function Collect_patches_view(training_loc, view, scale, sigma, ratio_neg, num_samples, profile_id, version, varargin)
%% creating the model   
    % creating the regression models

    normalisation_options = Parse_settings( sigma, ratio_neg, num_samples, varargin{:});    
    
    if(sum(strcmp(varargin,'data_loc')))       
        ind = find(strcmp(varargin,'data_loc')) + 1;
        data_loc = varargin{ind};
        data_loc = sprintf(['%s\\' data_loc '%s_%s.mat'], training_loc, num2str(scale), num2str(view));
    else        
        data_loc = sprintf('%s\\wild_%s_%s.mat', training_loc, num2str(scale), num2str(view));
    end    
    
    load(data_loc);
    examples = all_images;
    landmark_loc = landmark_locations;
    clear 'all_images'    
    
    numPoints = size(landmark_loc,2);
    done = false(numPoints,1);
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
            if(mirror_idx~=j & done(mirror_idx))

                continue;

            end
        end
        
        imgs_used = {};
        if(visiIndex(j)) 
            
            tic;
            % instead of loading the patches compute them here:
            num_samples = normalisation_options.numSamples;

            [samples, labels, imgs_used_n] = ExtractTrainingSamples(examples, landmark_loc, actual_imgs_used, sigma, num_samples, j, normalisation_options);
            imgs_used = union(imgs_used, imgs_used_n);
            % add the bias term
            samples = [ones(1,size(samples,1)); samples'];                  
            if(centres(2) == 0)
                save(sprintf('E:/menpo_data/%s_data%.2f_frontal_%d.mat', version, scale, j), 'samples', 'labels', '-v7.3');
            else
                save(sprintf('E:/menpo_data/%s_data%.2f_profile%d_%d.mat', version, scale, profile_id, j), 'samples', 'labels', '-v7.3');
            end
            fprintf('Landmark %d done\n', j);
            clear samples            
            clear labels
            done(j) = true;
        end
    end
    
end