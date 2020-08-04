function [ display_array ] = generateDisplayData( X )
%GENERATEDISPLAYDATA Summary of this function goes here
%   Detailed explanation goes here
    example_width = 11;
    example_height = 11;
    
    % Compute rows, cols
    [m n] = size(X);

    % Compute number of items to display
    display_rows = floor(sqrt(m));
    display_cols = ceil(m / display_rows);

    % Between images padding
    pad = 1;

    % Setup blank display
    display_array = double(zeros(pad + display_rows * (example_height + pad), ...
                           pad + display_cols * (example_width + pad)));
    % Copy each example into a patch on the display array
    curr_ex = 1;
    for j = 1:display_rows
        for i = 1:display_cols
            if curr_ex > m, 
                break; 
            end
            % Copy the patch

%             if(isa(X, 'uint8'))
                display_array(pad + (j - 1) * (example_height + pad) + (1:example_height), ...
                              pad + (i - 1) * (example_width + pad) + (1:example_width)) = ...
                                reshape(X(curr_ex, :), example_height, example_width);
%             else
%                 % Get the max value of the patch                
%                 minVal = min(X(curr_ex, X(curr_ex,:)~=0)) - 10;     
%                 if(numel(minVal) < 1)
%                     minVal = 0;
%                 end
%                 maxVal = double(max(X(curr_ex,:)-minVal))/255.0;
%                 if(numel(minVal) < 1 || maxVal == 0)
%                     maxVal = 1;
%                 end
%                 display_array(pad + (j - 1) * (example_height + pad) + (1:example_height), ...
%                               pad + (i - 1) * (example_width + pad) + (1:example_width)) = ...
%                                 reshape((X(curr_ex, :)-minVal)/maxVal, example_height, example_width);                
%             end
            curr_ex = curr_ex + 1;
        end
        if curr_ex > m, 
            break; 
        end
    end    
    

end

