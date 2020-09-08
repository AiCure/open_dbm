clear;
load('../general/ccnf_patches_0.25_general.mat', 'centers', 'visiIndex', 'normalisationOptions');

mirrorInds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
  32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
  61,65;62,64;68,66];   

% For mirroring
frontalView = 1;
profileViewInds = [2,3,4];

% Grab all related experts and mirror them appropriatelly, just need to
% mirror the first layer

non_mirrored = mirrorInds(:,1);
normalisationOptions = rmfield(normalisationOptions, 'ccnf_ratio');
normalisationOptions.dccnf = true;

n_landmarks = size(visiIndex, 2);
n_views = size(visiIndex, 1);

patch_experts.correlations = zeros(n_views, n_landmarks);
patch_experts.rms_errors = zeros(n_views, n_landmarks);
patch_experts.types = {'reg'};
patch_experts.patch_experts = cell(n_views, n_landmarks);

scales = {'0.25', '0.35', '0.50', '1.00'};
visiIndex_full = visiIndex;

to_rem_from = [1,2,3,6,7];
to_rem_1 = [4;68;58;62;51;6;59;20;63;53;25;56;14;64;9;67;2;33;11;37;17;52;26;60;28;34;44;38;29;8;21;15;12;18];
to_rem_2 = [6;62;50;25;59;20;17;66;64;57;39;14;12;68;41;45;34;43;30;60;4;29;1;61;47;9;65;52;37;22;15;35;54;58];
to_rem_3 = [66;62;54;60;38;5;30;13;28;59;44;67;41;57;25];

for s=scales
    
    visiIndex = visiIndex_full;
    
    for c=1:n_views

        if(c == frontalView || sum(profileViewInds==c)> 0)

            for i=1:n_landmarks

                if(visiIndex(c,i))
                    mirror = false;
                    % Find the relevant file
                    if(c == frontalView)
                        rel_file = sprintf('D:/deep_experts/rmses/MultiGeneral_arch4general_%s_frontal_%d_512.mat', s{1}, i);
                    else
                        rel_file = sprintf('D:/deep_experts/rmses/MultiGeneral_arch4general_%s_profile%d_%d_512.mat', s{1}, c-1, i);                    
                    end
                    if(exist(rel_file, 'file'))
                       load(rel_file); 
                    else
                       rel_id = mirrorInds(mirrorInds(:,2)==i,1);
                       if(isempty(rel_id))
                           rel_id = mirrorInds(mirrorInds(:,1)==i,2);
                       end
                       if(~visiIndex(c, rel_id))
                           break;
                       end
                       if(c == frontalView)
                           rel_file = sprintf('D:/deep_experts/rmses/MultiGeneral_arch4general_%s_frontal_%d_512.mat', s{1}, rel_id);
                       else
                           rel_file = sprintf('D:/deep_experts/rmses/MultiGeneral_arch4general_%s_profile%d_%d_512.mat', s{1}, c-1, rel_id);                    
                       end
                       mirror = true;
                       load(rel_file);
                    end
                    patch_experts.correlations(c, i) = correlation_2;
                    patch_experts.rms_errors(c, i) = rmse;

                    if(~mirror)
                        patch_experts.patch_experts{c, i} = weights;
                    else
                        flips = fliplr(reshape([1:121]', 11, 11));
                        weights_flipped = weights;
                        weights_flipped{1}(2:end,:) = weights{1}(flips+1,:);
                        patch_experts.patch_experts{c,i} = weights_flipped;
                    end
                end

            end
        else

            swap_id = find(centers(:,2) == -centers(c,2));

            corr_T = patch_experts.correlations(swap_id,:);
            % Appending a mirror view instead, based on the profile view               
            corr_T  = swap(corr_T, mirrorInds(:,1), mirrorInds(:,2));
            patch_experts.correlations(c,:) = corr_T;

            rmsT = patch_experts.rms_errors(swap_id,:);
            rmsT = swap(rmsT, mirrorInds(:,1), mirrorInds(:,2));
            patch_experts.rms_errors(c,:) = rmsT;

            patchExpertMirror = patch_experts.patch_experts(swap_id,:);
            patchExpertMirrorT1 = patchExpertMirror(1,mirrorInds(:,1),:);
            patchExpertMirrorT2 = patchExpertMirror(1,mirrorInds(:,2),:);
            patchExpertMirror(1,mirrorInds(:,2),:) = patchExpertMirrorT1;
            patchExpertMirror(1,mirrorInds(:,1),:) = patchExpertMirrorT2;

            % To flip a patch expert it        
            for p=1:size(patchExpertMirror,2)
                if(visiIndex(c, p))
                    weights = patchExpertMirror{p};
                    flips = fliplr(reshape([1:121]', 11, 11));
                    weights_flipped = weights;
                    weights_flipped{1}(2:end,:) = weights{1}(flips+1,:);
                    patch_experts.patch_experts{c,p} = weights_flipped;
                end
            end

        end
    end
    
    if(strcmp('0.25', s))
        visiIndex(to_rem_from, to_rem_1) = 0;
        patch_experts.correlations(to_rem_from, to_rem_1) = 0;
        patch_experts.rms_errors(to_rem_from, to_rem_1) = 0;
        patch_experts.patch_experts(to_rem_from, to_rem_1) = {[]};
    end
    if(strcmp('0.35', s))
        visiIndex(to_rem_from, to_rem_2) = 0;
        patch_experts.correlations(to_rem_from, to_rem_2) = 0;
        patch_experts.rms_errors(to_rem_from, to_rem_2) = 0;
        patch_experts.patch_experts(to_rem_from, to_rem_2) = {[]};
    end        
    if(strcmp('0.50', s))
        visiIndex(to_rem_from, to_rem_3) = 0;
        patch_experts.correlations(to_rem_from, to_rem_3) = 0;
        patch_experts.rms_errors(to_rem_from, to_rem_3) = 0;
        patch_experts.patch_experts(to_rem_from, to_rem_3) = {[]};
    end 
    
    trainingScale = str2num(s{1});
    save(['cen_patches_', s{1} '_general_sparse.mat'], 'trainingScale', 'centers', 'visiIndex', 'patch_experts', 'normalisationOptions');
    write_patch_expert_bin(['cen_patches_', s{1} '_general_sparse.dat'], trainingScale, centers, visiIndex, patch_experts);
end