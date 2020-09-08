function [ partial_grad ] = ranking_score_grad( weights, lhoods, views_used, errors )
%RANKING_SCORE Summary of this function goes here
%   Detailed explanation goes here
    
%     central_score = ranking_score(weights, lhoods, errors);
    
    delta = 0.075;
    
    partial_grad = zeros(size(weights));
    
    for i=1:numel(weights)
       
        w_m = weights;
        w_p = weights;
        w_m(i) = w_m(i) - delta/2;
        w_p(i) = w_p(i) + delta/2;
        
        partial_grad(i) = ranking_score(w_p, lhoods, views_used, errors)-ranking_score(w_m, lhoods, views_used, errors);
        
    end
    partial_grad = partial_grad ./ delta;
end

