function [ normalisation_options ] = Parse_settings( sigma, patch_type, ratio_neg, num_samples, varargin)
%PARSE_SETTINGS Summary of this function goes here
%   Detailed explanation goes here

    % creating the parameters to use when training colour (intensity) patches 
    normalisation_options = struct;

    % this is what currently is expected (although could potentially have
    % bigger or smaller support regions    
    normalisation_options.patchSize = [11 11];

    % The region size of a region that is taken for training around an
    % aligned or misaligned landmark
    if(sum(strcmp(varargin,'normalisation_size')))
        ind = find(strcmp(varargin,'normalisation_size')) + 1;
        normalisation_options.normalisationRegion = [varargin{ind}, varargin{ind}];
    else
       normalisation_options.normalisationRegion = [21 21];
    end
        
    % This specifies the split of data ratios
    normalisation_options.svmRatio = 0.8; % proportion of data used for training SVR
    normalisation_options.logitRatio = 0.1; % proportion of data for training logistic regressors
    % the rest is used for testing and provides the correlation and rms scores

    % should normalised cross correlation or just cross correlation should
    % be used on the patch as an SVR
    normalisation_options.useNormalisedCrossCorr = 1;
       
    % the patch types to be used (for now 'reg' (raw pixel values), and
    % 'grad' (gradient intensity values)
    normalisation_options.patch_type = patch_type; 

    % number of training samples to use
    normalisation_options.numSamples = num_samples;    

    normalisation_options.sigma = sigma;
    
    normalisation_options.rate_negative = ratio_neg;
    
end

