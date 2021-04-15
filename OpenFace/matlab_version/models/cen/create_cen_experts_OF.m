clear;
%%
mirrorInds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
61,65;62,64;68,66];   

mirror_inds = [1:68];
mirror_inds(mirrorInds(:,1)) = mirrorInds(:,2);
mirror_inds(mirrorInds(:,2)) = mirrorInds(:,1);

scales = {'0.50', '1.00'};

for s=scales

    gen_experts = load(sprintf('cen_patches_%s_general.mat', s{1}));
    load(sprintf('cen_patches_%s_menpo.mat', s{1}));
    
    for c=1:size(visiIndex,1)
        for i=1:size(visiIndex,2)
            % If present in general and not menpo replace
            if(gen_experts.visiIndex(c,i) && ~visiIndex(c,i))
                visiIndex(c,i) = 1;
                patch_experts.correlations(c,i) = gen_experts.patch_experts.correlations(c,i);
                patch_experts.rms_errors(c,i) = gen_experts.patch_experts.rms_errors(c,i);
                patch_experts.patch_experts(c,i) = gen_experts.patch_experts.patch_experts(c,i);
            elseif(~visiIndex(c,i))
                patch_experts.correlations(c,i) = 0;
                patch_experts.rms_errors(c,i) = 0;
                patch_experts.patch_experts(c,i) = {[]}; 
            end
                
        end
    end
    
    trainingScale = str2num(s{1});
    save(['cen_patches_', s{1} '_of.mat'], 'trainingScale', 'centers', 'visiIndex', 'patch_experts', 'normalisationOptions');

    % Work out the frontal view and remove mirror indices for it
    [~, frontal] = min(mean(abs(bsxfun(@plus, centers, [0,0,0])')));

    % First clean up the frontal view
    patch_experts.patch_experts(frontal, mirrorInds(:,2)) = {[]};

    % Work out which views have mirrors of each other, and keep only one set
    % of them
    n_views = size(visiIndex,1);

    mirror_view = 1:n_views;

    for i = 1:n_views
        [~, mirror_view(i)] = min(mean(abs(bsxfun(@plus, centers, centers(i,:))')));
    end

    % Remove a set of mirror indices
    to_rem = mirror_view < 1:n_views;

    patch_experts.patch_experts(to_rem, :) = {[]};

    trainingScale = str2num(s{1});
    write_patch_expert_bin_simple(['cen_patches_', s{1} '_of.dat'], trainingScale, centers, visiIndex, patch_experts, mirror_inds - 1, mirror_view - 1);

end

scales = {'0.25', '0.35'};

for s=scales

    gen_experts = load(sprintf('cen_patches_%s_general_model_half.mat', s{1}));
    load(sprintf('cen_patches_%s_menpo_model_half.mat', s{1}));
    
    for c=1:size(visiIndex,1)
        for i=1:size(visiIndex,2)
            % If present in general and not menpo replace
            if(gen_experts.visiIndex(c,i) && ~visiIndex(c,i))
                visiIndex(c,i) = 1;
                patch_experts.correlations(c,i) = gen_experts.patch_experts.correlations(c,i);
                patch_experts.rms_errors(c,i) = gen_experts.patch_experts.rms_errors(c,i);
                patch_experts.patch_experts(c,i) = gen_experts.patch_experts.patch_experts(c,i);
            elseif(~visiIndex(c,i))
                patch_experts.correlations(c,i) = 0;
                patch_experts.rms_errors(c,i) = 0;
                patch_experts.patch_experts(c,i) = {[]}; 
            end
                
        end
    end
    
    trainingScale = str2num(s{1});
    save(['cen_patches_', s{1} '_of.mat'], 'trainingScale', 'centers', 'visiIndex', 'patch_experts', 'normalisationOptions');

    % Work out the frontal view and remove mirror indices for it
    [~, frontal] = min(mean(abs(bsxfun(@plus, centers, [0,0,0])')));

    % First clean up the frontal view
    patch_experts.patch_experts(frontal, mirrorInds(:,2)) = {[]};

    % Work out which views have mirrors of each other, and keep only one set
    % of them
    n_views = size(visiIndex,1);

    mirror_view = 1:n_views;

    for i = 1:n_views
        [~, mirror_view(i)] = min(mean(abs(bsxfun(@plus, centers, centers(i,:))')));
    end

    % Remove a set of mirror indices
    to_rem = mirror_view < 1:n_views;

    patch_experts.patch_experts(to_rem, :) = {[]};

    trainingScale = str2num(s{1});
    write_patch_expert_bin_simple(['cen_patches_', s{1} '_of.dat'], trainingScale, centers, visiIndex, patch_experts, mirror_inds - 1, mirror_view - 1);

end