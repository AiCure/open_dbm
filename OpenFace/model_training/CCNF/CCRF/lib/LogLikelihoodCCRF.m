function logL = LogLikelihoodCCRF(y_coll, x_coll, alphas, betas,...
                                  lambda_a,lambda_b, PrecalcBsFlat,...
                                  SigmaInvs, ChDecomps, Sigmas)
% Calculating the log likelihood of the CCRF with multi alpha and beta    

Q = numel(y_coll);
logL = 0;
for q=1:Q
    
    yq = y_coll{q};
    xq = x_coll{q};
    
    n = size(xq, 1);
      
    b = CalcbCCRF(alphas, xq);
            
    % constructing the sigma inverse
    if(nargin < 11)
        [SigmaInv] = CalcSigmaCCRFflat(alphas, betas, n, PrecalcBsFlat{q});
        L = chol(SigmaInv);        
        mu = SigmaInv \ b;
    else
        SigmaInv = SigmaInvs{q};
        L = ChDecomps{q};
        Sigma = Sigmas{q};        
        mu = Sigma * b;
    end    

    % normalisation = 1/((2*pi)^(n/2)*sqrt(det(Sigma)));
    % Removing the division by pi, as it is constant
    % normalisation = 1/(sqrt(det(sigma)));
    % flipping around determinant of SigmaInv, as det(inv(Sigma)) = inv(det(Sigma)  
%     normalisation = log(sqrt(det(SigmaInv)));

    % normalisation 2 using Cholesky decomposition
    normalisation2 = sum(log(diag(L))); % no times 2 here as we calculate the square root of determinant

    % probq = normalisation * exp(-0.5 * (y - mu)'*SigmaInv*(y-mu));
    % applying a logarithm to this leads to
%     logLq = log(normalisation) + (-0.5 * (yq - mu)'*SigmaInv*(yq-mu));
    logLq = normalisation2 + (-0.5 * (yq - mu)'*SigmaInv*(yq-mu));
  
    logL = logL + logLq;
    
end

% add regularisation term
logL = logL -lambda_b * (betas'*betas)/2 - lambda_a * (alphas'*alphas)/2;
