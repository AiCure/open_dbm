function [ normalisation_options ] = Parse_settings( sigma, ratio_neg, num_samples, varargin)
%PARSE_SETTINGS Summary of this function goes here
%   Detailed explanation goes here

    % creating the parameters to use when training colour (intensity) patches 
    normalisation_options = struct;

    % this is what currently is expected (although could potentially have
    % bigger or smaller patches, this should not be bigger that the patch
    % available in examples and negExamples
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
    normalisation_options.ccnf_ratio = 0.9; % proportion of data used for cross-validating CCNFs
    % the rest is used for testing and provides the F1 and accuracy scores

    if(any(strcmp(varargin, 'patch_types')))
        ind = find(strcmp(varargin,'patch_types')) + 1;
        normalisation_options.patch_type = varargin{ind}; 
    else
        normalisation_options.patch_type = {'reg'};         
    end
    
    if(any(strcmp(varargin, 'sparsity_types')))
        ind = find(strcmp(varargin,'sparsity_types')) + 1;
        if(~isempty( varargin{ind}))
            normalisation_options.sparsity = 1;
            normalisation_options.sparsity_types = varargin{ind}; 
        else
            normalisation_options.sparsity = 0; 
            normalisation_options.sparsity_types = [];
        end
    else
        normalisation_options.sparsity = 0;
        normalisation_options.sparsity_types = [];
    end
    
    if(any(strcmp(varargin, 'lambda_a')))
        ind = find(strcmp(varargin,'lambda_a')) + 1;
        normalisation_options.lambda_a = varargin{ind};            
    end
    
    if(any(strcmp(varargin, 'lambda_b')))
        ind = find(strcmp(varargin,'lambda_b')) + 1;
        normalisation_options.lambda_b = varargin{ind};            
    end
    
    if(any(strcmp(varargin, 'lambda_th')))
        ind = find(strcmp(varargin,'lambda_th')) + 1;
        normalisation_options.lambda_th = varargin{ind};            
    end
    
    if(any(strcmp(varargin, 'num_layers')))
        ind = find(strcmp(varargin,'num_layers')) + 1;
        normalisation_options.num_layers = varargin{ind};            
    end
    
    if(any(strcmp(varargin, 'num_bins')))
        ind = find(strcmp(varargin,'num_bins')) + 1;
        normalisation_options.num_hog_bins = varargin{ind};            
    else    
        normalisation_options.num_hog_bins = 9;
    end
    
    normalisation_options.numSamples = num_samples;
    
    normalisation_options.useZeroMeanPerPatch = 1;
    normalisation_options.useNormalisedCrossCorr = 1;
    normalisation_options.zscore = 0;

    % Should invalid pixels be taken into account when normalising (yes in
    % case of depth and no in case of colour)
    normalisation_options.ignoreInvalidInMeanStd = 0; % we don't care about invalid pixels at this time (black is valid here) TODO background simulation?
    normalisation_options.setIllegalToPost = 0;

    if(sum(strcmp(varargin,'use_bu')))
        ind = find(strcmp(varargin,'use_bu')) + 1;
        normalisation_options.bu = varargin{ind};       
    else
        normalisation_options.bu = 1;
    end
    
    if(sum(strcmp(varargin,'use_mpie')))
        ind = find(strcmp(varargin,'use_mpie')) + 1;
        normalisation_options.mpie = varargin{ind};       
    else
        normalisation_options.mpie = 1;
    end
    
    if(sum(strcmp(varargin,'use_wild')))
        ind = find(strcmp(varargin,'use_wild')) + 1;
        normalisation_options.wild = varargin{ind};       
    else
        normalisation_options.wild = 0;
    end    
    
    normalisation_options.sigma = sigma;
    
    normalisation_options.rate_negative = ratio_neg;
    
    % the similarities need to be tested separately (1,2,3 and 4) and
    % together all, vs hor/ver and diags, and none of course
    if(any(strcmp(varargin, 'similarity_types')))
        ind = find(strcmp(varargin,'similarity_types')) + 1;
        normalisation_options.similarity_types = varargin{ind};
    else        
        normalisation_options.similarity_types = [];
    end    

end

