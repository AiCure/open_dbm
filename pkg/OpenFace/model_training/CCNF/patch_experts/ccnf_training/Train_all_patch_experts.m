function Train_all_patch_experts(trainingLoc, frontalView, profile_views, scaling, sigma, version, varargin)
% need some documentation here

if(sum(strcmp(varargin,'ratio_neg')))
    ind = find(strcmp(varargin,'ratio_neg')) + 1;
    ratio_neg = varargin{ind};
else
    ratio_neg = 20;
end

if(sum(strcmp(varargin,'num_samples')))
    ind = find(strcmp(varargin,'num_samples')) + 1;
    num_samples = varargin{ind};
else
    num_samples = 5e5;
end

patch_experts = struct;
patch_experts.types = {'reg'};
patch_experts.correlations = [];
patch_experts.rms_errors = [];
patch_experts.patch_experts = cell(numel(patch_experts.types), 1);

% first do the frontal view
[visiIndex, centres, patch_experts, imgs_used, norm_options] = ...
    AppendTraining(trainingLoc, frontalView, scaling, sigma, [], [], patch_experts, ratio_neg, num_samples, varargin{:});

fprintf('Frontal done\n');

% now do the profile views
for i=1:numel(profile_views)
    [visiIndex, centres, patch_experts, imgs_used_profile] = ...
        AppendTraining(trainingLoc, profile_views(i), scaling, sigma, visiIndex, centres, patch_experts, ratio_neg, num_samples, varargin{:});
    fprintf('Profile %d done\n', i);
    
    imgs_used = cat(1, imgs_used, imgs_used_profile);

end

% saving time by not retraining mirrored (left/right) views, but just
% filpping the patch expert
for i=1:numel(profile_views)
    [visiIndex, centres, patch_experts] = ...
        AppendMirror(visiIndex, centres, patch_experts, numel(profile_views) - i + 2, varargin{:});
    fprintf('Profile %d done\n', i + numel(profile_views));
end

% output the training
locationTxtCol = sprintf('trained/ccnf_patches_%s_%s.txt', num2str(scaling), version);
locationMlabCol = sprintf('trained/ccnf_patches_%s_%s.mat', num2str(scaling), version);

Write_patch_experts_ccnf(locationTxtCol, locationMlabCol, scaling, centres, visiIndex, patch_experts, norm_options, [7,9,11,15]);

% save the images used
location_imgs_used = sprintf('trained/imgs_used_%s.mat', version);
save(location_imgs_used, 'imgs_used');

end

function [visi_index, centres, patches_m, imgs_used, norm_options] = AppendTraining(training_data_loc, view, scale, sigma, visibilities_init, centres_init, patches_m_init, ratio_neg, num_samples, varargin)
    
    patches_m = patches_m_init;

    [correlations, rms_errors, patch_experts, visi_index, centres, imgs_used, norm_options] = Train_CCNF_patches(training_data_loc, view, scale, sigma, ratio_neg, num_samples, varargin{:});
    
    if(numel(patches_m_init.correlations) > 0)
        patches_m.correlations = cat(1, patches_m_init.correlations, correlations);
        patches_m.rms_errors = cat(1, patches_m_init.rms_errors, rms_errors);
        patches_m.patch_experts = cat(1, patches_m_init.patch_experts, patch_experts);
    else
        patches_m.correlations = correlations;
        patches_m.rms_errors = rms_errors;
        patches_m.patch_experts = patch_experts;
    end
    
    % also add the visibility indices and centres, as that will need to be
    % output to the patch expert when it's written out
    if(numel(visibilities_init) > 0)
        visi_index = cat(1, visibilities_init, visi_index);
        centres = cat(1, centres_init, centres);
    end

end

function [visiIndex, centres, patches_m] = AppendMirror(visiIndexInit, centresInit, patches_m, index, varargin)

    
    if(numel(visiIndexInit) > 0)
        
        corr_T = patches_m.correlations(index,:);
        
        if(numel(corr_T) == 66)
            % this specifies the mirrored points, say 1 in left profile becomes 17
            % in right profile if mirrored, non-mirrored points don't need to be
            % specified, they just get flipped but index remains the same
            mirrorInds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
                      32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
                      61,63;66,64];            
        elseif(numel(corr_T) == 68)
            mirrorInds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
                          32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
                          61,65;62,64;68,66];            
        end
        
        
        corr_T  = swap(corr_T, mirrorInds(:,1), mirrorInds(:,2));
        patches_m.correlations = cat(1, patches_m.correlations, corr_T);
        
        AccT = patches_m.rms_errors(index,:);
        AccT = swap(AccT, mirrorInds(:,1), mirrorInds(:,2));
        patches_m.rms_errors = cat(1, patches_m.rms_errors, AccT);
        
        visiIndexT = visiIndexInit(index,:);                
        visiIndexT = swap(visiIndexT, mirrorInds(:,1), mirrorInds(:,2));
        visiIndex = cat(1, visiIndexInit, visiIndexT);
        
        % mirroring of the orientation involves flipping yaw or roll (we
        % assume only views with one rotation will be present (say only
        % pitch or yaw or roll)
        centresMirror = [centresInit(index,1), -centresInit(index,2), -centresInit(index,3)];        
        centres = cat(1, centresInit, centresMirror);
        
        patchExpertMirror = patches_m.patch_experts(index,:);
        patchExpertMirrorT1 = patchExpertMirror(1,mirrorInds(:,1),:);
        patchExpertMirrorT2 = patchExpertMirror(1,mirrorInds(:,2),:);
        patchExpertMirror(1,mirrorInds(:,2),:) = patchExpertMirrorT1;
        patchExpertMirror(1,mirrorInds(:,1),:) = patchExpertMirrorT2;
        
        % To flip a patch expert it        
        for p=1:size(patchExpertMirror,2)
            if(visiIndexT(p))
                num_hl = size(patchExpertMirror{p}.thetas, 1);
                num_mod = size(patchExpertMirror{p}.thetas, 3);
                for m=1:num_mod
                    for hl=1:num_hl
                        w = reshape(patchExpertMirror{p}.thetas(hl, 2:end, m),11,11);
                        w = fliplr(w);
                        w = reshape(w, 121,1);
                        patchExpertMirror{p}.thetas(hl, 2:end, m) = w;
                    end
                end
            end
        end
        
        patches_m.patch_experts = cat(1, patches_m.patch_experts, patchExpertMirror);
              
    end
end

function arr = swap(arr, ind1, ind2)
    val1 = arr(ind1);
    val2 = arr(ind2);
    arr(ind1) = val2;
    arr(ind2) = val1;
end