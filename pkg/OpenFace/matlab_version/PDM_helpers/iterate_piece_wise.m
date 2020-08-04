function [ pts_new ] = iterate_piece_wise( pts_orig, new_num_points )
%ITERATE_PIECE_WISE Summary of this function goes here
%   Detailed explanation goes here

    % Reinterpolate the new points, but make sure they are still on the
    % same lines
    num_orig = size(pts_orig,1);

    % Divide the number of original segments by number of new segments
    step_size = (num_orig - 1) / (new_num_points-1);
    
    pts_new = zeros(new_num_points,2);
    
    % Clamp the beginning and end, as they will be the same
    pts_new(1,:) = pts_orig(1,:);
    pts_new(end,:) = pts_orig(end,:);
    
    for i=1:new_num_points-2
       
        low_point = floor(1 + i * step_size);
        high_point = ceil(1 + i * step_size);
        
        coeff_1 = floor(1 + i * step_size) - i * step_size;
        coeff_2 = 1 - coeff_1;

        new_pt = coeff_1 * pts_orig(low_point,:) + coeff_2 * pts_orig(high_point,:);
        pts_new(i+1,:) = new_pt;
        
    end
    
end

