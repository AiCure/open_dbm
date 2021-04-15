function [ best_params, all_params ] = crossvalidate_grid_search(train_fn, test_fn, minimise, samples, labels, hyperparams, varargin)
%crossvalidate_regressor_grid_search A utility function for crossvalidating a statistical model
%   Detailed explanation goes here
%
%   train_fn - a function handle that takes train_labels, train_samples,
%   hyperparams as input (with each row being a sample), it must return a
%   model that can be passed to test_fn
%
%   test_fn - a function that takes test_labels, test_samples, model as 
%   input and returns the result to optimise
%
%   minimise - if set to true the crossvalidation will attempt to find
%   hyper-parameters that minimise the result otherwise they will maximise
%   it
%
%   samples - the whole training dataset (rows are samples)
%
%   labels - the labels for training (rows are samples)
%
%   hyperparams - the field validate_params should contain the names of 
%   hyperparameters to validate, and the hyperparameter to be validated 
%   should contain values to be tested. For example:
%   If we havehyperparams.validate_params = {'c','g'}, and 
%   hyperparams.c = [0.1, 10, 100], hyperparams.g = [0.25, 0.5], the grid 
%   search algorithm will search through all their possible combinations
%
%   Optional parameters:
%   
%   'num_folds' - num_folds, specify how many crossvalidation folds should
%   be used
%
%   'inds_cv_train' - specify the actual fold splits with a n x num_folds
%   matrix, where n is the number of samples, and num_folds is the number
%   of folds. The matrix should be a logical where each column represents
%   the training samples to use
%
%   'num_repeat' - number of times to retry the training testing (useful
%   for non deterministic algorithms

    % Find the hyperparameters to optimise (if any)
    
    num_params = 1;        
    
    if(isfield(hyperparams, 'validate_params'))
        param_names = hyperparams.validate_params;
        param_values = cell(numel(param_names),1);

        for p=1:numel(param_names)
            param_values{p} = hyperparams.(param_names{p});
            num_params = num_params * numel(param_values{p});
        end

        % Create the list of parameter combinations
        
%         all_params = struct;        

        % keep track of parameter value indices (will be cycling over them based on change_every)
        index = ones(numel(param_values), 1);
        change_every = zeros(numel(param_values), 1);
        change_already = num_params;
        for p=1:numel(param_names)
            change_every(p) = change_already / numel(param_values{p});
            change_already = change_already / numel(param_values{p});
        end
        for i=1:num_params   
            all_params(i) = hyperparams;            
            
            for p=1:numel(param_names)
                all_params(i).(param_names{p}) = param_values{p}(index(p));

                % get the new value
                if(mod(i, change_every(p)) == 0)
                    index(p) = index(p) + 1;
                end

                % cycle the value if it exceeds the bounds
                if(mod(index(p) - 1, numel(param_values{p})) == 0)                
                    index(p) = 1;
                end
            end

        end
        
        % some clean-up
        all_params = rmfield(all_params, 'validate_params');
        
        % Initialise all results to 0
        for i=1:num_params
            all_params(i).result = 0;            
        end
    else
        % if no validation needed just set to hyperparams
        all_params = hyperparams;        
    end
    
    %% Get the indices to use for the cross validation (if they are not provided)

    % By default we use two folds with half-half split
    rng(0);        
    num_cv_folds = 2;
    [ inds_cv_train, ~ ] = GetFolds(size(labels,1), num_cv_folds);
    
    % Alternatively this can be overwritten
    if(sum(strcmp(varargin,'num_folds')))
        ind = find(strcmp(varargin,'num_folds')) + 1;
        num_cv_folds = varargin{ind};     
        [ inds_cv_train, ~ ] = GetFolds(size(labels,1), num_cv_folds);
    end    
        
    if(sum(strcmp(varargin,'inds_cv_train')))
        ind = find(strcmp(varargin,'inds_cv_train')) + 1;
        inds_cv_train = varargin{ind};     
        num_cv_folds = size(inds_cv_train,2);
    end      
    
    % Potentially useful for non-deterministic models, we might want to
    % train them multiple times for more reliable results
    if(sum(strcmp(varargin,'num_repeat')))
        ind = find(strcmp(varargin,'num_repeat')) + 1;
        num_repeat = varargin{ind};     
    else
        num_repeat = 1;
    end
    
    for i = 1:num_cv_folds

        % if we have a cell array convert it to a double one
        train_samples = samples(inds_cv_train(:,i),:);
        train_labels = labels(inds_cv_train(:,i),:);

        test_samples = samples(~inds_cv_train(:,i),:);
        test_labels = labels(~inds_cv_train(:,i),:);  
        
        % Crossvalidate the c, p, and gamma values
        for p = 1:num_params

            for r=1:num_repeat
                model = train_fn(train_labels, train_samples, all_params(p));

                result = test_fn(test_labels, test_samples, model);

                all_params(p).result = all_params(p).result + result/(num_cv_folds*num_repeat);
            end
        end
    end        


    %% Finding the best hyper-params
    if(minimise)
        [~, best] = min(cat(1, all_params.result));
    else
        [~, best] = max(cat(1, all_params.result));
    end
    
    best_params = all_params(best);        
    
end