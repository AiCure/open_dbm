function b = CalcbCCRF( alpha, x)
%CALCBPRF Summary of this function goes here
%   Detailed explanation goes here

%     b = zeros(size(x,1),1);
% 
%     for i=1:size(x,1)
%        b(i) = 2 *  x(i,:) * alpha; 
%     end

    % vectorising above code
    b = 2 * x * alpha;
end

