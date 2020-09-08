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

visiIndex = zeros(7, 68);

root = 'D:/deep_experts/menpo/rmses/';

for s=scales

    for c=1:n_views

        if(c == frontalView || sum(profileViewInds==c)> 0)

            for i=1:n_landmarks

                mirror = false;
                % Find the relevant file
                if(c == frontalView)
                    rel_file = sprintf([root, '/%s_frontal_%d_512.mat'], s{1}, i);
                else                    
                    rel_file = sprintf([root, '/%s_profile%d_%d_512.mat'], s{1}, c-1, i);                    
                end
                if(exist(rel_file, 'file'))
                    visiIndex(c,i) = 1;
                    load(rel_file); 
                else
                   rel_id = mirrorInds(mirrorInds(:,2)==i,1);
                   if(isempty(rel_id))
                       rel_id = mirrorInds(mirrorInds(:,1)==i,2);
                   end
                   if(c == frontalView)                       
                       rel_file = sprintf([root, '/%s_frontal_%d_512.mat'], s{1}, rel_id);
                       mirror = true;
                       visiIndex(c,i) = 1;
                       load(rel_file);
                   end
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
        else

            swap_id = find(centers(:,2) == -centers(c,2));

            corr_T = patch_experts.correlations(swap_id,:);
            % Appending a mirror view instead, based on the profile view               
            corr_T  = swap(corr_T, mirrorInds(:,1), mirrorInds(:,2));
            patch_experts.correlations(c,:) = corr_T;

            vis_T = visiIndex(swap_id,:);
            % Appending a mirror view instead, based on the profile view               
            vis_T  = swap(vis_T, mirrorInds(:,1), mirrorInds(:,2));
            visiIndex(c,:) = vis_T;
            
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
    trainingScale = str2num(s{1});
    save(['cen_patches_', s{1} '_menpo.mat'], 'trainingScale', 'centers', 'visiIndex', 'patch_experts', 'normalisationOptions');
    write_patch_expert_bin(['cen_patches_', s{1} '_menpo.dat'], trainingScale, centers, visiIndex, patch_experts);
end