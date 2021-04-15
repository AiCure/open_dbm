function [to_keep] = FindDistantLandmarks(landmarkLoc, landmark_num, num_to_keep)

    % First align all of them
    a = landmarkLoc(:,:,1);
    b = landmarkLoc(:,:,2);

    offset_x = mean(a,2);
    offset_y = mean(b,2);

    landmark_loc_off = cat(3, bsxfun(@plus, a, -offset_x), bsxfun(@plus, b, -offset_y));
    fixed_x = landmark_loc_off(:,:,1);
    fixed_y = landmark_loc_off(:,:,2);

    % Extract the relevant landmarks
    fixed_x_l = fixed_x(:,landmark_num);
    fixed_y_l = fixed_y(:,landmark_num);
    
    obs = cat(2, fixed_x_l, fixed_y_l);
    
    % Discard landmarks that are very close to each other, so that we only
    % keep more diverse images
    D = squareform(pdist(obs));
    
    to_keep = true(size(landmarkLoc,1),1);
    
    for i = 1:(size(landmarkLoc,1) - num_to_keep)
       
        diversity_score = mean(D,2);
        
        a = min(diversity_score);
        
        lowest = find(diversity_score == a);
        lowest = lowest(1);
        
        to_keep(lowest) = 0;
        
        D(:,~to_keep) = 0;
        D(~to_keep,:) = 200;
    end
    
end