function [ out_dets ] = write_menpo_profile( detections, name, conversion, visibilities )
%WRITE_MEPO_PROFILE Summary of this function goes here
%   Detailed explanation goes here
    f = fopen(name, 'w');
    fprintf(f, 'version: 1\n');
    fprintf(f, 'n_points: 39\n');
    fprintf(f, '{\n');
    dets = conversion * cat(1,detections(visibilities,1), detections(visibilities,2));
    xs = dets(1:end/2,:);
    ys = dets(end/2+1:end,:);
   
    for i=1:size(xs,1)
        fprintf(f, '%.3f %.3f\n', xs(i), ys(i));
    end
    
    fprintf(f, '}\n');    
    fclose(f);
    out_dets = cat(2, xs, ys);
end

