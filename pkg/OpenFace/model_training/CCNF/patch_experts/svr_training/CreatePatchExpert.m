function [ patch_expert, corr, rms_error] = CreatePatchExpert( samples, labels, unnormed_samples, normalisation_options)
%CREATEPATCHEXPERT Summary of this function goes here
%   Detailed explanation goes here

    num_examples = size(samples, 1);
    
    region_length = normalisation_options.normalisationRegion - normalisation_options.patchSize + 1;
    region_length = region_length(1) * region_length(2);    
    
    % this part sets the split boundaries for SVR training, logit training and test subsets
    train_SVR_start = 1;        
    train_SVR_end = int32(normalisation_options.svmRatio * num_examples - 1);
    train_SVR_end = train_SVR_end - mod(train_SVR_end, region_length);

    train_logit_start = train_SVR_end + 1;
    train_logit_end = train_logit_start + int32(normalisation_options.logitRatio * num_examples) - 1;
    
    % make sure it ends within same area of interest (region)
    train_logit_end = train_logit_end - mod(train_logit_end, region_length);
        
    test_start = train_logit_end + 1;
    test_end = size(samples,1);

    % picking training data for SVR
    examples_train_SVR = samples(train_SVR_start:train_SVR_end, :);   
    labels_train_SVR = labels(train_SVR_start:train_SVR_end);         
    
    % Train the SVR using liblinear (older version used libSVM,
    % but liblinear is much faster)
    [w, b] = Train_SVR(examples_train_SVR, labels_train_SVR);
    
    % Now create the test dataset
    examples_test = samples(test_start:test_end, :);                                                
    labels_test = labels(test_start:test_end);

    % Training the logistic regressor now
    examples_train_logit = samples(train_logit_start:train_logit_end, :);                                                
    labels_train_logit = labels(train_logit_start:train_logit_end, :);     

    patch_expert = CreateLogisticRegressor(examples_train_logit, labels_train_logit, w, b, normalisation_options);

    % Evaluate the patch expert now
    [rms_error, corr, ~] = EvaluatePatchExpert(examples_test, labels_test, patch_expert, false);

    fprintf('Rms error %.3f, correlation %.3f\n', rms_error, corr);
    
    % Assert that our implementation and the convolution based one are equivalent    
    [~, ~, responses_svm] = EvaluatePatchExpert(samples(1:size(unnormed_samples,1)*region_length,:), labels(1:size(unnormed_samples,1)*region_length), patch_expert, false);
    [responses_ncc] = SVR_expert_ncc_response(unnormed_samples, patch_expert, normalisation_options, normalisation_options.normalisationRegion, region_length);
    assert(mean(abs(responses_svm-responses_ncc))< 1e-2);
    
end

