
function [quantized] = quantizeContinuous(values, min_v, max_v, num_bins)

    step_size = (max_v - min_v) / num_bins;
    bin_centres = min_v + step_size/2 : step_size : max_v;
    
    bin_centres = repmat(bin_centres, numel(values),1);
    values = repmat(values, 1, num_bins);
    
    [~,quantized] = min(abs(values - bin_centres)');
    quantized = quantized';
end
