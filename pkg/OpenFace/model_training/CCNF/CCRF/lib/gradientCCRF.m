function [ logGradientAlphas, logGradientBetas, SigmaInv, ChDecomp ] = gradientCCRF( alphas, betas, lambda_a, lambda_b, precalcQ2withoutBeta, xq, yq, mask, precalcYQ, useIndicator, PrecalcQ2Flat)
%GRADIENTPRF Summary of this function goes here
%   Detailed explanation goes here

    % Calculate the Sigma inverse now
%     [SigmaInv2] = CalcSigmaCCRF(alphas, betas, precalcQ2withoutBeta, mask);
    
    % This is an optimised version as it does not use the whole matrix but
    % a lower diagonal part due to symmetry
    numElemsInSeq = size(precalcQ2withoutBeta{1}, 1);
    [SigmaInv] = CalcSigmaCCRFflat(alphas, betas, numElemsInSeq, PrecalcQ2Flat, mask, useIndicator);
    
    % Get the actual sigma from out SigmaInv
    
    % Sigma = inv(SigmaInv);
    % Below is an optimised version of the above using Cholesky decomposition
    % which decomposes a matrix into a upper triangular (R) and its
    % conjugate transpose R'; A = R'*R for real numbers, thus
    % inv(A) = inv(R)inv(R')
    ChDecomp=chol(SigmaInv);
    I=eye(size(SigmaInv));    
        
    % Rinv = (R\I);
    % Sigma = Rinv*Rinv';
    % This is a very slightly faster version of the above
    Sigma=ChDecomp\(ChDecomp'\I);
    
    b = CalcbCCRF(alphas, xq, mask, useIndicator);

    % mu = SigmaInv \ b = Sigma * b;
    % as we've calculate Sigma already, this is equivalent of the above
    mu = Sigma * b;    
   
    logGradientAlphas = zeros(size(alphas));
    logGradientBetas = zeros(size(betas));

    K1 = numel(alphas);
    K2 = numel(betas);

    % calculating the derivative of L with respect to alpha_k        
    for k = 1:K1

        if(useIndicator)
            dQ1da = diag(mask(:,k));
            dbda = xq(:,k).*mask(:,k);
            gaussGradient = -yq'*dQ1da*yq +2*yq'*dbda -2 * dbda' * mu + mu'*dQ1da*mu;
            zGradient = Sigma(:)'*dQ1da(:);
        else
            % if we don't use the masks here's a speedup
            gaussGradient = -yq'*yq +2*yq'*xq(:,k) -2 * xq(:,k)' * mu + sum(mu.^2);
                    
            % simplification as trace(Sigma * I) = trace(Sigma)
            zGradient = trace(Sigma);
        end
        
        % add the Z derivative now
        dLda = zGradient + gaussGradient;
        
        % add regularisation
        dLda = dLda - lambda_a * alphas(k);
 
        logGradientAlphas(k) = alphas(k) * dLda;

    end

    % This was done for gradient checking
%   [alphasG, betaG] = gradientAnalytical(nFrames, S, alphas, beta, xq, yq, mask); 

    % calculating the derivative of log(L) with respect to the betas
    for k=1:K2

        % Bs = Bs(:,:,k);
        % dSdb = q2./betas(k); we precalculate this, as it does not change
        % over the course of optimisation (dSdb - dSigma/dbeta)
        dSdb = precalcQ2withoutBeta{k};

        % -yq'*dSdb*yq can be precalculated as they don't change through
        % iterations (precalcQ2withoutBeta is dSdb
        % gaussGradient = -yq'*dSdb*yq + mu'*dSdb*mu;
        % this does the above line
        gaussGradient = precalcYQ(k) + mu'*dSdb*mu;
        
        % zGradient = trace(Sigma*dSdb);
        zGradient = Sigma(:)'*dSdb(:); % equivalent but faster to the above line
        dLdb = gaussGradient + zGradient;
        
        % add regularisation term
        dLdb = dLdb - lambda_b * betas(k);
        
        logGradientBetas(k) = betas(k) * dLdb;
    end
end