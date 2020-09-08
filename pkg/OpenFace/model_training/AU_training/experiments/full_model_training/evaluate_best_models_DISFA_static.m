% Change to your downloaded location
clear
addpath('C:\liblinear\matlab')
addpath('../training_code/');
addpath('../utilities/');
addpath('../../data extraction/');
   
DISFA_aus = [1, 2, 4, 5, 6, 9, 12, 15, 17, 20, 25, 26];
       
au = DISFA_aus(1);

op = cd('../DISFA/');
rest_aus = setdiff(DISFA_aus, au);        
shared_defs;

% need to split the rest
[~, ~, test_samples, test_labels, raw_test, PC, means, scaling, vid_ids, success] = Prepare_HOG_AU_data_generic([], users, au, rest_aus, hog_data_dir);

test_samples = sparse(test_samples);

%%
root = [hog_data_dir, '/../'];
for i=1:numel(users)   
    input_train_label_files{i} = [root, '/ActionUnit_Labels/', users{i}, '/', users{i}];
end
labels_gt_test = [];
for a=1:numel(DISFA_aus)
    labels_gt_test = cat(2, labels_gt_test, extract_au_labels(input_train_label_files, DISFA_aus(a)));
end
cd(op);

%%
for a=1:4%numel(DISFA_aus)
    
    name = sprintf('mat_models/AU_%d_static_intensity.mat', DISFA_aus(a));
    load(name);
    svr_test = @svr_test_linear;

    model.eval_ids = ones(size(labels_gt_test,1),1);
    model.vid_ids = vid_ids;
    model.success = success;
    [~, predictions_all] = svr_test(labels_gt_test(:,a), test_samples, model);

    [ ~, ~, ~, ccc, ~, ~ ] = evaluate_regression_results( predictions_all, labels_gt_test(:,a));

    fprintf('AU%d, CCC - %.3f\n', DISFA_aus(a), ccc);
end


