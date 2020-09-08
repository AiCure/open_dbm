function [ SigmaInv] = CalcSigmaCCNFflat(alphas, betas, n, precalc_B_without_beta, precalc_eye, precalc_zeros)
%CALCSIGMACCNFflat Computing SigmaInv matrices (represented as a vector as
%it is a symmetric matrix)
 
    A = sum(alphas) .* precalc_eye;

    % calculating the B + C from the paper (here referred to as B)   
    Btmp = precalc_B_without_beta * betas;        

    B = precalc_zeros;
    on = tril(true(n,n));
    B(on) = Btmp;
    B = B';
    B(on) = Btmp;
    
    SigmaInv = 2 * (A + B);

end

