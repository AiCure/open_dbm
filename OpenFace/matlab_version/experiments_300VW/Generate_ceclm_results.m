clear

%% Gather predictions and ground truth
cat_1 = [ 114, 124, 125, 126, 150, 158, 401, 402, 505, 506, 507, 508, 509, 510, 511, 514, 515, 518, 519, 520, 521, 522, 524, 525, 537, 538, 540, 541, 546, 547, 548];
cat_2 = [203, 208, 211, 212, 213, 214, 218, 224, 403, 404, 405, 406, 407, 408, 409, 412, 550, 551, 553];
cat_3 = [410, 411, 516, 517, 526, 528, 529, 530, 531, 533, 557, 558, 559, 562];

%%

ceclm_preds = zeros(68,2,0);

labels = zeros(68,2,0);
% Load results
for i=cat_1
    
    load(['CECLM_res_general/', num2str(i)]);    
    ceclm_preds = cat(3, ceclm_preds, preds);

    labels = cat(3, labels, gt_landmarks);    
end

% As ICCR uses only 66 landmarks adapt all the others to the same format
labels = labels([1:60,62:64,66:end],:,:);
ceclm_preds = ceclm_preds([1:60,62:64,66:end],:,:);
ceclm_error_66_cat_1 = compute_error(labels, ceclm_preds);
ceclm_error_66_cat_1_auc = auc(ceclm_error_66_cat_1);

% Do the 49 point version
labels = labels(18:end,:,:);
ceclm_preds = ceclm_preds(18:end,:,:);

ceclm_error_49_cat_1 = compute_error(labels, ceclm_preds);
ceclm_error_49_cat_1_auc = auc(ceclm_error_49_cat_1);

%%

ceclm_preds = zeros(68,2,0);

labels = zeros(68,2,0);
% Load results
for i=cat_2
    
    load(['CECLM_res_general/', num2str(i)]);    
    ceclm_preds = cat(3, ceclm_preds, preds);

    labels = cat(3, labels, gt_landmarks);    
end

% As ICCR uses only 66 landmarks adapt all the others to the same format
labels = labels([1:60,62:64,66:end],:,:);
ceclm_preds = ceclm_preds([1:60,62:64,66:end],:,:);
ceclm_error_66_cat_2 = compute_error(labels, ceclm_preds);
ceclm_error_66_cat_2_auc = auc(ceclm_error_66_cat_2);

% Do the 49 point version
labels = labels(18:end,:,:);
ceclm_preds = ceclm_preds(18:end,:,:);

ceclm_error_49_cat_2 = compute_error(labels, ceclm_preds);
ceclm_error_49_cat_2_auc = auc(ceclm_error_49_cat_2);

%%
ceclm_preds = zeros(68,2,0);

labels = zeros(68,2,0);
% Load results
for i=cat_3
    
    load(['CECLM_res_general/', num2str(i)]);    
    ceclm_preds = cat(3, ceclm_preds, preds);

    labels = cat(3, labels, gt_landmarks);    
end

% As ICCR uses only 66 landmarks adapt all the others to the same format
labels = labels([1:60,62:64,66:end],:,:);
ceclm_preds = ceclm_preds([1:60,62:64,66:end],:,:);
ceclm_error_66_cat_3 = compute_error(labels, ceclm_preds);
ceclm_error_66_cat_3_auc = auc(ceclm_error_66_cat_3);

% Do the 49 point version
labels = labels(18:end,:,:);
ceclm_preds = ceclm_preds(18:end,:,:);

ceclm_error_49_cat_3 = compute_error(labels, ceclm_preds);
ceclm_error_49_cat_3_auc = auc(ceclm_error_49_cat_3);

%% Save the results
save('results/ceclm_errors', 'ceclm_error_66_cat_1', 'ceclm_error_66_cat_2', 'ceclm_error_66_cat_3',...
    'ceclm_error_49_cat_1', 'ceclm_error_49_cat_2', 'ceclm_error_49_cat_3',...
    'ceclm_error_66_cat_1_auc', 'ceclm_error_66_cat_2_auc', 'ceclm_error_66_cat_3_auc',...
    'ceclm_error_49_cat_1_auc', 'ceclm_error_49_cat_2_auc', 'ceclm_error_49_cat_3_auc'); 
