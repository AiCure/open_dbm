function [ logGradientAlphas, logGradientBetas, SigmaInv, CholDecomp, Sigma ] = gradientCCRF_withoutReg( alphas, betas, precalcQ2withoutBeta, xq, yq, Precalc_yBy, PrecalcB_flat)
%GRADIENTPRF Summary of this function goes here
%   Detailed explanation goes here

    % Calculate the Sigma inverse now
    
    % This is an optimised version as it does not use the whole matrix but
    % a lower diagonal part due to symmetry
    n = size(xq, 1);
    [SigmaInv] = CalcSigmaCCRFflat(alphas, betas, n, PrecalcB_flat);
    
    % Get the actual sigma from out SigmaInv
    
    % Sigma = inv(SigmaInv);
    % Below is an optimised version of the above using Cholesky decomposition
    % which decomposes a matrix into a upper triangular (R) and its
    % conjugate transpose R'; A = R'*R for real numbers, thus
    % inv(A) = inv(R)inv(R')

    CholDecomp=chol(SigmaInv);
    I=eye(size(SigmaInv));    
    
    % This is a way of calculating it faster than just inv(SigmaInv)
    Sigma=CholDecomp\(CholDecomp'\I);
    b = CalcbCCRF(alphas, xq);

    % mu = SigmaInv \ b = Sigma * b;
    % as we've calculate Sigma already, this is equivalent of the above
    mu = Sigma * b;    
   
    logGradientAlphas = zeros(size(alphas));
    logGradientBetas = zeros(size(betas));

    K1 = numel(alphas);
    K2 = numel(betas);

    % calculating the derivative of L with respect to alpha_k        
    for k = 1:K1

        gaussGradient = -yq'*yq +2*yq'*xq(:,k) -2 * xq(:,k)' * mu + sum(mu.^2);

        % simplification as trace(Sigma * I) = trace(Sigma)
        zGradient = trace(Sigma);
        
        % add the Z (partition function) derivative now
        dLda = zGradient + gaussGradient;

        logGradientAlphas(k) = dLda;

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
        gaussGradient = Precalc_yBy(k) + mu'*dSdb*mu;
        
        % zGradient = trace(Sigma*dSdb);
        zGradient = Sigma(:)'*dSdb(:); % equivalent but faster to the above line
        
        dLdb = gaussGradient + zGradient;
        
        logGradientBetas(k) = dLdb;
    end
end