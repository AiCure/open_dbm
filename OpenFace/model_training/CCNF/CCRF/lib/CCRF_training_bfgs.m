function [ alphas, betas, scaling, finalLikelihood] = CCRF_training_bfgs( num_seqs, thresholdX, thresholdFun, x, y, yUnnormed, alphas, betas, lambda_a, lambda_b, similarityFNs, Precalc_Bs, Precalc_Bs_flat, Precalc_yBys, varargin)
%GRADIENTDESCENTCCRF Performs CCRF gradient descen given the initial state
%and gradient descent parameters
%   Detailed explanation goes here

    % if these are not provided calculate them, TODO this might be
    
    % It is possible to predefine the component B^(k) required 
    % to compute B term and partial derivatives, also can predefine yB^(k)y,
    % as they also do not change through the iterations
    if(sum(strcmp(varargin,'PrecalcBs')) && sum(strcmp(varargin,'PrecalcBsFlat'))...
             && sum(strcmp(varargin,'Precalc_yBy')))
         
        ind = find(strcmp(varargin,'PrecalcBs')) + 1;
        Precalc_Bs = varargin{ind};

        ind = find(strcmp(varargin,'PrecalcBsFlat')) + 1;
        Precalc_Bs_flat = varargin{ind};

        ind = find(strcmp(varargin,'Precalc_yBys')) + 1;
        Precalc_yBys = varargin{ind};
    else
        % if these are not provided calculate them        
        [ ~, Precalc_Bs, Precalc_Bs_flat, Precalc_yBys ] = CalculateSimilarities( num_seqs, x, similarityFNs, y);
    end              
    
    params = [alphas; betas];
    
    objectiveFun = @(params)objectiveFunction(params, numel(alphas), lambda_a, lambda_b, Precalc_Bs, x, y, Precalc_yBys, Precalc_Bs_flat);

    options = optimset('Algorithm','interior-point','GradObj','on', 'TolX', thresholdX, 'TolFun', thresholdFun, 'Hessian', 'bfgs', 'display','off', 'useParallel', 'Always');
    
    if(sum(strcmp(varargin,'max_iter'))) 
        options.MaxIter = varargin{find(strcmp(varargin,'max_iter')) + 1};
    end      

    params = fmincon(objectiveFun, params, [], [],[],[], zeros(numel(params),1), Inf(numel(params), 1), [], options);
    alphas = params(1:numel(alphas));
    betas = params(numel(alphas)+1:end);

    finalLikelihood = LogLikelihoodCCRF(y, x, alphas, betas, lambda_a, lambda_b, Precalc_Bs_flat);
%     fprintf('Final log likelihood at iteration; logL %f, learning rate\n', finalLikelihood);
    
    % establish the scaling
    scaling = getScaling2(alphas, betas, x, yUnnormed, Precalc_Bs);

end

function [loss, gradient] = objectiveFunction(params, numAlpha, lambda_a, lambda_b, PrecalcBs, x, y, Precalc_yBys, PrecalcBsFlat)
    
    alphas = params(1:numAlpha);
    betas = params(numAlpha+1:end);
    [gradient, SigmaInvs, CholDecomps, Sigmas] = gradientCCRFFull(params, lambda_a, lambda_b, PrecalcBs, x, y, Precalc_yBys, PrecalcBsFlat);
    % as bfgs does gradient descent rather than ascent, negate the results
    gradient = -gradient;
    loss = -LogLikelihoodCCRF(y, x, alphas, betas, lambda_a, lambda_b, PrecalcBsFlat, SigmaInvs, CholDecomps, Sigmas);
end
