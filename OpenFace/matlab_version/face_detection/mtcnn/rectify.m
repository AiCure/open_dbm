function [bbox_out] = rectify(bbox_in)
	
    %convert bboxA to square
    heights = bbox_in(:,4) - bbox_in(:,2);
	widths = bbox_in(:,3) - bbox_in(:,1);

    max_side = max([widths'; heights'])';
    
    % Correct the starts based on new size
    new_min_x = bbox_in(:,1) + 0.5 * (widths - max_side);
    new_min_y = bbox_in(:,2) + 0.5 * (heights - max_side);
    
    bbox_out = [new_min_x, new_min_y, new_min_x + max_side, new_min_y + max_side];
end

