function Train_all(trainingLoc, frontalView, profile_views, up_down_views, scaling, sigma, version, varargin)

%% Set up some default values if not defined
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

if(sum(strcmp(varargin,'patch_types')))
    ind = find(strcmp(varargin,'patch_types')) + 1;
    patch_types = varargin{ind};
else
    patch_types = {'reg', 'grad'};
end
    
if(any(strcmp(varargin,'mirror_view_inds')))
    ind = find(strcmp(varargin,'mirror_view_inds')) + 1;
    mirror_view_inds = varargin{ind};
else
    mirror_view_inds = [];
end

patches_m = struct;
patches_m.types = patch_types;
patches_m.correlations = cell(numel(patch_types), 1);
patches_m.rms_errors = cell(numel(patch_types), 1);
patches_m.patch_experts = cell(numel(patch_types), 1);

% first do the frontal view
[visiIndex, centres, patches_m, norm_options] = ...
    AppendTraining(trainingLoc, frontalView, scaling, sigma, [], [], patches_m, ratio_neg, num_samples, varargin{:});

fprintf('Frontal done\n');

% The mirrored views
for i=1:numel(mirror_view_inds)
    [visiIndex, centres, patches_m] = ...
        AppendTraining(trainingLoc, mirror_view_inds(i), scaling, sigma, visiIndex, centres, patches_m, ratio_neg, num_samples, varargin{:}, 'mirror');
    fprintf('Mirrored view %d done\n', i);
end

% now do the profile views

for i=1:numel(profile_views)
    [visiIndex, centres, patches_m] = ...
        AppendTraining(trainingLoc, profile_views(i), scaling, sigma, visiIndex, centres, patches_m, ratio_neg, num_samples, varargin{:});
    fprintf('Profile %d done\n', i);
    
end

% saving time by not retraining mirrored (left/right) views, but just
% filpping the patch expert
for i=1:numel(profile_views)
    [visiIndex, centres, patches_m] = ...
        AppendMirror(visiIndex, centres, patches_m, numel(profile_views) - i + 2, varargin{:});
    fprintf('Profile %d done\n', i + numel(profile_views));
end

% The up/down views
for i=1:numel(up_down_views)
    [visiIndex, centres, patches_m] = ...
        AppendTraining(trainingLoc, up_down_views(i), scaling, sigma, visiIndex, centres, patches_m, ratio_neg, num_samples, varargin{:});
    fprintf('Up down view %d done\n', i);
end

patches_m.patch_expert_type = 'SVR';

% output the training
locationTxtCol = sprintf('trained/svr_patches_%s_%s.txt', num2str(scaling), version);
locationMlabCol = sprintf('trained/svr_patches_%s_%s.mat', num2str(scaling), version);

Write_patch_experts_multi_modal(locationTxtCol, locationMlabCol, scaling, centres, visiIndex, patches_m, norm_options);

end

function [visi_index, centres, patches_m, norm_options] = AppendTraining(training_data_loc, view, scale, sigma, visibilities_init, centres_init, patches_m_init, ratio_neg, num_samples, varargin)
    
    patches_m = patches_m_init;

    for i=1:numel(patches_m.types)

        [correlations, rms_errors, patch_experts, visi_index, centres, norm_options] = TrainPatchExperts(training_data_loc, view, scale, sigma, patches_m.types{i}, ratio_neg, num_samples, varargin{:});
        
        if(numel(patches_m_init.correlations{i}) > 0)
            patches_m.correlations{i} = cat(1, patches_m_init.correlations{i}, correlations);
            patches_m.rms_errors{i} = cat(1, patches_m_init.rms_errors{i}, rms_errors);
            patches_m.patch_experts{i} = cat(1, patches_m_init.patch_experts{i}, patch_experts);
        else
            patches_m.correlations{i} = correlations;
            patches_m.rms_errors{i} = rms_errors;
            patches_m.patch_experts{i} = patch_experts;
        end
    end
    
    % also add the visibility indices and centres, as that will need to be
    % output to the patch expert when it's written out
    if(numel(visibilities_init) > 0)
        visi_index = cat(1, visibilities_init, visi_index);
        centres = cat(1, centres_init, centres);
    end

end

function [visiIndex, centres, patches_m] = AppendMirror(visiIndexInit, centresInit, patches_m, index, varargin)

    % this specifies the mirrored points, say 1 in left profile becomes 17
    % in right profile if mirrored, non-mirrored points don't need to be
    % specified, they just get flipped but index remains the same
    mirrorInds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
              32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
              61,63;66,64];

    
    if(numel(visiIndexInit) > 0)
        
        for i=1:numel(patches_m.types)
            corr_T = patches_m.correlations{i}(index,:);
            corr_T  = swap(corr_T, mirrorInds(:,1), mirrorInds(:,2)); 
            patches_m.correlations{i} = cat(1, patches_m.correlations{i}, corr_T);

            AccT = patches_m.rms_errors{i}(index,:);                
            AccT = swap(AccT, mirrorInds(:,1), mirrorInds(:,2));        
            patches_m.rms_errors{i} = cat(1, patches_m.rms_errors{i}, AccT);     

            patchExpertMirror = patches_m.patch_experts{i}(index,:,:);
            patchExpertMirrorT1 = patchExpertMirror(1,mirrorInds(:,1),:);
            patchExpertMirrorT2 = patchExpertMirror(1,mirrorInds(:,2),:);
            patchExpertMirror(1,mirrorInds(:,2),:) = patchExpertMirrorT1;
            patchExpertMirror(1,mirrorInds(:,1),:) = patchExpertMirrorT2;

            % To flip a patch expert it 
            for p=1:size(patchExpertMirror,2)
                patchExpertMirror(1,p,3:end) = reshape(fliplr(reshape(patchExpertMirror(1,p,3:end),11,11)),121,1);
            end

            patches_m.patch_experts{i} = cat(1, patches_m.patch_experts{i}, patchExpertMirror);
            
        end
      
        visiIndexT = visiIndexInit(index,:);                
        visiIndexT = swap(visiIndexT, mirrorInds(:,1), mirrorInds(:,2));
        visiIndex = cat(1, visiIndexInit, visiIndexT);
        
        % mirroring of the orientation involves flipping yaw or roll (we
        % assume only views with one rotation will be present (say only
        % pitch or yaw or roll)
        centresMirror = [centresInit(index,1), -centresInit(index,2), -centresInit(index,3)];        
        centres = cat(1, centresInit, centresMirror);
        
    end
end

function arr = swap(arr, ind1, ind2)
    val1 = arr(ind1);
    val2 = arr(ind2);
    arr(ind1) = val2;
    arr(ind2) = val1;
end