function logL = LogLikelihoodCCNF(ys, xs, alphas, betas,thetas,...
                                  lambda_a,lambda_b,lambda_th, Precalc_Bs_flat,...
                                  SigmaInvs, ChDecomps, Sigmas, bs, const, num_seq, all_X_resp)
% Calculating the log likelihood of the CCNF

logL = 0;

% If sequences are of different lengths
if(~const)
    
    % y can either be in cell format (diff length seqs.) or in matrix
    %, same length seqs
    beg_ind = 1;
    
    if(iscell(ys))
        end_ind = numel(ys{1});
        y_cell = true;
    else
        end_ind = size(ys,1);
        y_cell = false;
    end
    
    for q=1:num_seq
        
        % Don't take the bias term
        xq = xs(2:end, beg_ind:end_ind);
        
        if(y_cell)
            yq = ys{q};
        else
            yq = ys(:,q);
        end
        
        n = size(xq, 2);
        
        % Compute b if not provided (they might be, as
        % calculation of gradient involves these terms)        
        if(~isempty(bs))
            b = bs(beg_ind:end_ind)';
        else
            b = CalcbCCNF(alphas, thetas, xq');
        end
        
        % Same goes for inverse of Sigma
        if(isempty(SigmaInvs))
            precalc_eye = eye(n);
            precalc_zeros = zeros(n);
            
            [SigmaInv] = CalcSigmaCCNFflat(alphas, betas, n, Precalc_Bs_flat{q}, precalc_eye, precalc_zeros);                        
            mu = SigmaInv \ b;
                     
            % Used for normalisation term
            L = chol(SigmaInv);
        else
            SigmaInv = SigmaInvs{q};
            Sigma = Sigmas{q};
            mu = Sigma * b;
                        
            % Used for normalisation term
            L = ChDecomps{q};
        end
        
        % normalisation = 1/((2*pi)^(n/2)*sqrt(det(Sigma)));
        % Removing the division by pi, as it is constant
        % normalisation = 1/(sqrt(det(sigma)));
        % flipping around determinant of SigmaInv, as det(inv(Sigma)) = inv(det(Sigma)
        % normalisation = log(sqrt(det(SigmaInv)));
        
        % log of normalisation using Cholesky decomposition (faster and more
        % numerically stable)
        log_normalisation = sum(log(diag(L))); % no times 2 here as we calculate the square root of determinant
        
        % prob_q = normalisation * exp(-0.5 * (y - mu)'*SigmaInv*(y-mu));
        % applying a logarithm to this leads to
        % logLq = log(normalisation) + (-0.5 * (yq - mu)'*SigmaInv*(yq-mu));
        logLq = log_normalisation + (-0.5 * (yq - mu)'*SigmaInv*(yq-mu));
        
        % Add the current likelihood to the running sum
        logL = logL + logLq;
        
        % Update the references to sequence start/end
        if(q ~= num_seq)
            beg_ind = end_ind + 1;
            if(iscell(ys))
                end_ind = end_ind + numel(ys{q+1});
            else
                end_ind = end_ind + size(ys,1);
            end
        end
    end
else

    % A version where each sequence is same length and has the same
    % connections
    seq_length = size(ys,1);
    num_seqs = size(ys,2);
    if(isempty(SigmaInvs))
            
        % If not provided compute the neuron activation (Response)
        if(nargin < 16)
            all_X_resp = 1./(1 + exp(-thetas * xs));
        end
        
        % Combine the neuron responses to b
        all_bs = 2*alphas' * all_X_resp;
    
        precalc_eye = eye(seq_length);
        precalc_zeros = zeros(seq_length);
        
        % Compute Sigma for one of the sequences (same for all so can
        % reuse)
        [SigmaInv] = CalcSigmaCCNFflat(alphas, betas, seq_length, Precalc_Bs_flat{end}, precalc_eye, precalc_zeros);
        
        % A faster way of inverting a symmetric matrix
        CholDecomp = chol(SigmaInv);        
        Sigma=CholDecomp\(CholDecomp'\precalc_eye);

        % mu values associated with each time step
        mus = Sigma * reshape(all_bs, seq_length, num_seqs);        
        
    else
        SigmaInv = SigmaInvs;
        CholDecomp = ChDecomps;
        Sigma = Sigmas;
        mus = Sigma * reshape(bs, seq_length, num_seqs);        
    end
    
    log_normalisation = num_seqs * sum(log(diag(CholDecomp)));
    
    % Compute the sum across every sequence of
    % (yq - mu)'*SigmaInv*(yq-mu) and add to normalisation term
    ymu = (ys - mus);    
    y1 = SigmaInv * ymu;    
    
    logL = log_normalisation - 0.5 *  ymu(:)'* y1(:);
end

% add regularisation term
logL = logL -lambda_b * (betas'*betas)/2 - lambda_a * (alphas'*alphas)/2 - lambda_th * (thetas(:)'*thetas(:))/2;
