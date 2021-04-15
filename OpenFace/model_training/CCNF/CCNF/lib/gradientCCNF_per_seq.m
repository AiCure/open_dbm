function [ gradient_alphas, gradient_betas, gradient_thetas, SigmaInv, CholDecomp, Sigma ] = gradientCCNF_per_seq( alphas, betas, thetas, precalc_Bk, xq, yq, curr_resp, b, precalc_y_B_y, Precalc_Bk_flat, a_precalc, precalc_eye, precalc_zeros)
%gradientCCNF_per_seq Compute the partial derivatives for a single sequence
   
    % This is an optimised version as it does not use the whole matrix but
    % a lower diagonal part due to symmetry
    n = size(xq, 2);
    [SigmaInv] = CalcSigmaCCNFflat(alphas, betas, n, Precalc_Bk_flat, precalc_eye, precalc_zeros);
    
    % Get the actual sigma from out SigmaInv
    % Optimised for symmetric matrices
    CholDecomp=chol(SigmaInv);
    Sigma=CholDecomp\(CholDecomp'\precalc_eye);

    % mu = SigmaInv \ b = Sigma * b;
    % as we've calculate Sigma already, this is equivalent of the above
    mu = Sigma * b;    
   
    % calculating the derivative of L with respect to alpha_k (Equation 27)       
    % gradientAlphas =  (-yq'*yq +(2*yq'*D')' -2 * D * mu + sum(mu.^2) + trace(Sigma));
    % curr_resp is D from the paper
    
    yqq = -yq'*yq;
    curr_resp_yq = (2*curr_resp*yq);
    gradient_alphas = yqq +  curr_resp_yq + -2 * curr_resp * mu + mu' * mu +  sum(diag(Sigma));

    gradient_betas = zeros(size(betas));    
    
    K2 = numel(betas);
    
    % calculating the derivative of log(L) with respect to the betas
    for k=1:K2
        % From Equation 38 (and 39 for gamma)
        % gradient = -yq'*B^(k)*yq + mu'*B^(k)*mu + Vec(Sigma)'*vec(B^(k)
        
        % We precalculate B^(k) (equation 30), as it does not change
        % over the course of optimisation        
        B_k = precalc_Bk{k};

        % Vec(Sigma)*Vec(B^(k)) can be computed as follows:
        partition_gradient = Sigma(:)'*B_k(:);
        
        % Equation 38 and 39 basically
        dLdb = precalc_y_B_y(k) + mu'*B_k*mu + partition_gradient;
        
        gradient_betas(k) = dLdb;
    end

    % Equation 46 from the appendix
    gradient_thetas = (yq - mu)' * a_precalc';
    
    gradient_thetas = (reshape(gradient_thetas, size(thetas')))';

end