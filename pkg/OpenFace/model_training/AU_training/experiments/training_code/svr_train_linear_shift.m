function [model] = svr_train_linear_shift(train_labels, train_samples, hyper)
    
    % Change to your downloaded location
    addpath('C:\liblinear\matlab')
    
    comm = sprintf('-s 11 -B 1 -p %.10f -c %.10f -q', hyper.p, hyper.c);
    model = train(train_labels, train_samples, comm);
    
    % Try predicting on the valid samples data and shifting it
        
    cutoffs = 0:0.05:0.8;
    results = zeros(numel(cutoffs)+1, 1);

    prediction = hyper.valid_samples * model.w(1:end-1)' + model.w(end);
    prediction(~hyper.success) = 0;
    
    for c=1:numel(cutoffs)
        % perform shifting here per person
        users = unique(hyper.vid_ids);
        
        prediction_curr = prediction;
        
        for i=1:numel(users)

            preds_user = prediction_curr(strcmp(hyper.vid_ids, users(i)));
            sorted = sort(preds_user);

            % alternative, move to histograms and pick the highest one

            shift = sorted(round(end*cutoffs(c))+1);

            prediction_curr(strcmp(hyper.vid_ids, users(i))) = preds_user - shift;

        end
        
        prediction_curr(prediction_curr<0)=0;
        prediction_curr(prediction_curr>5)=5;
    
        [ ~, ~, ~, ccc, ~, ~ ] = evaluate_regression_results( prediction_curr, hyper.valid_labels );     
        result = ccc;
        results(c) = result;
    end
    
    % option of no cutoff as well
    cutoffs = cat(2,cutoffs, -1);
    prediction(prediction<0)=0;
    prediction(prediction>5)=5;
    [ ~, ~, ~, ccc, ~, ~ ] = evaluate_regression_results( prediction, hyper.valid_labels );     
    
    results(end) = ccc;

    [best, best_id] = max(results);
    result = results(best_id);
    model.cutoff = cutoffs(best_id);
    model.vid_ids = hyper.vid_ids;
    model.success = hyper.success;
    
    if(isfield(hyper, 'eval_ids'))
        model.eval_ids = hyper.eval_ids;
    end    
    
end