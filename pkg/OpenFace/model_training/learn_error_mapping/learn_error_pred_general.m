clear;

load('./results/results_ceclm_general.mat');

% Generate a lot of possibilities and find best
weights = [1,1,1,0,0,0];
score_base = ranking_score(weights, experiment.lhoods, experiment.all_views_used, experiment.errors_view);
scores = zeros(1,1000);
score = score_base;
weights_all = zeros(1000,6);
for i=1:1000

    scores(i) = score;
    weights_all(i,:) = weights;
%         weights = weights + (0.999^i)*0.3 * ranking_score_grad(weights, l_hoods_view, experiment.all_views_used, errors_view);
    weights = weights + (0.999^i)*0.3 * ranking_score_grad(weights, experiment.lhoods, experiment.all_views_used, experiment.errors_view);
    score = ranking_score(weights, experiment.lhoods, experiment.all_views_used, experiment.errors_view);
end
[~,id] = max(scores);
weights_lhoods = weights_all(id,:);

%% Learn the cuttof
view_used = experiment.all_views_used;
weights_scale = ones(size( experiment.lhoods));
% As views 2-7, 3-6, 4-5 are mirrors of each other, trust their
% assessment the same amount
weights_scale(view_used == 2) = weights_lhoods(1);
weights_scale(view_used == 3) = weights_lhoods(2);
weights_scale(view_used == 4) = weights_lhoods(3);
weights_scale(view_used == 5) = weights_lhoods(3);
weights_scale(view_used == 6) = weights_lhoods(2);
weights_scale(view_used == 7) = weights_lhoods(1);

weights_add = zeros(size(experiment.lhoods));
weights_add(view_used == 2) = weights_lhoods(4);
weights_add(view_used == 3) = weights_lhoods(5);
weights_add(view_used == 4) = weights_lhoods(6);
weights_add(view_used == 5) = weights_lhoods(6);
weights_add(view_used == 6) = weights_lhoods(5);
weights_add(view_used == 7) = weights_lhoods(4);

lhoods = experiment.lhoods .* weights_scale + weights_add;

% As a very reliable detection, make sure that 98% of cases have high
% accuracy (less than 0.1)
% That is find the smallest number which leads to good accuracy
cutoffs = [];
for i=1:4
    ids = view_used==i;
    if(i > 1)
        if(i==2)
            mirr_id = 7;
        elseif(i==3)
            mirr_id = 6;
        elseif(i==4)
            mirr_id = 5;
        end
        ids = ids | view_used==mirr_id;
    end
    lhood_view = lhoods(ids);
    error = experiment.errors_view(ids);
    
    for c=-2:0.01:2
        if(mean(error(lhood_view >c)<0.1) >= 0.98)
            break;
        end
    end
    cutoffs = cat(1, cutoffs, c);
end
cutoffs = [cutoffs(1), cutoffs(2), cutoffs(3), cutoffs(4), cutoffs(4), cutoffs(3), cutoffs(2)];
weights_scale = weights_lhoods(1:end/2);
weights_scale = [1, weights_scale(1), weights_scale(2), weights_scale(3), weights_scale(3), weights_scale(2), weights_scale(1)];
weights_add = weights_lhoods(end/2+1:end);
weights_add = [0, weights_add(1), weights_add(2), weights_add(3), weights_add(3), weights_add(2), weights_add(1)];
early_term_params.weights_scale = weights_scale;
early_term_params.weights_add = weights_add;
early_term_params.cutoffs = cutoffs;
save('cen_general_mapping', 'early_term_params');