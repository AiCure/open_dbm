clear
load('menpo_68_pts_train_profile');

vis_pts_left = all_pts_left(:,1,1) ~= -1;
xs = all_pts_left(vis_pts_left,:,:);
xs = squeeze(cat(1, xs(:,1,:), xs(:,2,:)));

ys =  squeeze(cat(1, all_pts_orig_left(:,1,:), all_pts_orig_left(:,2,:)));

a_left = ys /xs;
a_left(abs(a_left)<0.001) = 0;
transformed_left = a_left * xs;
xs_pred_left = transformed_left(1:end/2,:);
ys_pred_left = transformed_left(end/2+1:end,:);

vis_pts_right = all_pts_right(:,1,1) ~= -1;
xs = all_pts_right(vis_pts_right,:,:);
xs = squeeze(cat(1, xs(:,1,:), xs(:,2,:)));

ys =  squeeze(cat(1, all_pts_orig_right(:,1,:), all_pts_orig_right(:,2,:)));

a_right = ys /xs;
a_right(abs(a_right)<0.001) = 0;
transformed_right = a_right * xs;
xs_pred_right = transformed_right(1:end/2,:);
ys_pred_right = transformed_right(end/2+1:end,:);
% pred_left = cat(2,transformed_left

%%
num = 110;
plot(all_pts_orig_right(:,1,num), -all_pts_orig_right(:,2,num), '.r');
hold on;
plot(xs_pred_right(:,num), -ys_pred_right(:,num), '.b');
hold off;

%% Evaluate on the validation data (see how much error is added)

load('menpo_68_pts_valid_profile');

xs = all_pts_left(vis_pts_left,:,:);
xs = squeeze(cat(1, xs(:,1,:), xs(:,2,:)));

transformed_left = a_left * xs;
xs_pred_left = transformed_left(1:end/2,:);
ys_pred_left = transformed_left(end/2+1:end,:);

shapes = cell(size(ys_pred_left,1),1);
labels = cell(size(ys_pred_left,1),1);

for i=1:numel(shapes)
    shapes{i} = cat(2, xs_pred_left(:,i), ys_pred_left(:,i));
    labels{i} = all_pts_orig_left(:,:,i);
end

errors_left = compute_error_menpo_prof(labels, shapes);


xs = all_pts_right(vis_pts_right,:,:);
xs = squeeze(cat(1, xs(:,1,:), xs(:,2,:)));

transformed_right = a_right * xs;
xs_pred_right = transformed_right(1:end/2,:);
ys_pred_right = transformed_right(end/2+1:end,:);

shapes = cell(size(ys_pred_right,1),1);
labels = cell(size(ys_pred_right,1),1);

for i=1:numel(shapes)
    shapes{i} = cat(2, xs_pred_right(:,i), ys_pred_right(:,i));
    labels{i} = all_pts_orig_right(:,:,i);
end

errors_right = compute_error_menpo_prof(labels, shapes);
save('conversion', 'a_left', 'a_right', 'vis_pts_left', 'vis_pts_right');
% Try with scaling
