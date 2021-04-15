function [x, y] = cummErrorCurve( errorVec )
%CUMMERRORCURVE Summary of this function goes here
%   Detailed explanation goes here

    
    spacing = 0.0005;       
    
    sampling = [0:spacing:max(errorVec)];

    x = sampling;
    
    y = zeros(numel(sampling,1));
    
    for i=1:numel(sampling)
    
        y(i) = sum(errorVec < sampling(i)) / numel(errorVec);
    end
    
    for i=1:200
        x = cat(2, x, x(end)+spacing);
        y = cat(2, y, 1);
    end
end

