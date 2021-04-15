function [ scaling ] = getScaling2(  alphas, betas, x, y, PrecalcBs)
%getScaling Summary of this function goes here
%   Detailed explanation goes here

% for visualisation use only the first sequence
nExamples = numel(x);

cat_y = [];
cat_y_pred = [];

for q=1:nExamples
     
    
    PrecalcB = PrecalcBs{q};
    SigmaInv = CalcSigmaCCRF(alphas, betas, PrecalcB);

    b = CalcbCCRF(alphas, x{q});
    y_est = SigmaInv \ b;
        
    cat_y = cat(1, cat_y, y{q} - mean(y{q}));
%     cat_y = cat(1, cat_y, y{q});
    cat_y_pred = cat(1, cat_y_pred, y_est);
    
end
 
% scaling = (max(cat_y) - min(cat_y)) / (max(cat_y_pred) - min(cat_y_pred));
scaling = std(cat_y) / std(cat_y_pred);

end

