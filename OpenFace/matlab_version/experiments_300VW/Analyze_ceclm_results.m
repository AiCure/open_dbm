clear

%% Gather predictions and ground truth
cat_1 = [ 114, 124, 125, 126, 150, 158, 401, 402, 505, 506, 507, 508, 509, 510, 511, 514, 515, 518, 519, 520, 521, 522, 524, 525, 537, 538, 540, 541, 546, 547, 548];
cat_2 = [203, 208, 211, 212, 213, 214, 218, 224, 403, 404, 405, 406, 407, 408, 409, 412, 550, 551, 553];
cat_3 = [410, 411, 516, 517, 526, 528, 529, 530, 531, 533, 557, 558, 559, 562];

%%
errors_cat_1 = [];
errors_cat_1_mtcnn = [];

% Load results
for i=cat_1
    
    load(['CECLM_res_general/', num2str(i)]);    
    errors_cat_1 = cat(1, errors_cat_1, median(compute_error(gt_landmarks, preds)));
    
    load(['CECLM_res_general_mtcnn/', num2str(i)]);    
    errors_cat_1_mtcnn = cat(1, errors_cat_1_mtcnn, median(compute_error(gt_landmarks, preds)));
end

%%

errors_cat_2 = [];
errors_cat_2_mtcnn = [];

% Load results
for i=cat_2
    
    load(['CECLM_res_general/', num2str(i)]);    
    errors_cat_2 = cat(1, errors_cat_2, median(compute_error(gt_landmarks, preds)));
      
    load(['CECLM_res_general_mtcnn/', num2str(i)]);    
    errors_cat_2_mtcnn = cat(1, errors_cat_2_mtcnn, median(compute_error(gt_landmarks, preds)));

end

%%

errors_cat_3 = [];
errors_cat_3_mtcnn = [];

% Load results
for i=cat_3
    
    load(['CECLM_res_general/', num2str(i)]);    
    errors_cat_3 = cat(1, errors_cat_3, median(compute_error(gt_landmarks, preds)));
      
    load(['CECLM_res_general_mtcnn/', num2str(i)]);    
    errors_cat_3_mtcnn = cat(1, errors_cat_3_mtcnn, median(compute_error(gt_landmarks, preds)));

end
