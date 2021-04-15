function [ SigmaInv] = CalcSigmaCCRFflat(alphas, betas, n, PrecalcB_flat)
%CALCSIGMAPRF Summary of this function goes here
%   Detailed explanation goes here
% constructing the Sigma (that is laid out in an efficient way for
% symmertic matrices
 
    A = sum(alphas) * eye(n);

    % calculating the B from the paper
    % using the precalculated lower triangular elements of B without beta
    Btmp = PrecalcB_flat * betas;        
    
    % not faster

    % now make it into a square symmetric matrix
    B = zeros(n,n);
    on = tril(true(n,n));
    B(on) = Btmp;
    B = B';
    B(on) = Btmp;
    
    % Combine A and B
    SigmaInv = 2 * (A + B);

end

