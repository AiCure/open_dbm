load('menpo_mtcnn.mat')

% Find the ground truth bboxes
bboxes_gt = bboxes;

bboxes_det = dets;

non_detected = bboxes_det(:,3) == 0;

% Removing the outliers
widths_gt = bboxes_gt(:,3) - bboxes_gt(:,1);
widths_det = bboxes_det(:,3) - bboxes_det(:,1);

heights_gt = bboxes_gt(:,4) - bboxes_gt(:,2);
heights_det = bboxes_det(:,4) - bboxes_det(:,2);

tx_gt =  bboxes_gt(:,1);
ty_gt =  bboxes_gt(:,2);

tx_det = bboxes_det(:,1);
ty_det = bboxes_det(:,2);

bad_det_1 = abs(1 - widths_gt ./ widths_det) > 0.5;
bad_det_2 = abs(1 - heights_gt ./ heights_det) > 0.5;

bad_det_3 = abs((tx_gt - tx_det) ./ widths_det) > 0.4;
bad_det_4 = abs((ty_gt - ty_det) ./ heights_det) > 0.5;

non_detected = non_detected | bad_det_1 | bad_det_2 | bad_det_3 | bad_det_4;

% if the width is quite different from detection then it failed

bboxes_gt = bboxes_gt(~non_detected,:);
bboxes_det = bboxes_det(~non_detected,:);

%% some visualisations
% a = 1;
% plot(gt_labels(a,:,1), gt_labels(a,:,2), '.r');
% hold on;
% bbox = bboxes_detector(a,:);
% % bbox(2) = -bbox(2);
% rectangle('Position', bbox);
% hold off;
% axis equal;

% Want to find out what scaling and translation would lead to the smallest
% RMSE error between initialised landmarks and gt landmarks TODO

% Find the width and height mappings
widths_gt = bboxes_gt(:,3) - bboxes_gt(:,1);
widths_det = bboxes_det(:,3) - bboxes_det(:,1);

heights_gt = bboxes_gt(:,4) - bboxes_gt(:,2);
heights_det = bboxes_det(:,4) - bboxes_det(:,2);

s_width = widths_det \ widths_gt;
s_height = heights_det \ heights_gt;

tx_gt =  bboxes_gt(:,1);
ty_gt =  bboxes_gt(:,2);

tx_det = bboxes_det(:,1);
ty_det = bboxes_det(:,2);

s_tx = median((tx_gt - tx_det) ./ widths_det);
s_ty = median((ty_gt - ty_det) ./ heights_det);

%%
new_widths = widths_det * s_width;
new_heights = heights_det * s_height;
new_tx = widths_det * s_tx + tx_det;
new_ty = heights_det * s_ty + ty_det;

overlaps = zeros(numel(widths_det), 1);
new_overlaps = zeros(numel(widths_det), 1);

for i=1:numel(widths_det)
    bbox_gt = bboxes_gt(i,:);
    bbox_old = bboxes_det(i,:);
    overlaps(i) = overlap(bbox_gt, bbox_old);
    bbox_new = [new_tx(i), new_ty(i), new_tx(i) + new_widths(i), new_ty(i) + new_heights(i)];
    new_overlaps(i) = overlap(bbox_gt, bbox_new);
end

fprintf('Orig - %.3f, now - %.3f\n', mean(overlaps), mean(new_overlaps));
