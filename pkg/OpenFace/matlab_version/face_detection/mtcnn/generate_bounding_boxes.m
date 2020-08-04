function [bboxes] = generate_bounding_boxes(heatmap, correction, scale, t, face_support)
	%use heatmap to generate bounding boxes in the original image space
    
    % Correction for the pooling
    stride = 2;

    % Offsets for, x, y, width and height
    dx1=correction(:,:,1);
	dy1=correction(:,:,2);
	dx2=correction(:,:,3);
	dy2=correction(:,:,4);
    
    % Find the parts of a heatmap above the threshold (x, y, and indices)
    [x, y]= find(heatmap >= t);
    inds = find(heatmap >= t);
    
    % Find the corresponding scores and bbox corrections
    score=heatmap(inds);    
	correction=[dx1(inds) dy1(inds) dx2(inds) dy2(inds)];

    % Correcting for Matlab's format
    bboxes=[y - 1 x - 1];
    bboxes=[fix((stride*(bboxes)+1)/scale) fix((stride*(bboxes)+face_support)/scale) score correction];
end

