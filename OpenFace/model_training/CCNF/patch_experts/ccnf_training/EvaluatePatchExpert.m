function [ meanSquaredError, correlation, predictions ] = EvaluatePatchExpert( samples, labels, alphas, betas, thetas, similarities, sparsities, normalisationOptions, region_length )
%EVALUATEPATCHEXPERT Summary of this function goes here
%   Detailed explanation goes here
   
    num_seqs = size(samples, 2)/region_length;
                        
    % adding the bias term, and transposing to optimise
    labels = reshape(labels, region_length, num_seqs);

    [~,~,~, ~, correlation, meanSquaredError, predictions] = evaluate_CCNF_model(alphas, betas, thetas, samples, labels, similarities, sparsities, 0, 1, false);

end

