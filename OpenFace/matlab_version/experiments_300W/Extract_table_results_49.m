clear

%% 
inds_ibug = 562:696;

load('./results/results_clnf_wild.mat');
labels = experiment.labels([1:60,62:64,66:end],:,:);
shapes = experiment.shapes([1:60,62:64,66:end],:,:);
labels = labels(18:end,:,:);
shapes = shapes(18:end,:,:);

clnf_error_ibug = compute_error( labels(:,:,inds_ibug),  shapes(:,:,inds_ibug) + 1.0);

load('./results/results_ceclm_menpo.mat');

labels = experiment.labels([1:60,62:64,66:end],:,:);
shapes = experiment.shapes([1:60,62:64,66:end],:,:);
labels = labels(18:end,:,:);
shapes = shapes(18:end,:,:);

ceclm_error_ibug = compute_error( labels(:,:,inds_ibug),  shapes(:,:,inds_ibug) + 1.0);

load('results/zhu_wild.mat');
labels_all = labels_all(18:end,:,:);
shapes_all = shapes_all(18:end,:,:);

tsm_error_ibug = compute_error(labels_all(:,:,inds_ibug), shapes_all(:,:,inds_ibug));

load('results/CFAN_300W.mat');
shapes_all = shapes_all([1:60,62:64,66:end],:,:);
shapes_all = shapes_all(18:end,:,:);
labels_all = labels_all([1:60,62:64,66:end],:,:);
labels_all = labels_all(18:end,:,:);

cfan_error_ibug = compute_error(labels_all(:,:,inds_ibug), shapes_all(:,:,inds_ibug)+1.0);

load('./results/results_clm.mat');
labels = experiment.labels([1:60,62:64,66:end],:,:);
shapes = experiment.shapes([1:60,62:64,66:end],:,:);
labels = labels(18:end,:,:);
shapes = shapes(18:end,:,:);
clm_error_ibug = compute_error( labels(:,:,inds_ibug),  shapes(:,:,inds_ibug) + 1.0);

load('results/300W_3DDFA.mat');
shapes = shapes([1:60,62:64,66:end],:,:);
shapes = shapes(18:end,:,:);
error_3ddfa_ibug = compute_error( labels_all(:,:,inds_ibug),  shapes(:,:,inds_ibug) + 1.0);

load('results/drmf_wild.mat');
labels_all = labels_all(18:end,:,:);
shapes_all = shapes_all(18:end,:,:);

drmf_error_ibug = compute_error(labels_all(:,:,inds_ibug), shapes_all(:,:,inds_ibug));

load('results/300W_sdm.mat');
shapes_all = experiments.shapes;

sdm_error_ibug = compute_error(labels_all(:,:,inds_ibug), shapes_all(:,:,inds_ibug)+1.5);

load('results/300W_pocr.mat');
shapes_all = experiments.shapes;

po_cr_error_ibug = compute_error(labels_all(:,:,inds_ibug), shapes_all(:,:,inds_ibug) + 1.0);

load('results/300W-CFSS.mat');

shapes = zeros(size(estimatedPose,2)/2,2,size(estimatedPose,1));
for i=1:size(estimatedPose,1)
    xs = estimatedPose(i,1:end/2);
    ys = estimatedPose(i,end/2+1:end);
    shapes(:,1,i) = xs;
    shapes(:,2,i) = ys;
end
shapes = shapes([1:60,62:64,66:end],:,:);
shapes = shapes(18:end,:,:);

cfss_error_ibug = compute_error(labels_all(:,:,inds_ibug), shapes(:,:,inds_ibug)+0.5);

load('results/tcdcn_300W.mat');
shapes_c = shapes;
shapes = zeros(68,2,numel(shapes));
for i=1:numel(shapes_c)
    xs = shapes_c{i}(:,1);
    ys = shapes_c{i}(:,2);
    shapes(:,1,i) = xs;
    shapes(:,2,i) = ys;
end
shapes = shapes([1:60,62:64,66:end],:,:);
shapes = shapes(18:end,:,:);

tcdcn_error_ibug = compute_error(labels_all(:,:,inds_ibug), shapes(:,:,inds_ibug)+0.5);

%% 
inds_comm = [338:561,697:1026];

load('./results/results_clnf_wild.mat');
labels = experiment.labels([1:60,62:64,66:end],:,:);
shapes = experiment.shapes([1:60,62:64,66:end],:,:);
labels = labels(18:end,:,:);
shapes = shapes(18:end,:,:);

clnf_error_comm = compute_error( labels(:,:,inds_comm),  shapes(:,:,inds_comm) + 1.0);

load('./results/results_ceclm_menpo.mat');
labels = experiment.labels([1:60,62:64,66:end],:,:);
shapes = experiment.shapes([1:60,62:64,66:end],:,:);
labels = labels(18:end,:,:);
shapes = shapes(18:end,:,:);

ceclm_error_comm = compute_error( labels(:,:,inds_comm),  shapes(:,:,inds_comm) + 1.0);

load('results/zhu_wild.mat');
labels_all = labels_all(18:end,:,:);
shapes_all = shapes_all(18:end,:,:);

tsm_error_comm = compute_error(labels_all(:,:,inds_comm), shapes_all(:,:,inds_comm));

load('./results/results_clm.mat');
labels = experiment.labels([1:60,62:64,66:end],:,:);
shapes = experiment.shapes([1:60,62:64,66:end],:,:);
labels = labels(18:end,:,:);
shapes = shapes(18:end,:,:);
clm_error_comm = compute_error( labels(:,:,inds_comm),  shapes(:,:,inds_comm) + 1.0);

load('results/300W_3DDFA.mat');
shapes = shapes([1:60,62:64,66:end],:,:);
shapes = shapes(18:end,:,:);
error_3ddfa_comm = compute_error( labels_all(:,:,inds_comm),  shapes(:,:,inds_comm)+1.0);

load('results/drmf_wild.mat');
labels_all = labels_all(18:end,:,:);
shapes_all = shapes_all(18:end,:,:);

drmf_error_comm = compute_error(labels_all(:,:,inds_comm), shapes_all(:,:,inds_comm));

load('results/300W_sdm.mat');
shapes_all = experiments.shapes;

sdm_error_comm = compute_error(labels_all(:,:,inds_comm), shapes_all(:,:,inds_comm)+1.5);

load('results/300W_pocr.mat');
shapes_all = experiments.shapes;

po_cr_error_comm = compute_error(labels_all(:,:,inds_comm), shapes_all(:,:,inds_comm) + 1.0);

load('results/300W-CFSS.mat');

shapes = zeros(size(estimatedPose,2)/2,2,size(estimatedPose,1));
for i=1:size(estimatedPose,1)
    xs = estimatedPose(i,1:end/2);
    ys = estimatedPose(i,end/2+1:end);
    shapes(:,1,i) = xs;
    shapes(:,2,i) = ys;
end
shapes = shapes([1:60,62:64,66:end],:,:);
shapes = shapes(18:end,:,:);

cfss_error_comm = compute_error(labels_all(:,:,inds_comm), shapes(:,:,inds_comm)+0.5);

load('results/tcdcn_300W.mat');
shapes_c = shapes;
shapes = zeros(68,2,numel(shapes));
for i=1:numel(shapes_c)
    xs = shapes_c{i}(:,1);
    ys = shapes_c{i}(:,2);
    shapes(:,1,i) = xs;
    shapes(:,2,i) = ys;
end
shapes = shapes([1:60,62:64,66:end],:,:);
shapes = shapes(18:end,:,:);
tcdcn_error_comm = compute_error(labels_all(:,:,inds_comm), shapes(:,:,inds_comm)+0.5);