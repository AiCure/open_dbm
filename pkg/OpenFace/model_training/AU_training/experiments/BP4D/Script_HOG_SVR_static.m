%% load shared definitions and AU data
clear

addpath('../../data extraction/');
addpath('../utilities/');
addpath('../training_code/');

shared_defs;

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-7:1:4);
hyperparams.p = 10.^(-2);

hyperparams.validate_params = {'c', 'p'};

% Set the training function
svr_train = @svr_train_linear;
    
% Set the test function (the first output will be used for validation)
svr_test = @svr_test_linear;

hog_data_dir_BP4D = hog_data_dir;

aus = [6, 10, 12, 14, 17];
%%
for a=1:numel(aus)
    
    predictions_all = [];
    test_labels_all = [];
    
    au = aus(a);

    rest_aus = setdiff(all_aus, au);        
    
    % load the training and testing data for the current fold
    [train_samples, train_labels, ~, valid_samples, valid_labels, vid_ids_devel, ~, PC, means, scaling, success_devel] = Prepare_HOG_AU_data_generic_intensity(train_recs, devel_recs, au, BP4D_dir_int, hog_data_dir_BP4D);
    
    ignore = valid_labels == 9;
    
    valid_samples = valid_samples(~ignore, :);
    valid_labels = valid_labels(~ignore);
    vid_ids_devel = vid_ids_devel(~ignore);
    success_devel = success_devel(~ignore);
    
    train_samples = sparse(train_samples);
    valid_samples = sparse(valid_samples);

    hyperparams.success = success_devel;

    %% Cross-validate here                
    [ best_params, ~ ] = validate_grid_search_no_par(svr_train, svr_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);
    model = svr_train(train_labels, train_samples, best_params);        
    
    clear 'train_samples'
    
    %% Now test the model
    model.vid_ids = vid_ids_devel;
    
    [~, prediction] = svr_test(valid_labels, valid_samples, model);

    name = sprintf('results_BP4D_devel/AU_%d_static_intensity.mat', au);

    [ accuracies, F1s, corrs, ccc, rms, classes ] = evaluate_regression_results( prediction, valid_labels );
    
    save(name, 'model', 'F1s', 'corrs', 'accuracies', 'ccc', 'rms', 'prediction', 'valid_labels');
        
        % Go from raw data to the prediction
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;

    name = sprintf('models/AU_%d_static_intensity.dat', au);

    write_lin_svr(name, means, svs, b);
    
end

