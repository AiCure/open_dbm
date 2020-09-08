function [result, prediction] = svr_test_linear(test_labels, test_samples, model)

    prediction = test_samples * model.w(1:end-1)' + model.w(end);
    
    prediction(~model.success) = 0;
    
    prediction(prediction<0)=0;
    prediction(prediction>5)=5;
    
    % using CCC as the evaluation metric
    % using the average of CCC errors if different datasets are used
    if(~isfield(model, 'eval_ids'))
        result = corr(test_labels, prediction);
        [ ~, ~, ~, ccc, ~, ~ ] = evaluate_regression_results( prediction, test_labels ); 
        result = ccc;
        fprintf('CCC: %.3f\n', ccc);
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