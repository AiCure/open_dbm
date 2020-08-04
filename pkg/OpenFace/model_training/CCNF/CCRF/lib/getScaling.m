function [ scaling ] = getScaling(  alphas, betas, x, y, masks, PrecalcQ2s, useIndicator)
%getScaling Summary of this function goes here
%   Detailed explanation goes here

% for visualisation use only the first sequence
nExamples = numel(x);

scalings = zeros(1,nExamples);

for q=1:nExamples
     
    mask = masks{q};
    
    PrecalcQ2 = PrecalcQ2s{q};
    SigmaInv = CalcSigmaCCRF(alphas, betas, PrecalcQ2, mask, useIndicator);

    
    b = CalcbCCRF(alphas, x{q}, mask, useIndicator);
    y_est = SigmaInv \ b;
        
    sc = std(y{q}) / std(y_est);
    scalings(q) = sc;
end
 
scaling = mean(scalings);

end

