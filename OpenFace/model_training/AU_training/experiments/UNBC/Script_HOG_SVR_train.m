function Script_HOG_SVR_train()

% Change to your downloaded location
addpath('C:\liblinear\matlab')
addpath('../training_code/');
addpath('../utilities/');
addpath('../../data extraction/');

%% load shared definitions and AU data
shared_defs;

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-7:1:4);
hyperparams.p = 10.^(-2);

hyperparams.validate_params = {'c', 'p'};

% Set the training function
svr_train = @svr_train_linear;
    
% Set the test function (the first output will be used for validation)
svr_test = @svr_test_linear;

all_recs = cat(2, train_recs, devel_recs);

%%
for a=1:numel(aus)
    
    au = aus(a);
            
    rest_aus = setdiff(all_aus, au);        
    
    [users_train, users_valid] = get_balanced_fold(UNBC_dir, all_recs, au, 1/3, 1);
    
    % load the training and testing data for the current fold    
    [train_samples, train_labels, valid_samples, valid_labels, ~, PC, means, scaling, valid_ids, valid_success] = Prepare_HOG_AU_data(users_train, users_valid, au, rest_aus, UNBC_dir, features_dir);
        
    train_samples = sparse(train_samples);
    valid_samples = sparse(valid_samples);

    hyperparams.success = valid_success;    
    
    %% Cross-validate here                
    [ best_params, ~ ] = validate_grid_search_no_par(svr_train, svr_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);

    model = svr_train(train_labels, train_samples, best_params);        

    [~, prediction] = svr_test(valid_labels, valid_samples, model);

    % Go from raw data to the prediction
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;

    name = sprintf('models/AU_%d_static_intensity.dat', au);

    write_lin_svr(name, means, svs, b);

    name = sprintf('results_UNBC_devel/AU_%d_static_intensity.mat', au);

    [ accuracies, F1s, corrs, ccc, rms, classes ] = evaluate_regression_results( prediction, valid_labels );
            
    save(name, 'model', 'F1s', 'corrs', 'accuracies', 'ccc', 'rms', 'prediction', 'valid_labels', 'users_valid');
        
end

end


