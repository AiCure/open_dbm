function b = CalcbCCNF( alpha, theta, x, resps)
%CALCBCCNF Compute the b from CCNF equation

    % Either responses from the neural layers are precomputed and provided
    % in resps or need to compute it yourself
    if(nargin < 4)
        X = [ones(size(x,1),1), x];
        h1 = 1./(1 + exp(-theta * X'));
        b = (2 * alpha' * h1)';
    else
        b = (2 * alpha' * resps)';
    end
end

