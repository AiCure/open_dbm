function [ score ] = ranking_score( weights, lhoods, view_used, errors )
%RANKING_SCORE Summary of this function goes here
%   Detailed explanation goes here
    
    weights_scale = ones(size(lhoods));
    % As views 2-7, 3-6, 4-5 are mirrors of each other, trust their
    % assessment the same amount
%     weights_scale(view_used == 1) = weights(1);
    weights_scale(view_used == 2) = weights(1);
    weights_scale(view_used == 3) = weights(2);
    weights_scale(view_used == 4) = weights(3);
    weights_scale(view_used == 5) = weights(3);
    weights_scale(view_used == 6) = weights(2);
    weights_scale(view_used == 7) = weights(1);
    
    weights_add = zeros(size(lhoods));
%     weights_add(view_used == 1) = weights(5);
    weights_add(view_used == 2) = weights(4);
    weights_add(view_used == 3) = weights(5);
    weights_add(view_used == 4) = weights(6);
    weights_add(view_used == 5) = weights(6);
    weights_add(view_used == 6) = weights(5);
    weights_add(view_used == 7) = weights(4);

    lhoods = lhoods .* weights_scale + weights_add;
    [~, inds] = sort(lhoods');
    inds_best = inds(end,:);
    inds_second_best = inds(end-1,:);
%     [~,max_lhoods] = max(lhoods');

    [~, min_errors] = min(errors');

    % Count both the best and second best errors
    score = mean(inds_best == min_errors);
%     score = mean(inds_best == min_errors | inds_second_best == min_errors);
%     inds_to_err = sub2ind(size(errors),[1:length(max_lhoods)]',max_lhoods');
%     err = mean(errors(inds_to_err));
%     err2 = median(errors(inds_to_err));
%     score = err;
end

