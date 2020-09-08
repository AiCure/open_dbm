function [result, prediction] = svr_test_linear_shift(test_labels, test_samples, model)
   
    prediction = test_samples * model.w(1:end-1)' + model.w(end);
%     prediction = predict(test_labels, test_samples, model);

    prediction(~model.success) = 0;
    
    if(model.cutoff >= 0)
        % perform shifting here per person
        users = unique(model.vid_ids);

        for i=1:numel(users)

            preds_user = prediction(strcmp(model.vid_ids, users(i)));
            sorted = sort(preds_user);

            % alternative, move to histograms and pick the highest one

            shift = sorted(round(end*model.cutoff)+1);

            prediction(strcmp(model.vid_ids, users(i))) = preds_user - shift;

        end
    end
    
    % Cap the prediction as well
    prediction(prediction<0)=0;
    prediction(prediction>5)=5;
    
    % using the average of RMS errors
%     result = mean(sqrt(mean((prediction - test_labels).^2)));  
    if(~isfield(model, 'eval_ids'))
        result = corr(test_labels, prediction);
        [ ~, ~, ~, ccc, ~, ~ ] = evaluate_regression_results( prediction, test_labels ); 
        result = ccc;
    else
        eval_ids = unique(model.eval_ids)';
        ccc = 0;
        fprintf('CCC: ');
        for i=eval_ids
            [ ~, ~, ~, ccc_curr, ~, ~ ] = evaluate_regression_results( prediction(model.eval_ids == i), test_labels(model.eval_ids == i) ); 
            ccc = ccc + ccc_curr;
            fprintf('%.3f ', ccc_curr);
        end
        ccc = ccc / numel(eval_ids);
        fprintf('mean : %.3f\n', ccc);
        result = ccc;
    end
    
    if(isnan(result))
        result = 0;
    end
    
end