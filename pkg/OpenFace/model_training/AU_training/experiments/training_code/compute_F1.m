function [result] = compute_F1(ground_truth, prediction)

    tp = sum(ground_truth == 1 & prediction == 1);
    fp = sum(ground_truth == 0 & prediction == 1);
    fn = sum(ground_truth == 1 & prediction == 0);
    tn = sum(ground_truth == 0 & prediction == 0);

    precision = tp/(tp+fp);
    recall = tp/(tp+fn);

    f1 = 2 * precision * recall / (precision + recall);   

    if(isnan(f1))
        f1 = 0;
    end
    result = f1;
end