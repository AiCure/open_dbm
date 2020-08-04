function [correlations, rmsErrors, patchExperts, visiIndex, centres, imgs_used, normalisation_options] = Train_CCNF_patches(training_loc, view, scale, sigma, ratio_neg, num_samples, varargin)
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
    
    correlations = zeros(1, numPoints);
    rmsErrors = zeros(1, numPoints);
    patchExperts = cell(1, numPoints);    
    
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

            if(mirror_idx~=j & correlations(1,mirror_idx) ~= 0)

                correlations(1,j) = correlations(1,mirror_idx);
                rmsErrors(1, j) = rmsErrors(1,mirror_idx);
                patchExperts{1, j} = patchExperts{1,mirror_idx};

                num_hl = size(patchExperts{1,mirror_idx}.thetas, 1);
                num_mod = size(patchExperts{1,mirror_idx}.thetas, 3);
                for m=1:num_mod
                    for hl=1:num_hl
                        w = reshape(patchExperts{1,mirror_idx}.thetas(hl, 2:end, m),11,11);
                        w = fliplr(w);
                        w = reshape(w, 121,1);
                        patchExperts{1, j}.thetas(hl, 2:end, m) = w;
                    end
                end

                fprintf('Feature %d done\n', j);

                continue;

            end
        end
        
        imgs_used = {};
        if(visiIndex(j)) 
            
            tic;
            % instead of loading the patches compute them here:
            num_samples = normalisation_options.numSamples;

            [samples, labels, unnormed_samples, imgs_used_n] = ExtractTrainingSamples(examples, landmark_loc, actual_imgs_used, sigma, num_samples, j, normalisation_options);
            imgs_used = union(imgs_used, imgs_used_n);
            % add the bias term
            samples = [ones(1,size(samples,1)); samples'];                  
            
            region_length = normalisation_options.normalisationRegion - normalisation_options.patchSize + 1;
            region_length = region_length(1) * region_length(2);
                        
            num_examples = size(samples, 2);

            % this part sets the split boundaries for training and test subsets
            train_ccnf_start = 1;
            train_ccnf_end = int32(normalisation_options.ccnf_ratio * num_examples - 1);
            % make sure we don't split a full training region apart
            train_ccnf_end = train_ccnf_end - mod(train_ccnf_end, region_length);

            test_start = train_ccnf_end + 1;
            test_end = size(samples,2);

            samples_train = samples(:,train_ccnf_start:train_ccnf_end);
            labels_train = labels(train_ccnf_start:train_ccnf_end);

            samples_test = samples(:,test_start:test_end);                                                
            labels_test = labels(test_start:test_end);
            
            % Set up the patch expert
            similarity_types = normalisation_options.similarity_types;    
            patch_expert.similarity_types = similarity_types;
            patch_expert.sparsity = normalisation_options.sparsity;
            patch_expert.sparsity_types = normalisation_options.sparsity_types;
            patch_expert.patch_expert_type = 'CCNF';
                        
            % The actual regressor training
            [alpha, betas, thetas, similarities, sparsities] = Create_CCNF_Regressor(samples_train, labels_train, region_length, similarity_types, normalisation_options.sparsity_types, normalisation_options);

            % The learned patch expert
            patch_expert.alphas = alpha;
            patch_expert.betas = betas;
            patch_expert.thetas = thetas;


            % if we have a SigmaInv, we don't need betas anymore (or
            % similarity and sparsity functions for that matter), compute
            % in a single sample for efficiency
            [ ~, ~, Precalc_Bs_flat, ~ ] = CalculateSimilarities( 1, zeros(size(samples,1),region_length), similarities, sparsities, labels_train(1:region_length), true);
            Precalc_B_flat = Precalc_Bs_flat{1};
            SigmaInv = CalcSigmaCCNFflat(patch_expert.alphas, patch_expert.betas, region_length, Precalc_B_flat, eye(region_length), zeros(region_length));
            patch_expert.SigmaInv = SigmaInv;

            % Evaluate the patch expert
            [rmsError, corr,~] = EvaluatePatchExpert(samples_test, labels_test, alpha, betas, thetas, similarities, sparsities, normalisation_options, region_length);

            fprintf('Rms error %.3f, correlation %.3f\n', rmsError, corr);

            % Assert that our normalisation and different fitting are equivalent
%             normed_samples = samples(:,1:size(unnormed_samples,1)*region_length);
%             [~, ~, responses_ccnf] = EvaluatePatchExpert(normed_samples, labels(1:size(unnormed_samples,1)*region_length), alpha, betas, thetas, similarities, sparsities, normalisation_options, region_length);
%             [responses_ccnf_ncc] = CCNF_ncc_response(unnormed_samples, patch_expert, normalisation_options, normalisation_options.normalisationRegion, region_length);
%             assert(norm(responses_ccnf-responses_ccnf_ncc)< 10e-1);

            correlations(1,j) = corr;
            rmsErrors(1, j) = rmsError;
            patchExperts{1, j} = patch_expert(:);

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