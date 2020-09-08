clear

pocr_dir = 'D:\Dropbox\Dropbox\AAM\3rd party models\PO-CR\300VW_mtcnn/';
cfss_dir = 'D:\Dropbox\Dropbox\AAM\3rd party models\CVPR15-CFSS-master\CVPR15-CFSS-master\300VW_mtcnn/';
iccr_dir = 'D:\demo_iccr\iCCR\iCCR\out_300VW/';
chehra_dir = 'D:\Datasets\300VW_Dataset_2015_12_14\chehra_out_mtcnn/';
sdm_dir = 'D:\Datasets\300VW_Dataset_2015_12_14\sdm_out_mtcnn/';
cfan_dir = 'D:\Datasets\300VW_Dataset_2015_12_14\CFAN_mtcnn/';

%% Gather predictions and ground truth
cat_1 = [ 114, 124, 125, 126, 150, 158, 401, 402, 505, 506, 507, 508, 509, 510, 511, 514, 515, 518, 519, 520, 521, 522, 524, 525, 537, 538, 540, 541, 546, 547, 548];
cat_2 = [203, 208, 211, 212, 213, 214, 218, 224, 403, 404, 405, 406, 407, 408, 409, 412, 550, 551, 553];
cat_3 = [410, 411, 516, 517, 526, 528, 529, 530, 531, 533, 557, 558, 559, 562];

%%

cfss_preds = zeros(68,2,0);
iccr_preds = zeros(66,2,0);
clnf_preds = zeros(68,2,0);
cfan_preds = zeros(68,2,0);
sdm_preds = zeros(49,2,0);
drmf_preds = zeros(49,2,0);
pocr_preds = zeros(49,2,0);

labels = zeros(68,2,0);
% Load results
for i=cat_1
    
    load(['CLNF_res_general/', num2str(i)]);    
    clnf_preds = cat(3, clnf_preds, preds);

    labels = cat(3, labels, gt_landmarks);    
    load([cfss_dir,  num2str(i)]);
    cfss_preds = cat(3, cfss_preds, preds);    

    load([cfan_dir,  num2str(i)]);
    cfan_preds = cat(3, cfan_preds, preds);   
    
    load([iccr_dir,  num2str(i)]);
    iccr_preds = cat(3, iccr_preds, pred_landmarks);    
    
    load([chehra_dir,  num2str(i)]);
    drmf_preds = cat(3, drmf_preds, preds);    
    
    load([pocr_dir,  num2str(i)]);
    pocr_preds = cat(3, pocr_preds, preds); 
end

% As ICCR uses only 66 landmarks adapt all the others to the same format
labels = labels([1:60,62:64,66:end],:,:);
clnf_preds = clnf_preds([1:60,62:64,66:end],:,:);
cfss_preds = cfss_preds([1:60,62:64,66:end],:,:);
cfan_preds = cfan_preds([1:60,62:64,66:end],:,:);

clnf_error_66_cat_1 = compute_error(labels, clnf_preds);
cfss_error_66_cat_1 = compute_error(labels, cfss_preds - 0.5);
cfan_error_66_cat_1 = compute_error(labels, cfan_preds - 1.0);
iccr_error_66_cat_1 = compute_error(labels, iccr_preds);

% Do the 49 point version
labels = labels(18:end,:,:);

clnf_preds = clnf_preds(18:end,:,:);
cfan_preds = cfan_preds(18:end,:,:);
cfss_preds = cfss_preds(18:end,:,:);
iccr_preds = iccr_preds(18:end,:,:);

clnf_error_49_cat_1 = compute_error(labels, clnf_preds);
cfss_error_49_cat_1 = compute_error(labels, cfss_preds - 0.5);
cfan_error_49_cat_1 = compute_error(labels, cfan_preds - 1.0);
iccr_error_49_cat_1 = compute_error(labels, iccr_preds);
drmf_error_49_cat_1 = compute_error(labels, drmf_preds-0.5);
pocr_error_49_cat_1 = compute_error(labels, pocr_preds);

%%

cfss_preds = zeros(68,2,0);
iccr_preds = zeros(66,2,0);
clnf_preds = zeros(68,2,0);
cfan_preds = zeros(68,2,0);
sdm_preds = zeros(49,2,0);
drmf_preds = zeros(49,2,0);
pocr_preds = zeros(49,2,0);

labels = zeros(68,2,0);
% Load results
for i=cat_2
    
    load(['CLNF_res_general/', num2str(i)]);    
    clnf_preds = cat(3, clnf_preds, preds);

    labels = cat(3, labels, gt_landmarks);    
    load([cfss_dir,  num2str(i)]);
    cfss_preds = cat(3, cfss_preds, preds);    

    load([cfan_dir,  num2str(i)]);
    cfan_preds = cat(3, cfan_preds, preds);   
    
    load([iccr_dir,  num2str(i)]);
    iccr_preds = cat(3, iccr_preds, pred_landmarks);    
    
    load([chehra_dir,  num2str(i)]);
    drmf_preds = cat(3, drmf_preds, preds);    
    
    load([pocr_dir,  num2str(i)]);
    pocr_preds = cat(3, pocr_preds, preds); 
end

% As ICCR uses only 66 landmarks adapt all the others to the same format
labels = labels([1:60,62:64,66:end],:,:);
clnf_preds = clnf_preds([1:60,62:64,66:end],:,:);
cfss_preds = cfss_preds([1:60,62:64,66:end],:,:);
cfan_preds = cfan_preds([1:60,62:64,66:end],:,:);

clnf_error_66_cat_2 = compute_error(labels, clnf_preds);
cfss_error_66_cat_2 = compute_error(labels, cfss_preds - 0.5);
cfan_error_66_cat_2 = compute_error(labels, cfan_preds - 1.0);
iccr_error_66_cat_2 = compute_error(labels, iccr_preds);

% Do the 49 point version
labels = labels(18:end,:,:);

clnf_preds = clnf_preds(18:end,:,:);
cfan_preds = cfan_preds(18:end,:,:);
cfss_preds = cfss_preds(18:end,:,:);
iccr_preds = iccr_preds(18:end,:,:);

clnf_error_49_cat_2 = compute_error(labels, clnf_preds);
cfss_error_49_cat_2 = compute_error(labels, cfss_preds - 0.5);
cfan_error_49_cat_2 = compute_error(labels, cfan_preds - 1.0);
iccr_error_49_cat_2 = compute_error(labels, iccr_preds);
drmf_error_49_cat_2 = compute_error(labels, drmf_preds-0.5);
pocr_error_49_cat_2 = compute_error(labels, pocr_preds);

%%
cfss_preds = zeros(68,2,0);
iccr_preds = zeros(66,2,0);
clnf_preds = zeros(68,2,0);
cfan_preds = zeros(68,2,0);
sdm_preds = zeros(49,2,0);
drmf_preds = zeros(49,2,0);
pocr_preds = zeros(49,2,0);

labels = zeros(68,2,0);
% Load results
for i=cat_3
    
    load(['CLNF_res_general/', num2str(i)]);    
    clnf_preds = cat(3, clnf_preds, preds);

    labels = cat(3, labels, gt_landmarks);    
    load([cfss_dir,  num2str(i)]);
    cfss_preds = cat(3, cfss_preds, preds);    

    load([cfan_dir,  num2str(i)]);
    cfan_preds = cat(3, cfan_preds, preds);   
    
    load([iccr_dir,  num2str(i)]);
    iccr_preds = cat(3, iccr_preds, pred_landmarks);    
    
    load([chehra_dir,  num2str(i)]);
    drmf_preds = cat(3, drmf_preds, preds);    
    
    load([pocr_dir,  num2str(i)]);
    pocr_preds = cat(3, pocr_preds, preds); 
end

% As ICCR uses only 66 landmarks adapt all the others to the same format
labels = labels([1:60,62:64,66:end],:,:);
clnf_preds = clnf_preds([1:60,62:64,66:end],:,:);
cfss_preds = cfss_preds([1:60,62:64,66:end],:,:);
cfan_preds = cfan_preds([1:60,62:64,66:end],:,:);

clnf_error_66_cat_3 = compute_error(labels, clnf_preds);
cfss_error_66_cat_3 = compute_error(labels, cfss_preds - 0.5);
cfan_error_66_cat_3 = compute_error(labels, cfan_preds - 1.0);
iccr_error_66_cat_3 = compute_error(labels, iccr_preds);

% Do the 49 point version
labels = labels(18:end,:,:);

clnf_preds = clnf_preds(18:end,:,:);
cfan_preds = cfan_preds(18:end,:,:);
cfss_preds = cfss_preds(18:end,:,:);
iccr_preds = iccr_preds(18:end,:,:);

clnf_error_49_cat_3 = compute_error(labels, clnf_preds);
cfss_error_49_cat_3 = compute_error(labels, cfss_preds - 0.5);
cfan_error_49_cat_3 = compute_error(labels, cfan_preds - 1.0);
iccr_error_49_cat_3 = compute_error(labels, iccr_preds);
drmf_error_49_cat_3 = compute_error(labels, drmf_preds-0.5);
pocr_error_49_cat_3 = compute_error(labels, pocr_preds);

%% Save the results
save('results/clnf_errors', 'clnf_error_66_cat_1', 'clnf_error_66_cat_2', 'clnf_error_66_cat_3',...
    'clnf_error_49_cat_1', 'clnf_error_49_cat_2', 'clnf_error_49_cat_3'); 
save('results/cfss_errors', 'cfss_error_66_cat_1', 'cfss_error_66_cat_2', 'cfss_error_66_cat_3',...
    'cfss_error_49_cat_1', 'cfss_error_49_cat_2', 'cfss_error_49_cat_3'); 
save('results/iccr_errors', 'iccr_error_66_cat_1', 'iccr_error_66_cat_2', 'iccr_error_66_cat_3',...
    'iccr_error_49_cat_1', 'iccr_error_49_cat_2', 'iccr_error_49_cat_3'); 
save('results/cfan_errors', 'cfan_error_66_cat_1', 'cfan_error_66_cat_2', 'cfan_error_66_cat_3',...
    'cfan_error_49_cat_1', 'cfan_error_49_cat_2', 'cfan_error_49_cat_3'); 

save('results/drmf_errors', 'drmf_error_49_cat_1', 'drmf_error_49_cat_2', 'drmf_error_49_cat_3'); 
save('results/pocr_errors', 'pocr_error_49_cat_1', 'pocr_error_49_cat_2', 'pocr_error_49_cat_3'); 