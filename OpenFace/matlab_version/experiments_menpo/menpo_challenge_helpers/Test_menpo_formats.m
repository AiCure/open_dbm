clear;
load('results/results_valid_dclm_menpo.mat');

% First compute the error
[errors, frontal_ids] = compute_error_menpo_1(experiments.labels, experiments.shapes);
labels_f = experiments.labels(frontal_ids);
shapes_f = experiments.shapes(frontal_ids);
errors_f = errors(frontal_ids);
for i=1:10
   
    write_menpo_frontal(shapes_f{i} + 0.5, sprintf('tmp/%d.pts', i));
    
    preds = importdata(sprintf('tmp/%d.pts', i), ' ', 3);
    landmarks = preds.data;
    
    [err] = compute_error_menpo_unb(labels_f(i), {landmarks});
    
end

%%
labels_p = experiments.labels(~frontal_ids);
shapes_p = experiments.shapes(~frontal_ids);
errors_p = errors(~frontal_ids);
v_used = experiments.all_views_used(~frontal_ids);
load('../pdm_generation/menpo_pdm/conversion.mat');
load('../pdm_generation/menpo_pdm/menpo_68_pts_valid_profile.mat');
ind_left = 1;
ind_right = 1;
for i=1:10
       
    if(v_used(i) == 2 || v_used(i) == 3 || v_used(i) == 6)
        write_menpo_profile(shapes_p{i} + 0.5, sprintf('tmp/%d.pts', i), a_left, vis_pts_left);
        labs = all_pts_orig_left(:,:,ind_left);
        ind_left = ind_left + 1;
    else
        write_menpo_profile(shapes_p{i} + 0.5, sprintf('tmp/%d.pts', i), a_right, vis_pts_right);
        labs = all_pts_orig_right(:,:,ind_right);
        ind_right = ind_right + 1;
    end

    preds = importdata(sprintf('tmp/%d.pts', i), ' ', 3);
    landmarks = preds.data;
    [err] = compute_error_prof_unb({labs}, {landmarks});
    
end