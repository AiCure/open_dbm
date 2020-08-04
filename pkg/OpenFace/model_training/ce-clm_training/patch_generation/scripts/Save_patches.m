function [imgs_used, normalisation_options] = Save_patches(training_loc, view, scale, sigma, ratio_neg, num_samples, patches_loc, view_name, varargin)

    % patch generation options
    num_samples = num_samples;

    normalisation_options = struct;
    normalisation_options.patchSize = [11 11];
    if(sum(strcmp(varargin,'normalisation_size')))
        ind = find(strcmp(varargin,'normalisation_size')) + 1;
        normalisation_options.normalisationRegion = [varargin{ind}, varargin{ind}];
    else
        normalisation_options.normalisationRegion = [21 21];
    end
    normalisation_options.rate_negative = ratio_neg;
    normalisation_options.useNormalisedCrossCorr = 1;

    train_test_ratio = 0.9;

    
    if(sum(strcmp(varargin,'data_loc')))       
        ind = find(strcmp(varargin,'data_loc')) + 1;
        data_loc = varargin{ind};
        data_loc = sprintf(['%s/' data_loc '%s_%s.mat'], training_loc, num2str(scale), num2str(view));
    else        
        data_loc = sprintf('%s/wild_%s_%s.mat', training_loc, num2str(scale), num2str(view));
    end    
    
    % location to save generated patches to (for training other patch experts
    % such as CEN)

    fprintf('saving patches to %s\n', patches_loc);
    patches_filename = sprintf('data%.2f_%s.mat', scale, view_name);

    % data_loc should contain landmark_locations, all_images, actual_imgs_used,
    % visiIndex, centres
    load(data_loc);
    examples = all_images;
    landmark_loc = landmark_locations;
    clear 'all_images'    
    
    numPoints = size(landmark_loc,2);
    
    done = zeros(1, numPoints);
    
    for j=1:numPoints
        [status,msg,msgID] = mkdir(sprintf([patches_loc '/%d'], j));
    end

    for j=1:numPoints
        pause(0);
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

            if (mirror_idx ~= j & done(1, mirror_idx) ~= 0)

                fprintf('not generating patches for lm %d, mirrored by %d\n', j, mirror_idx);
                done(1, j) = done(1, mirror_idx);

                fprintf('Feature %d done\n', j);

                continue;

            end
        end
        
        imgs_used = {};
        if(visiIndex(j)) 
            
            tic;
            % instead of loading the patches compute them here:

            [samples, labels, unnormed_samples, imgs_used_n] = ExtractTrainingSamples(examples, landmark_loc, actual_imgs_used, sigma, num_samples, j, normalisation_options);
            imgs_used = union(imgs_used, imgs_used_n);
            % add the bias term
            samples = [ones(1,size(samples,1)); samples'];                  
            
            region_length = normalisation_options.normalisationRegion - normalisation_options.patchSize + 1;
            region_length = region_length(1) * region_length(2);
                        
            num_examples = size(samples, 2);

            % this part sets the split boundaries for training and test subsets
            train_ccnf_start = 1;
            train_ccnf_end = int32(train_test_ratio * num_examples - 1);
            % make sure we don't split a full training region apart
            train_ccnf_end = train_ccnf_end - mod(train_ccnf_end, region_length);

            test_start = train_ccnf_end + 1;
            test_end = size(samples,2);

            samples_train = samples(:,train_ccnf_start:train_ccnf_end);
            labels_train = labels(train_ccnf_start:train_ccnf_end);

            samples_test = samples(:,test_start:test_end);                                                
            labels_test = labels(test_start:test_end);
            
            filename = sprintf([patches_loc '/%s/' patches_filename], num2str(j));
            save(filename, 'samples_train', 'labels_train', 'samples_test', 'labels_test', '-v7.3');

            done(1, j) = 1;

            fprintf('Landmark %d done\n', j);
            clear samples
            clear samples_test
            clear samples_train
            clear labels
            clear unnormed_samples
            clear imgs_used_n
            toc;
        end
    end
    
end
