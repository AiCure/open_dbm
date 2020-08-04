function Script_HOG_SVM_train()

% Change to your downloaded location
addpath('C:\liblinear\matlab')
addpath('../training_code/');
addpath('../utilities/');
addpath('../../data extraction/');

%% load shared definitions and AU data
shared_defs;

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-9:0.5:1);
hyperparams.e = 10.^(-3);

hyperparams.validate_params = {'c', 'e'};

% Set the training function
svm_train = @svm_train_linear;
    
% Set the test function (the first output will be used for validation)
svm_test = @svm_test_linear;

all_recs = cat(2, train_recs, devel_recs);

%%
for a=1:numel(all_aus)
    
    au = all_aus(a);
            
    rest_aus = setdiff(all_aus, au);        
    [train_recs, devel_recs] = get_balanced_fold(FERA2011_dir, all_recs, au, 1/3, 1);
    
    % load the training and testing data for the current fold    
    [train_samples, train_labels, valid_samples, valid_labels, ~, PC, means, scaling] = Prepare_HOG_AU_data_generic(train_recs, devel_recs, au, rest_aus, FERA2011_dir, features_dir);
    
    train_samples = sparse(train_samples);
    valid_samples = sparse(valid_samples);

    %% Cross-validate here                
    [ best_params, ~ ] = validate_grid_search_no_par(svm_train, svm_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);

    model = svm_train(train_labels, train_samples, best_params);        

    [~, prediction] = svm_test(valid_labels, valid_samples, model);

    % Go from raw data to the prediction
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;

    name = sprintf('models/AU_%d_static.dat', au);

    pos_lbl = model.Label(1);
    neg_lbl = model.Label(2);
        
    write_lin_svm(name, means, svs, b, pos_lbl, neg_lbl);

    name = sprintf('results_FERA2011_devel/AU_%d_static.mat', au);
        
    tp = sum(valid_labels == 1 & prediction == 1);
    fp = sum(valid_labels == 0 & prediction == 1);
    fn = sum(valid_labels == 1 & prediction == 0);
    tn = sum(valid_labels == 0 & prediction == 0);

    precision = tp/(tp+fp);
    recall = tp/(tp+fn);

    f1 = 2 * precision * recall / (precision + recall);    
    
    save(name, 'model', 'f1', 'precision', 'recall', 'best_params', 'valid_labels', 'prediction');
        
end

end


