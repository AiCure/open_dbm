% Change to your downloaded location
clear
addpath('C:\liblinear\matlab')
addpath('../training_code')
addpath('../utilities')

%% load shared definitions and AU data
shared_defs;

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-7:1:1);
hyperparams.e = 10.^(-3);

hyperparams.validate_params = {'c', 'e'};

% Set the training function
svr_train = @svm_train_linear;
    
% Set the test function (the first output will be used for validation)
svr_test = @svm_test_linear;

%%
for a=1:numel(aus)
    
    au = aus(a);
    
    rest_aus = setdiff(all_aus, au);        

    % make sure validation data's labels are balanced
    [users_train, users_valid] = get_balanced_fold(DISFA_dir, users, au, 1/3, 1);

    % need to split the rest
    [train_samples, train_labels, valid_samples, valid_labels, ~, PC, means, scaling, valid_ids, valid_success] = Prepare_HOG_AU_data_generic_dynamic(users_train, users_valid, au, rest_aus, DISFA_dir, hog_data_dir);

    train_labels(train_labels > 1) = 1;
    valid_labels(valid_labels > 1) = 1;
    
    train_samples = sparse(train_samples);
    valid_samples = sparse(valid_samples);

    %% Validate here
    hyperparams.success = valid_success;

    [ best_params, ~ ] = validate_grid_search_no_par(svr_train, svr_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);

    model = svr_train(train_labels, train_samples, best_params);        

    [~, prediction] = svr_test(valid_labels, valid_samples, model);

    name = sprintf('classifiers/AU_%d_dyn.mat', au);

    [ accuracies, F1s, corrs, ccc, rms, classes ] = evaluate_regression_results( prediction, valid_labels );    

    save(name, 'model', 'accuracies', 'F1s', 'corrs', 'rms', 'ccc', 'prediction', 'valid_labels');        

    name = sprintf('classifiers/AU_%d_dyn.dat', au);

    pos_lbl = model.Label(1);
    neg_lbl = model.Label(2);
    
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;
    write_lin_svm(name, means, svs, b, pos_lbl, neg_lbl);
end