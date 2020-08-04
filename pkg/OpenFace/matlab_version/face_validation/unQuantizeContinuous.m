
function [unquantized] = unQuantizeContinuous(values, min_v, max_v, num_bins)
    step_size = (max_v - min_v) / num_bins;    
    unquantized = min_v + step_size/2 + (values-1) * step_size;

end