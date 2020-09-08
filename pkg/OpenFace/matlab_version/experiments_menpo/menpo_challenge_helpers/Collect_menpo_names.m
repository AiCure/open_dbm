function [images, labels] = Collect_menpo_names(root_dir)

    load('menpo_train_dets.mat');

    bb = bboxes;
    load('menpo_valid_dets.mat');
    bboxes = cat(2, bb, bboxes);

    % Have three bounding box locations (frontal tuned, profile tuned)
    labels = cell(numel(bboxes),1);
    
    for i=1:numel(bboxes)
        images(i).img = [bboxes(i).name];
               
        labels{i} = bboxes(i).gt_landmarks;
    end
    
end
