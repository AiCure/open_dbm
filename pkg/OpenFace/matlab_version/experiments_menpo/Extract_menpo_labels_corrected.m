root_dir = 'D:\Datasets\menpo/';
load('menpo_train_dets.mat');

bb = bboxes;
load('menpo_valid_dets.mat');
bboxes = cat(2, bb, bboxes);

labels = cell(numel(bboxes),1);
    
for i=1:numel(bboxes)
    pts_name = [root_dir,  bboxes(i).name(1:end-3), 'pts'];
    lmarks = importdata(pts_name, ' ', 3);
    labels{i} = lmarks.data;
    
    img = imread([root_dir,  bboxes(i).name]);
    imshow(img); hold on;plot(labels{i}(:,1), labels{i}(:,2), '.r');hold off;
    drawnow expose;
end
save('results/menpo_labels', 'labels');