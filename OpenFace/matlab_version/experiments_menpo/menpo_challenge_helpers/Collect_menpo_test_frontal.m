function [images, detections] = Collect_menpo_test_frontal(root_dir)

    load('face_detections/menpo_test_frontal.mat');

    % Have three bounding box locations (frontal tuned, profile tuned)
    detections = zeros(numel(bboxes), 4);
    
    for i=1:numel(bboxes)
        images(i).img = [root_dir,  bboxes(i).name];
        
        % If face detected
        if(~isempty(bboxes(i).bbox))
            bbox = bboxes(i).bbox(1:4);
            % Correct the MTCNN bounding box
            width = bbox(3) - bbox(1);
            height = bbox(4) - bbox(2);
            tx = bbox(1);
            ty = bbox(2);

            % Frontal faces
            new_width = width * 1.0323;
            new_height = height * 0.7751;
            new_tx = width * -0.0075 + tx;
            new_ty = height * 0.2459 + ty;

            detections(i,:) = [new_tx, new_ty, new_tx + new_width, new_ty + new_height];
            
        else % If face not detected, use the mean location of the face in training data
            img_size = size(imread([root_dir,  bboxes(i).name]));
            img_width = img_size(2);
            img_height = img_size(1);
            
            width = img_width * 0.4421;
            height = img_height * 0.445;
            
            tx = img_width * 0.5048 - 0.5 * width;
            ty = img_height * 0.5166 - 0.5 * height;
            
            detections(i,:) = [tx, ty, tx + width, ty + height];
        end
    end
    
end
