function [ SigmaInv] = CalcSigmaCCRF(alphas, betas, precalcBwithoutBeta )
%CALCSIGMAPRF Summary of this function goes here
%   Detailed explanation goes here
% constructing the sigma
 
    % the number of elements in a current sequence
    n = size(precalcBwithoutBeta{1},1);

    q1 = sum(alphas) * eye(n);
 
    % the above code can be simplified by the following 2 lines of the
    % inner loop, we want to do that for every beta however
    K2 = numel(betas);

    q2 = zeros([n,n]);

    % calculating the q2 from the paper
    for i=1:K2

        % We're basically performing the following calculation, but use
        % precalculated D - S instead of doing it every iteration
%         S = Similarities(:,:,i);
%         D =  diag(sum(S));
%         q = betas(i) * D - betas(i) * S;
%         q2s(:,:,i) = q;
%         q2 = q2 + betas(i)*precalcQ2withoutBeta(:,:,i);
        q2 = q2 + betas(i)*precalcBwithoutBeta{i};
    end
    % This is another alternative, does not seem to be faster
%     q2old = sum(bsxfun(@times, precalcQ2withoutBeta, reshape(betas,[1,1,K2])),3);

%     q2 = sum(q2s, 3);
%     % An alternative way of calculating the above could be using bsxfun,
%     but this seems to be actually slower than using it
%     S = bsxfun(@times, Similarities, -reshape(betas,[1,1,K2]));
% 
%     % now need the diagonals
%     d = sum(Similarities);
% 
%     I = repmat(eye(n), [1, 1, K2]);
%     I = bsxfun(@times, I, reshape(betas,[1,1,K2]));
%     D = bsxfun(@times, I, d);
% 
%     q2s = D + S;
%     q2 = sum(q2s2,3);
    
    SigmaInv = 2 * (q1 + q2);

end

