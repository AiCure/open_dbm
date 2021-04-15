function [images, detections, labels] = Collect_JANUS_imgs(root_test_data)

     dataset_loc = [root_test_data, '/'];

    landmarkLabels = dir([dataset_loc '\*.pts']);

    num_samples = 5;
    
    num_imgs = size(landmarkLabels,1);

    images = struct;
    labels = zeros(num_imgs * num_samples, 68, 2);    

    num_landmarks = 68;
    
    rng(0);
    detections = [];

    ind = 1;
    
    for imgs = 1:num_imgs

        [~,name,~] = fileparts(landmarkLabels(imgs).name);

        landmarks = dlmread([dataset_loc, landmarkLabels(imgs).name], ' ', [3,0,num_landmarks+2,1]);
        tmp = landmarks(:,1);
        landmarks(:,1) = landmarks(:,2);
        landmarks(:,2) = tmp;
                
        landmarks(landmarks == - 1) = 0;
        
        % Swap around some points
        eyes = landmarks(18:29,:);
        brow_l = landmarks(30:34,:);
        nose = landmarks(35:43,:);
        brow_r = landmarks(44:48,:);
        
        landmarks(18:22,:) = brow_l;
        landmarks(23:27,:) = brow_r;
        landmarks(28:36,:) = nose;
        landmarks(37:48,:) = eyes;
        
        non_occluded = landmarks(:,1) ~= 0;
        for s=1:num_samples
            % Create detections based on 300W noise level - just shifting in x, y
            % and adding some scaling        
            scale_x = 1 + randn(1,1) * 0.01;
            scale_y = 1 + randn(1,1) * 0.015;

            tx = 0.06 * randn(1,1);
            ty = 0.05 * randn(1,1);

            width_gt = (max(landmarks(non_occluded,1)) - min(landmarks(non_occluded,1)));
            height_gt = (max(landmarks(non_occluded,2)) - min(landmarks(non_occluded,2)));

            width = width_gt * scale_x;
            height = height_gt * scale_y;

            x = min(landmarks(non_occluded,1)) + width * tx;
            y = min(landmarks(non_occluded,2)) + height * ty;

            % Add like 5 more
            detections = cat(1, detections, [x, y, x+ width, y+height]);

            images(ind).img = [dataset_loc,  name];
            labels(ind,:,:) = landmarks;
            
%             imshow(imread(images(ind).img));
%             hold on;
%             rectangle('position', [x, y, width, height]);
%             hold off;            

            ind = ind + 1;
        end

    end
        
end