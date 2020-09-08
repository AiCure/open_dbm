load('menpo_train.mat');
dataset_loc = 'C:\Users\tbaltrus\Documents\menpo_data_orig/';
bboxes_st = bboxes;

% The offsets and detector bounding boxes
dets = zeros(numel(bboxes_st), 4);
bboxes = zeros(numel(bboxes_st), 4);
gt_labels = cell(numel(bboxes_st),1);
%%
for i=1:numel(bboxes_st)

    name = bboxes_st(i).name(1:end-4);    
    landmarks = importdata([dataset_loc, name, '.pts'], ' ', 3);
    landmarks = landmarks.data;
    
    bbox_gt = [min(landmarks(:,1)), min(landmarks(:,2)), max(landmarks(:,1)), max(landmarks(:,2))];
    bboxes(i,:) = bbox_gt;
    gt_labels{i} = landmarks;
    % zone in on a smaller version of the image
    if(~isempty(bboxes_st(i).bbox))
        dets(i,:) = [bboxes_st(i).bbox(1), bboxes_st(i).bbox(2), bboxes_st(i).bbox(3), bboxes_st(i).bbox(4)];
    end
end




save('menpo_mtcnn.mat', 'bboxes', 'dets', 'gt_labels');