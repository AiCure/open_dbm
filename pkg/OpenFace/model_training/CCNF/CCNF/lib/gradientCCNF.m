function [ gradientParams, SigmaInvs, CholDecomps, Sigmas, bs, allXresp] = gradientCCNF( params, num_alpha, numBeta, sizeTheta, lambda_a, lambda_b, lambda_th, Precalc_Bs, x, y, Precalc_yBys, Precalc_Bs_flat, constant, num_seqs)
%gradientCCNF Summary of this function goes here
%   Detailed explanation goes here
    
    % pick out the relevant terms (unpack)
    alphas_init = params(1:num_alpha);
    betasInit = params(num_alpha+1:num_alpha+numBeta);
    thetasInit = reshape(params(num_alpha+numBeta+1:end), sizeTheta);
            
    % Compute the response from the neural layers        
    allXresp = 1./(1 + exp(-thetasInit * x));
    Xt = x;
            
    bs = 2*alphas_init' * allXresp;
        
    % This is precalculated for the next step and is basically the
    % feedforward step of the neural net
    Z_precalc = 2 * (allXresp .* (1-allXresp));
    
    % These are the outputs weighted by the alphas (see eq TODO
    db2_precalc =  bsxfun(@times, Z_precalc, alphas_init);    
        
    num_feats = sizeTheta(2);    

    if(constant)       
                
        seq_length = size(x,2)/num_seqs;        

        % As the similarities are the same across all series we can reuse our
        % Sigma and SigmaInv calculations
        
        I = eye(seq_length);
        [SigmaInv] = CalcSigmaCCNFflat(alphas_init, betasInit, seq_length, Precalc_Bs_flat{1}, I, zeros(seq_length));
        CholDecomp=chol(SigmaInv);

        % This is a faster way of inverting a symmetric matrix
        Sigma=CholDecomp\(CholDecomp'\I);
        Sigma_trace = trace(Sigma);
            
        % mu values associated with each time step
        mus = Sigma * reshape(bs, seq_length, num_seqs);

        % difference between actual and prediction (error)
        diff = (y - mus);
               
        db_precalc_mult = bsxfun(@times, db2_precalc, diff(:)');
 
        % Equation 46 from the appendix
        gradientThetasT = Xt * db_precalc_mult';

        % Reshape into the correct format
        gradientThetasT = gradientThetasT(:)';
        
        gradientThetasT = reshape(gradientThetasT, sizeTheta(2), sizeTheta(1))';
        gradientThetasT = gradientThetasT(:);
        
        % Some useful precalculations
        
        % for every sequence get a dot product with itself
        yy = dot(y,y);
        
        % same goes for the mu
        mumu = dot(mus,mus);

        % calculating the derivative of L with respect to alpha_k (Equation 27)       
        % gradientAlphas =  (-yq'*yq +(2*yq'*D')' -2 * D * mu + sum(mu.^2) + trace(Sigma));
        % allXresp is D
        gradient_alphas_add = -sum(yy) + sum(mumu) + num_seqs * Sigma_trace;
        gradient_alphas = 2 * allXresp * (y(:) - mus(:)) + gradient_alphas_add;
        
        gradient_betas = zeros(numBeta, 1);
        
        % calculating the derivative of log(L) with respect to the betas
        for k=1:numBeta

            % From Equation 38 (and 39 for gamma)
            % gradient = -yq'*B^(k)*yq + mu'*B^(k)*mu + Vec(Sigma)'*vec(B^(k)

            % We precalculate B^(k) (equation 30), as it does not change
            % over the course of optimisation
            B_k = Precalc_Bs{1}{k};

            % precalculated -yq'*B_k*yq can be used as well as it does not
            % change (stored in Precalc_yBys)
            yq_B_k_yq = sum(Precalc_yBys(:,k));

            % A vectorised version of mu'*B^(k)*mu 
            B_k_mu = B_k*mus;
            mu_B_k_mu = mus(:)' * B_k_mu(:);
            
            % Vec(Sigma)*Vec(B^(k)) can be computed as follows:
            partition_term = num_seqs * Sigma(:)'*B_k(:);
            
            % Equation 38 and 39 basically
            dLdb = yq_B_k_yq + mu_B_k_mu + partition_term; 

            gradient_betas(k) = dLdb;
        end        
        
        gradientParams = [gradient_alphas;gradient_betas;gradientThetasT];            
        
        SigmaInvs = SigmaInv;
        CholDecomps = CholDecomp;
        Sigmas = Sigma;
        
        
    else 
        
        SigmaInvs = cell(num_seqs, 1);
        CholDecomps = cell(num_seqs, 1);
        Sigmas = cell(num_seqs, 1);
        gradients = zeros(num_seqs, numel(params));        
        
        a_precalc = zeros(sizeTheta(2)*sizeTheta(1), size(allXresp,2));

        for i=1:size(db2_precalc,1)
            a_precalc((i-1)*num_feats+1:i*num_feats,:) = bsxfun(@times, Xt, db2_precalc(i,:));
        end        
        
        % y can either be in cell format (diff length seqs.) or in matrix
        %, same length seqs
        beg_ind = 1;        
        
        if(iscell(y))
            end_ind = numel(y{1});
            y_cell = true;
        else
            end_ind = size(y,1);
            y_cell = false;
        end
        
        % Go through every sequence summing the gradients
        for q = 1 : num_seqs

            currResp = allXresp(:,beg_ind:end_ind);
            currB = bs(beg_ind:end_ind)';

            PrecalcB = Precalc_Bs{q};
            PrecalcBFlat = Precalc_Bs_flat{q};

            if(y_cell)
                yq = y{q};
            else
                yq = y(:,q);
            end
            
            xq = x(2:end, beg_ind:end_ind);

            % Used for equation 46 computation
            a_precalc_curr = a_precalc(:,beg_ind:end_ind);

            precalc_eye = eye(numel(yq));
            precalc_zeros = zeros(numel(yq));

            [ gradientsAlphas, gradientsBetas, gradientsThetas, SigmaInv, CholDecomp, Sigma ] = gradientCCNF_per_seq(alphas_init, betasInit, thetasInit, PrecalcB, xq, yq, currResp, currB, Precalc_yBys(q, :), PrecalcBFlat, a_precalc_curr, precalc_eye, precalc_zeros);
            
            gradients(q,:) = [gradientsAlphas; gradientsBetas; gradientsThetas(:)];
            SigmaInvs{q} = SigmaInv;
            CholDecomps{q} = CholDecomp;
            Sigmas{q} = Sigma;

            % Update the references to sequence start/end
            if(q ~= num_seqs)
                beg_ind = end_ind + 1;
                if(iscell(y))
                    end_ind = end_ind + numel(y{q+1});
                else
                    end_ind = end_ind + size(y,1);
                end
            end
            
        end
        
        gradientParams = sum(gradients,1)';
        
    end
    
    % Add the regularisation term
    regAlpha = alphas_init * lambda_a;
    regBeta = betasInit * lambda_b;
    regTheta = thetasInit * lambda_th;
    
    
    gradientParams = gradientParams - [regAlpha; regBeta; regTheta(:)];
end