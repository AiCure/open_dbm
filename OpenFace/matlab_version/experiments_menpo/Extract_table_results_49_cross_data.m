clear

load('results/results_clnf_cross-data_general.mat');
load('results/menpo_labels.mat');
[clnf_error, frontal_ids] = compute_error_menpo_small( labels,  experiment.shapes);
clnf_error_frontal = clnf_error(frontal_ids);
clnf_error_profile = clnf_error(~frontal_ids);

load('results/menpo_train_chehra.mat');
[drmf_error, frontal_ids] = compute_error_menpo_small( labels,  shapes);
drmf_error_frontal = drmf_error(frontal_ids);
drmf_error_profile = drmf_error(~frontal_ids);

load('results/menpo_train_sdm.mat');
for i = 1:numel(experiment.shapes)
    shapes{i} = shapes{i}+0.5;
end
[sdm_error, frontal_ids] = compute_error_menpo_small( labels,  shapes);
sdm_error_frontal = sdm_error(frontal_ids);
sdm_error_profile = sdm_error(~frontal_ids);

load('results/Menpo_train_pocr.mat');
[pocr_error, frontal_ids] = compute_error_menpo_small( labels,  experiments.shapes);
pocr_error_frontal = pocr_error(frontal_ids);
pocr_error_profile = pocr_error(~frontal_ids);

load('results/results_ceclm_cross-data.mat');
[ceclm_error, frontal_ids] = compute_error_menpo_small( labels,  experiment.shapes);
ceclm_error_frontal = ceclm_error(frontal_ids);
ceclm_error_profile = ceclm_error(~frontal_ids);


load('results/tcdcn_menpo.mat');
for i = 1:numel(shapes)
    shapes{i} = shapes{i};
end

[tcdcn_error, frontal_ids] = compute_error_menpo_small(labels, shapes);
tcdcn_error_frontal = tcdcn_error(frontal_ids);
tcdcn_error_profile = tcdcn_error(~frontal_ids);

load('results/CFAN_menpo_train.mat');
for i = 1:numel(shapes)
    shapes{i} = shapes{i}-0.5;
end

[cfan_error, frontal_ids] = compute_error_menpo_small(labels, shapes);
cfan_error_frontal = cfan_error(frontal_ids);
cfan_error_profile = cfan_error(~frontal_ids);

load('results/menpo_train_3DDFA.mat');
for i = 1:numel(shapes)
    shapes{i} = shapes{i}-0.5;
end

[error_3ddfa, frontal_ids] = compute_error_menpo_small(labels, shapes);
error_3ddfa_frontal = error_3ddfa(frontal_ids);
error_3ddfa_profile = error_3ddfa(~frontal_ids);

load('results/Menpo-CFSS_train.mat');
shapes = cell(size(estimatedPoseFull,1),1);

for i = 1:numel(shapes)
    shape = cat(2, estimatedPoseFull(i,1:68)', estimatedPoseFull(i,69:end)');
    shapes{i} = shape-0.5;
end

[cfss_error, frontal_ids] = compute_error_menpo_small(labels, shapes);
cfss_error_frontal = cfss_error(frontal_ids);
cfss_error_profile = cfss_error(~frontal_ids);