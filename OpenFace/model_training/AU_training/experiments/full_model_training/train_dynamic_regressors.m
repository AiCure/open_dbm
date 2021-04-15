% Change to your downloaded location
clear
addpath('C:\liblinear\matlab')
addpath('../training_code/');
addpath('../utilities/');
addpath('../../data extraction/');

%% load shared definitions and AU data
all_dataset_aus = [1, 2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 17, 20, 23, 25, 26, 45];

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-7:1:4);
hyperparams.p = 10.^(-2);

hyperparams.validate_params = {'c', 'p'};

% Set the training function
svr_train = @svr_train_linear_shift;
    
% Set the test function (the first output will be used for validation)
svr_test = @svr_test_linear_shift;

BP4D_aus = [6, 10, 12, 14, 17];
UNBC_aus = [6, 7, 9, 12, 25, 26];
DISFA_aus = [1, 2, 4, 5, 6, 9, 12, 15, 17, 20, 25, 26];
Bosphorus_aus = [1, 2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 17, 20, 23, 25, 26, 45];

for a=1:numel(all_dataset_aus)
        
    au = all_dataset_aus(a);

    train_samples = [];
    valid_samples = [];
    
    train_labels = [];
    valid_labels = [];
    
    % Keeping track which validation sample came from which dataset, as we
    % will be validating based on which hyperparam leads to best
    % performance on all datasets (mean F1)
    eval_ids = [];    
    dataset_ids = {};
    vid_ids = {};
    success = [];
    
    if(~isempty(find(BP4D_aus == au, 1)))
        op = cd('../BP4D/');
        rest_aus = setdiff(BP4D_aus, au);        
        shared_defs;
        % load the training and testing data for the current fold
        [train_samples_bp4d, train_labels_bp4d, ~, valid_samples_bp4d, valid_labels_bp4d, vid_ids_bp4d, ~, PC, means, scaling, success_devel] = Prepare_HOG_AU_data_generic_intensity_dynamic(train_recs, devel_recs, au, BP4D_dir_int, hog_data_dir);

        ignore = valid_labels_bp4d == 9;
    
        valid_samples_bp4d = valid_samples_bp4d(~ignore, :);
        valid_labels_bp4d = valid_labels_bp4d(~ignore);
        vid_ids_bp4d = vid_ids_bp4d(~ignore);
        success_devel = success_devel(~ignore);
        
        train_samples = cat(1, train_samples, train_samples_bp4d);
        valid_samples = cat(1, valid_samples, valid_samples_bp4d);

        train_labels = cat(1, train_labels, train_labels_bp4d);
        valid_labels = cat(1, valid_labels, valid_labels_bp4d);
        vid_ids = cat(1, vid_ids, vid_ids_bp4d);
        
        success = cat(1, success, success_devel);
        
        if(isempty(eval_ids))
           eval_ids = ones(size(valid_labels_bp4d,1), 1); 
        end
        
        clear 'train_samples_bp4d' 'train_labels_bp4d' 'valid_samples_bp4d' 'valid_labels_bp4d'
        
        dataset_ids = cat(1, dataset_ids, {'BP4D'});
        
        cd(op);
        
    end
     
   if(~isempty(find(Bosphorus_aus == au, 1)))
        op = cd('../Bosphorus/');
        rest_aus = setdiff(DISFA_aus, au);        
        shared_defs;

        % make sure validation data's labels are balanced
        [users_train, users_valid_bosph] = get_balanced_fold(Bosphorus_dir, all_recs, au, 1/3, 1);

        % need to split the rest
        [train_samples_bosph, train_labels_bosph, valid_samples_bosph, valid_labels_bosph, ~, PC, means, scaling, valid_ids, valid_success] = Prepare_HOG_AU_data_dynamic(users_train, users_valid_bosph, au, rest_aus, Bosphorus_dir, hog_data_dir);

        % Shortening the filenames to make it more like a video so that it
        % would work with normalization
        for v=1:numel(valid_ids)
            valid_ids{v} = valid_ids{v}(1:5);
        end
        
        % As there are only a few Bosphorus images (it being an image dataset)
        % we oversample it quite a bit        
        train_samples_bosph = repmat(train_samples_bosph, 10, 1);
        train_labels_bosph = repmat(train_labels_bosph, 10, 1);

        train_samples = cat(1, train_samples, train_samples_bosph);
        valid_samples = cat(1, valid_samples, valid_samples_bosph);

        train_labels = cat(1, train_labels, train_labels_bosph);
        valid_labels = cat(1, valid_labels, valid_labels_bosph);

        vid_ids = cat(1, vid_ids, valid_ids);

        success = cat(1, success, valid_success);                
        
        if(isempty(eval_ids))
           eval_ids = ones(size(valid_labels_bosph, 1), 1); 
        else
           eval_ids = cat(1, eval_ids, (eval_ids(end)+1)*ones(size(valid_labels_bosph, 1), 1)); 
        end

        clear 'train_samples_bosph' 'train_labels_bosph' 'valid_samples_bosph' 'valid_labels_bosph'  
        dataset_ids = cat(1, dataset_ids, {'Bosphorus'});
        cd(op);
       
    end            
    
    if(~isempty(find(DISFA_aus == au, 1)))
        op = cd('../DISFA/');
        rest_aus = setdiff(DISFA_aus, au);        
        shared_defs;

        % make sure validation data's labels are balanced
        [users_train, users_valid_disfa] = get_balanced_fold(DISFA_dir, users, au, 1/3, 1);

        % need to split the rest
        [train_samples_disf, train_labels_disf, valid_samples_disf, valid_labels_disf, raw_disfa, PC, means, scaling, vid_ids_disfa, valid_success] = Prepare_HOG_AU_data_generic_dynamic(users_train, users_valid_disfa, au, rest_aus, DISFA_dir, hog_data_dir);

        train_samples = cat(1, train_samples, train_samples_disf);
        valid_samples = cat(1, valid_samples, valid_samples_disf);

        train_labels = cat(1, train_labels, train_labels_disf);
        valid_labels = cat(1, valid_labels, valid_labels_disf);

        vid_ids = cat(1, vid_ids, vid_ids_disfa);

        success = cat(1, success, valid_success);        
        
        if(isempty(eval_ids))
           eval_ids = ones(size(valid_labels_disf,1), 1); 
        else
           eval_ids = cat(1, eval_ids, (eval_ids(end)+1)*ones(size(valid_labels_disf,1), 1)); 
        end

        clear 'train_samples_disf' 'train_labels_disf' 'valid_samples_disf' 'valid_labels_disf'  
        dataset_ids = cat(1, dataset_ids, {'DISFA'});
        cd(op);
       
    end       
     
    if(~isempty(find(UNBC_aus == au, 1)))
        op = cd('../UNBC/');
        rest_aus = setdiff(UNBC_aus, au);        
        shared_defs;
    
        [users_train, users_valid_unbc] = get_balanced_fold(UNBC_dir, all_recs, au, 1/3, 1);
    
        % load the training and testing data for the current fold
        [train_samples_unbc, train_labels_unbc, valid_samples_unbc, valid_labels_unbc, ~, PC, means, scaling, vid_ids_unbc, success_devel] = Prepare_HOG_AU_data_dynamic(users_train, users_valid_unbc, au, rest_aus, UNBC_dir, features_dir);

        train_samples = cat(1, train_samples, train_samples_unbc);
        valid_samples = cat(1, valid_samples, valid_samples_unbc);

        train_labels = cat(1, train_labels, train_labels_unbc);
        valid_labels = cat(1, valid_labels, valid_labels_unbc);
        
        vid_ids = cat(1, vid_ids, vid_ids_unbc);
        
        success = cat(1, success, success_devel);    
        
        if(isempty(eval_ids))
           eval_ids = ones(size(valid_labels_unbc,1), 1); 
        else
           eval_ids = cat(1, eval_ids, (eval_ids(end)+1)*ones(size(valid_labels_unbc,1), 1)); 
        end        
                
        clear 'train_samples_unbc' 'train_labels_unbc' 'valid_samples_unbc' 'valid_labels_unbc'  
        dataset_ids = cat(1, dataset_ids, {'UNBC'});
        cd(op);

    end         
    
    train_samples = sparse(train_samples);
    dataset_ids
    %% Cross-validate here                
    hyperparams.eval_ids = eval_ids;
    hyperparams.vid_ids = vid_ids;
    hyperparams.valid_samples = valid_samples;
    hyperparams.success = success;
    hyperparams.valid_labels = valid_labels;
    
    [ best_params, ~ ] = validate_grid_search_no_par(svr_train, svr_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);
    model = svr_train(train_labels, train_samples, best_params);        
    
    model.eval_ids = eval_ids;
    model.vid_ids = vid_ids;
    
    [~, predictions_all] = svr_test(valid_labels, valid_samples, model);
    
    name = sprintf('mat_models/AU_%d_dynamic_intensity.mat', au);

    eval_ids_uq = unique(eval_ids)';
    cccs = [];
    for i=eval_ids_uq            
        [ ~, ~, ~, ccc_c, ~, ~ ] = evaluate_regression_results( predictions_all(eval_ids==i), valid_labels(eval_ids==i));
        cccs = cat(2, cccs, ccc_c);
    end
    
    mean_ccc = mean(cccs);
    
    save(name, 'model', 'mean_ccc', 'mean_ccc', 'cccs', 'predictions_all', 'valid_labels', 'eval_ids', 'dataset_ids');           
    
    % Write out the model
    name = sprintf('regressors/AU_%d_dynamic_intensity.dat', au);
   
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;
    
    write_lin_dyn_svr(name, means, svs, b, model.cutoff);
    
    clear 'train_samples' 'train_labels' 'valid_samples' 'valid_labels'  
end


