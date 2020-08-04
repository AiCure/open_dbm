function [ error_per_image, frontal_ids ] = compute_error_menpo_small( ground_truth_all, detected_points_all )
%compute_error
%   compute the average point-to-point Euclidean error normalized by the
%   inter-ocular distance (measured as the Euclidean distance between the
%   outer corners of the eyes)
%
%   Inputs:
%          grounth_truth_all, size: num_of_points x 2 x num_of_images
%          detected_points_all, size: num_of_points x 2 x num_of_images
%   Output:
%          error_per_image, size: num_of_images x 1

% This script uses the 49 point convention instead of the 68 point one
num_of_images = numel(ground_truth_all);
error_per_image = zeros(num_of_images,1);
frontal_ids = true(num_of_images,1);

for i =1:num_of_images
    detected_points      = detected_points_all{i} + 0.5;
    ground_truth_points  = ground_truth_all{i};
    num_of_points = size(ground_truth_points,1);

    normalization = (max(ground_truth_points(:,1))-min(ground_truth_points(:,1)))+...
       (max(ground_truth_points(:,2))-min(ground_truth_points(:,2)));
    normalization = normalization / 2;    
    landmark_labels = ground_truth_points;
    if(num_of_points==39)
        frontal_ids(i) = false;
        landmark_labels = zeros(68,2);
        % Need to map to the profile points, and normalize based on size
        % instead
        left_to_frontal_map = [17,28; 18,29; 19,30; 20,31;
                               21,34; 22,32; 23,39; 24,38; 25,37; 26,42; 27,41;
                               28,52; 29,51; 30,50; 31,49; 32,60; 33,59; 34,58;
                               35,63; 36,62; 37,61; 38,68; 39,67];

        right_to_frontal_map = [17,28; 18,29; 19,30; 20,31;
                               21,34; 22,36; 23,44; 24,45; 25,46; 26,47; 27,48;
                               28,52; 29,53; 30,54; 31,55; 32,56; 33,57; 34,58;
                               35,63; 36,64; 37,65; 38,66; 39,67];
                   
        % Determine if the points are clock-wise or counter clock-wise
        % Clock-wise points are facing left, counter-clock-wise right
        sum = 0;
        for k=1:11
            step = (ground_truth_points(k+1,1) - ground_truth_points(k,1)) * (ground_truth_points(k+1,2) + ground_truth_points(k,2));
            sum = sum + step;
        end

        if(sum > 0)
            % First need to resample the face outline as there are 9
            % points in the near-frontal and 10 points in profile for
            % the outline of the face

            outline = iterate_piece_wise(ground_truth_points(1:10,:), 9);
            brow = iterate_piece_wise(ground_truth_points(13:16,:), 5);
            landmark_labels(1:9,:) = outline;
            landmark_labels(18:22,:) = brow;
            landmark_labels(left_to_frontal_map(:,2),:) = ground_truth_points(left_to_frontal_map(:,1),:);
        else
            outline = iterate_piece_wise(ground_truth_points(10:-1:1,:), 9);
            brow = iterate_piece_wise(ground_truth_points(16:-1:13,:), 5);

            landmark_labels(9:17,:) = outline;
            landmark_labels(23:27,:) = brow;

            landmark_labels(right_to_frontal_map(:,2),:) = ground_truth_points(right_to_frontal_map(:,1),:);                
        end
                                  
    end


    % First get rid of inner mouth points and then the face outline
    landmark_labels = landmark_labels([1:60,62:64,66:end],:,:);
    landmark_labels = landmark_labels(18:end,:);

    % Do the same for 68 markup version
    if(size(detected_points,1) == 68)
        detected_points = detected_points([1:60,62:64,66:end],:,:);
        detected_points = detected_points(18:end,:);
    end

    % Remove the invisible points in profile
    ground_truth_points = landmark_labels(landmark_labels(:,1)~=0,:);

    detected_points = detected_points(landmark_labels(:,1)~=0,:);

    num_of_points = size(ground_truth_points,1);
        
    sum=0;
    for j=1:num_of_points
        sum = sum+norm(detected_points(j,:)-ground_truth_points(j,:));
    end
    error_per_image(i) = sum/(num_of_points*normalization);
end

end
