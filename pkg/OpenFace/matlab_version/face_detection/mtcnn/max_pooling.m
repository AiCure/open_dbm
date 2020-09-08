function [ output_maps ] = max_pooling( input_maps)
%POOLING Summary of this function goes here
%   Detailed explanation goes here
    
    orig_rows = size(input_maps,1);
    orig_cols = size(input_maps,2);
    
    pooled_rows = ceil(orig_rows / 2);
    pooled_cols = ceil(orig_cols / 2);

    up_to_rows_out = floor(orig_rows / 2);
    up_to_cols_out = floor(orig_cols / 2);

    if(mod(orig_cols,2) == 0)
        up_to_cols = orig_cols;
    else
        up_to_cols = orig_cols - 1;
    end
    
    if(mod(orig_rows,2) == 0)
        up_to_rows = orig_rows;
    else
        up_to_rows = orig_rows - 1;
    end
    
    output_maps = zeros(pooled_rows, pooled_cols, size(input_maps,3));
    for i=1:size(input_maps,3)
        temp = im2col(input_maps(1:up_to_rows,1:up_to_cols,i), [2,2], 'distinct');
        max_val = max(temp);
        output_maps(1:up_to_rows_out,1:up_to_cols_out,i) = reshape(max_val, up_to_rows_out, up_to_cols_out);     
    end
    
    % A bit of a hack for non-even number of rows or columns
    if(mod(orig_cols,2) ~= 0)
        for i=1:size(input_maps,3)
            temp = im2col(input_maps(1:up_to_rows,end,i), [2,1], 'distinct');
            max_val = max(temp);
            output_maps(1:up_to_rows_out,end,i) = max_val;     
        end        
    end

    if(mod(orig_rows,2) ~= 0)
        for i=1:size(input_maps,3)
            temp = im2col(input_maps(end, 1:up_to_cols,i), [1,2], 'distinct');
            max_val = max(temp);
            output_maps(end, 1:up_to_cols_out,i) = max_val;     
        end        
    end
    
    if(mod(orig_cols,2) ~= 0 && mod(orig_rows,2) ~= 0)
        output_maps(end,end,:) = input_maps(end,end,:);
    end
    

    
end

