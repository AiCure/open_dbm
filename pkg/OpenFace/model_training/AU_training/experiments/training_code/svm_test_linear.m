function [result, prediction] = svm_test_linear(test_labels, test_samples, model)

    w = model.w(1:end-1)';
    b = model.w(end);

    % Attempt own prediction
    prediction = test_samples * w + b;
    l1_inds = prediction > 0;
    l2_inds = prediction <= 0;
    prediction(l1_inds) = model.Label(1);
    prediction(l2_inds) = model.Label(2);
 
    if(~isfield(model, 'eval_ids'))
        tp = sum(test_labels == 1 & prediction == 1);
        fp = sum(test_labels == 0 & prediction == 1);
        fn = sum(test_labels == 1 & prediction == 0);
        tn = sum(test_labels == 0 & prediction == 0);

        precision = tp/(tp+fp);
        recall = tp/(tp+fn);

        f1 = 2 * precision * recall / (precision + recall);
        fprintf('F1:%.3f\n', f1);
    else
        % If we have evaluation ids compute F1 for each of them separately,
        % this is because we want a mean F1 accross datasets and not one
        % datasets samples dominating
        eval_ids = unique(model.eval_ids)';
        f1 = 0;
        fprintf('F1: ');
        for i=eval_ids
            tp = sum(test_labels(model.eval_ids == i) == 1 & prediction(model.eval_ids == i) == 1);
            fp = sum(test_labels(model.eval_ids == i) == 0 & prediction(model.eval_ids == i) == 1);
            fn = sum(test_labels(model.eval_ids == i) == 1 & prediction(model.eval_ids == i) == 0);
            tn = sum(test_labels(model.eval_ids == i) == 0 & prediction(model.eval_ids == i) == 0);

            precision = tp/(tp+fp);
            recall = tp/(tp+fn);

            f1_curr = 2 * precision * recall / (precision + recall);        
            if(isnan(f1_curr))
                f1_curr = 0;
            end
            f1 = f1 + f1_curr;
            fprintf('%.3f ', f1_curr);
        end
        f1 = f1 / numel(eval_ids);
        fprintf('mean : %.3f\n', f1);
    end
    

    if(isnan(f1))
        f1 = 0;
    end
    result = f1;
end