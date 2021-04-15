% Change to your downloaded location
clear
addpath('C:\liblinear\matlab')
addpath('../training_code/');
addpath('../utilities/');
addpath('../../data extraction/');

%% load shared definitions and AU data
all_dataset_aus = [1, 2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 17, 20, 23, 25, 26, 28, 45];

% Set up the hyperparameters to be validated
hyperparams.c = 10.^(-7:0.5:1);
hyperparams.e = 10.^(-3);

hyperparams.validate_params = {'c', 'e'};

% Set the training function
svm_train = @svm_train_linear;
    
% Set the test function (the first output will be used for validation)
svm_test = @svm_test_linear;

BP4D_aus = [1, 2, 4, 6, 7, 10, 12, 14, 15, 17, 23];
SEMAINE_aus = [2, 12, 17, 25, 28, 45];
FERA2011_aus = [1, 2, 4, 6, 7, 10, 12, 15, 17, 25, 26];
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
    
    if(~isempty(find(BP4D_aus == au, 1)))
        op = cd('../BP4D/');
        rest_aus = setdiff(BP4D_aus, au);        
        shared_defs;
        % load the training and testing data for the current fold
        [train_samples_bp4d, train_labels_bp4d, valid_samples_bp4d, valid_labels_bp4d, ~, PC, means, scaling] = Prepare_HOG_AU_data_generic_dynamic(train_recs, devel_recs, au, BP4D_dir, hog_data_dir);

        train_samples = cat(1, train_samples, train_samples_bp4d);
        valid_samples = cat(1, valid_samples, valid_samples_bp4d);

        train_labels = cat(1, train_labels, train_labels_bp4d);
        valid_labels = cat(1, valid_labels, valid_labels_bp4d);
                
        if(isempty(eval_ids))
           eval_ids = ones(size(valid_labels_bp4d,1), 1); 
        end
        
        clear 'train_samples_bp4d' 'train_labels_bp4d' 'valid_samples_bp4d' 'valid_labels_bp4d'
        
        dataset_ids = cat(1, dataset_ids, {'BP4D'});
        
        cd(op);
        
    end
 
    if(~isempty(find(FERA2011_aus == au, 1)))
        op = cd('../FERA2011/');
        rest_aus = setdiff(FERA2011_aus, au);        
        shared_defs;
        all_recs = cat(2, train_recs, devel_recs);
        [users_train, users_valid_fera] = get_balanced_fold(FERA2011_dir, all_recs, au, 1/3, 1);
        
        % load the training and testing data for the current fold
        [train_samples_f2011, train_labels_f2011, valid_samples_f2011, valid_labels_f2011, ~, PC, means, scaling] = Prepare_HOG_AU_data_generic_dynamic(users_train, users_valid_fera, au, rest_aus, FERA2011_dir, features_dir);

        train_samples = cat(1, train_samples, train_samples_f2011);
        valid_samples = cat(1, valid_samples, valid_samples_f2011);

        train_labels = cat(1, train_labels, train_labels_f2011);
        valid_labels = cat(1, valid_labels, valid_labels_f2011);
                
        if(isempty(eval_ids))
           eval_ids = ones(size(valid_labels_f2011,1), 1); 
        else
           eval_ids = cat(1, eval_ids, (eval_ids(end)+1)*ones(size(valid_labels_f2011,1), 1)); 
        end
        
        clear 'train_samples_f2011' 'train_labels_f2011' 'valid_samples_f2011' 'valid_labels_bp4d'
        
        dataset_ids = cat(1, dataset_ids, {'FERA2011'});
        
        cd(op);
        
    end    
    
    if(~isempty(find(SEMAINE_aus == au, 1)))
        op = cd('../SEMAINE/');
        rest_aus = setdiff(SEMAINE_aus, au);        
        shared_defs;
        % load the training and testing data for the current fold
        [train_samples_sem, train_labels_sem, valid_samples_sem, valid_labels_sem, ~, PC, means, scaling] = Prepare_HOG_AU_data_generic_dynamic(train_recs, devel_recs, au, rest_aus, SEMAINE_dir, hog_data_dir);

        train_samples = cat(1, train_samples, train_samples_sem);
        valid_samples = cat(1, valid_samples, valid_samples_sem);

        train_labels = cat(1, train_labels, train_labels_sem);
        valid_labels = cat(1, valid_labels, valid_labels_sem);
                
        if(isempty(eval_ids))
           eval_ids = ones(size(valid_labels_sem,1), 1); 
        else
           eval_ids = cat(1, eval_ids, (eval_ids(end)+1)*ones(size(valid_labels_sem,1), 1)); 
        end
        
        clear 'train_samples_sem' 'train_labels_sem' 'valid_samples_sem' 'valid_labels_sem'
        dataset_ids = cat(1, dataset_ids, {'SEMAINE'});
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

        train_labels_bosph(train_labels_bosph > 1) = 1;
        valid_labels_bosph(valid_labels_bosph > 1) = 1;

        % As there are only a few Bosphorus images (it being an image dataset)
        % we oversample it quite a bit        
        train_samples_bosph = repmat(train_samples_bosph, 10, 1);
        train_labels_bosph = repmat(train_labels_bosph, 10, 1);        
        
        train_samples = cat(1, train_samples, train_samples_bosph);
        valid_samples = cat(1, valid_samples, valid_samples_bosph);

        train_labels = cat(1, train_labels, train_labels_bosph);
        valid_labels = cat(1, valid_labels, valid_labels_bosph);

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
        [train_samples_disf, train_labels_disf, valid_samples_disf, valid_labels_disf, ~, PC, means, scaling, valid_ids, valid_success] = Prepare_HOG_AU_data_generic_dynamic(users_train, users_valid_disfa, au, rest_aus, DISFA_dir, hog_data_dir);

        train_labels_disf(train_labels_disf > 1) = 1;
        valid_labels_disf(valid_labels_disf > 1) = 1;

        train_samples = cat(1, train_samples, train_samples_disf);
        valid_samples = cat(1, valid_samples, valid_samples_disf);

        train_labels = cat(1, train_labels, train_labels_disf);
        valid_labels = cat(1, valid_labels, valid_labels_disf);

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
        [train_samples_unbc, train_labels_unbc, valid_samples_unbc, valid_labels_unbc, ~, PC, means, scaling] = Prepare_HOG_AU_data_dynamic(users_train, users_valid_unbc, au, rest_aus, UNBC_dir, features_dir);

        % Binarizing the data
        train_labels_unbc(train_labels_unbc > 1) = 1;
        valid_labels_unbc(valid_labels_unbc > 1) = 1;
    
        train_samples = cat(1, train_samples, train_samples_unbc);
        valid_samples = cat(1, valid_samples, valid_samples_unbc);

        train_labels = cat(1, train_labels, train_labels_unbc);
        valid_labels = cat(1, valid_labels, valid_labels_unbc);
        
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
    [ best_params, ~ ] = validate_grid_search_no_par(svm_train, svm_test, false, train_samples, train_labels, valid_samples, valid_labels, hyperparams);
    model = svm_train(train_labels, train_samples, best_params);        
    
    model.eval_ids = eval_ids;
    
    [~, predictions_all] = svm_test(valid_labels, valid_samples, model);
    
    name = sprintf('mat_models/AU_%d_dynamic.mat', au);

    eval_ids_uq = unique(eval_ids)';
    F1s = [];
    for i=eval_ids_uq            
        F1s = cat(2, F1s, compute_F1(valid_labels(eval_ids==i), predictions_all(eval_ids==i)));
    end
    
    meanF1 = mean(F1s);
    
    save(name, 'model', 'F1s', 'meanF1', 'predictions_all', 'valid_labels', 'eval_ids', 'dataset_ids');           
    
    % Write out the model
    name = sprintf('classifiers/AU_%d_dynamic.dat', au);

    pos_lbl = model.Label(1);
    neg_lbl = model.Label(2);
    
    w = model.w(1:end-1)';
    b = model.w(end);

    svs = bsxfun(@times, PC, 1./scaling') * w;
    
    write_lin_dyn_svm(name, means, svs, b, pos_lbl, neg_lbl);
    
    clear 'train_samples' 'train_labels' 'valid_samples' 'valid_labels'  
end


