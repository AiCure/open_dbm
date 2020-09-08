function DrawFaceOnImg( img, shape, out_loc, orig_bbox, visibilities)
%DRAWFACEONIMG Summary of this function goes here
%   Detailed explanation goes here
    f = figure('visible','off','Position', [100, 100, 600, 600]);

    if(nargin > 3)
        [height_img, width_img,~] = size(img);
        width = orig_bbox(3) - orig_bbox(1);
        height = orig_bbox(4) - orig_bbox(2);

        img_min_x = max(int32(orig_bbox(1) - width/3),1);
        img_max_x = min(int32(orig_bbox(3) + width/3),width_img);

        img_min_y = max(int32(orig_bbox(2) - height/3),1);
        img_max_y = min(int32(orig_bbox(4) + height/3),height_img);

        shape(:,1) = shape(:,1) - double(img_min_x);
        shape(:,2) = shape(:,2) - double(img_min_y);
        img = img(img_min_y:img_max_y, img_min_x:img_max_x, :);    
    end

    % Downsize the image if it is very big
    if(size(img,1) > 500 || size(img,2) > 500)
        scale = min(500 / size(img,1), 500 / size(img,2));
        img = imresize(img, scale);
        shape = scale * shape;
    end    
    if(nargin > 4)
        % valid points to draw (not to draw
        % occluded ones)
        v_points = visibilities;
    else
        v_points = true(size(shape,1),1);
    end

    if(max(img(:)) > 1)
        imshow(double(img)/255, 'Border', 'tight');
    else
        imshow(double(img), 'Border', 'tight');
    end
    hold on;

    plot(shape(v_points,1), shape(v_points,2),'.r','MarkerSize',20);
    plot(shape(v_points,1), shape(v_points,2),'.b','MarkerSize',10);
    print(f, '-djpeg', out_loc);
    close(f);
end

