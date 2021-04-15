% Change to your downloaded location
clear
addpath('C:\liblinear\matlab')
addpath('../training_code')
addpath('../utilities')

%% load shared definitions and AU data
shared_defs;

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-7:1:3);
hyperparams.p = 10.^(-2);

hyperparams.validate_params = {'c', 'p'};

% Set the training function
svr_train = @svr_train_linear;
    
% Set the test function (the first output will be used for validation)
svr_test = @svr_test_linear;

%%
for a=1:numel(aus)
    
    au = aus(a);
    
    rest_aus = setdiff(all_aus, au);        

    % make sure validation data's labels are balanced
    [users_train, users_valid] = get_balanced_fold(DISFA_dir, users, au, 1/4, 1);

    % need to split the rest
    [train_samples, train_labels, valid_samples, valid_labels, ~, PC, means, scaling, valid_ids, valid_success] = Prepare_HOG_AU_data_generic(users_train, users_valid, au, rest_aus, DISFA_dir, hog_data_dir);
    
    train_samples = sparse(train_samples);
    valid_samples = sparse(valid_samples);

    %% Validate here
    hyperparams.success = valid_success;
    hyperparams.valid_samples = valid_samples;
    hyperparams.valid_labels = valid_labels;
    hyperparams.vid_ids = valid_ids;   
    
    [ best_params, ~ ] = validate_grid_search_no_par(svr_train, svr_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);

    model = svr_train(train_labels, train_samples, best_params);        
    model.success = valid_success;
    model.vid_ids = valid_ids;
    
    [~, prediction] = svr_test(valid_labels, valid_samples, model);

    name = sprintf('regressors/AU_%d_static_intensity.mat', au);

    [ accuracies, F1s, corrs, ccc, rms, classes ] = evaluate_regression_results( prediction, valid_labels );    

    save(name, 'model', 'accuracies', 'F1s', 'corrs', 'rms', 'ccc', 'prediction', 'valid_labels');        

    % Write out the model
    name = sprintf('regressors/AU_%d_static_intensity.dat', au);
   
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;
    
    write_lin_svr(name, means, svs, b);    

end