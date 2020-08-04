function [ out_dets ] = write_menpo_frontal( detections, name )
%WRITE_MEPO_PROFILE Summary of this function goes here
%   Detailed explanation goes here
    f = fopen(name, 'w');
    fprintf(f, 'version: 1\n');
    fprintf(f, 'n_points: 68\n');
    fprintf(f, '{\n');
    xs = detections(:,1);
    ys = detections(:,2);
   
    for i=1:size(xs,1)
        fprintf(f, '%.3f %.3f\n', xs(i), ys(i));
    end
    
    fprintf(f, '}\n');    
    fclose(f);
    out_dets = cat(2, xs, ys);
end

