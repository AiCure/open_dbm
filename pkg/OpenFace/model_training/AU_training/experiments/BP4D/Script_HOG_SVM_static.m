% Change to your downloaded location
clear
addpath('C:\liblinear\matlab')
addpath('../training_code/');
addpath('../utilities/');
addpath('../../data extraction/');
%% load shared definitions and AU data
shared_defs;

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-7:0.5:1);
hyperparams.e = 10.^(-3);

hyperparams.validate_params = {'c', 'e'};

% Set the training function
svm_train = @svm_train_linear;
    
% Set the test function (the first output will be used for validation)
svm_test = @svm_test_linear;

pca_loc = '../../pca_generation/generic_face_rigid.mat';

hog_data_dir_BP4D = hog_data_dir;

aus = [1, 2, 4, 6, 7, 10, 12, 14, 15, 17, 23];
%%
for a=1:numel(aus)
        
    au = aus(a);

    rest_aus = setdiff(all_aus, au);        

    % load the training and testing data for the current fold
    [train_samples, train_labels, valid_samples, valid_labels, ~, PC, means, scaling] = Prepare_HOG_AU_data_generic(train_recs, devel_recs, au, BP4D_dir, hog_data_dir_BP4D);

    train_samples = sparse(train_samples);
    valid_samples = sparse(valid_samples);

    %% Cross-validate here                
    [ best_params, ~ ] = validate_grid_search_no_par(svm_train, svm_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);
    model = svm_train(train_labels, train_samples, best_params);        
    
    [~, predictions_all] = svm_test(valid_labels, valid_samples, model);
    
    name = sprintf('results_BP4D_devel/AU_%d_static.mat', au);

    [ accuracies, F1s, corrs, ccc, rms, classes ] = evaluate_regression_results( predictions_all, valid_labels );
    
    save(name, 'model', 'F1s', 'accuracies', 'predictions_all', 'valid_labels');
       
    % Write out the model
    name = sprintf('models/AU_%d_static.dat', au);

    pos_lbl = model.Label(1);
    neg_lbl = model.Label(2);
    
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;
    
    write_lin_svm(name, means, svs, b, pos_lbl, neg_lbl);
end


