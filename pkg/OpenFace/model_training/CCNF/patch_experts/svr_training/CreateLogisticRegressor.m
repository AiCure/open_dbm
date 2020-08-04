function [ patch_expert ] = CreateLogisticRegressor( samples, labels, w, b, normalisation_options)
%CREATELOGISTICREGRESSOR Given positive and negative example patches, and
%an SVR regressor that will be applied to them train a logistic regressor
%that will predict patch probabilities
%   Can either use cross-correlation for applying the regressor or
%   normalised cross-correlation
%   Returns a patch expert which is [scaling, bias, support vectors)
%   p(x) = 1/(1+exp(-(scaling * svmDecBound + bias)))

% before applying the SVR, patch expert weights are normalised
%(as they will be applied using normalised cross-correlation in the end)
meanTmp = mean(w);
w = w - meanTmp;

if(normalisation_options.useNormalisedCrossCorr)
    eTmp = sqrt(sum((w - meanTmp).^2));
    w = w / eTmp;
end

% can now apply the SVR regressor on the training data
svr_response = (w' * samples')';

% Learn a logistic regressor
[bLogit,dev,stats] = glmfit(svr_response, labels,'binomial','link','logit');

scaling = bLogit(2);
bias = bLogit(1);

support = w;

% Combine all the parameters into a patch expert
patch_expert = [scaling; bias; support]';
    
end

