function [ auc_out ] = auc( error_vec )
%AUC Summary of this function goes here
%   Detailed explanation goes here
    cutoff = 0.08;

    [x,y] = cummErrorCurve(error_vec);
    
    all_xs = x(x < cutoff);
    all_ys = y(1:numel(all_xs));
    
    auc_out = sum(all_ys) / numel(all_ys);
    
end

