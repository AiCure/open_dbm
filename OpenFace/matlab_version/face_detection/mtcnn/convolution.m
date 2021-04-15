function [ output_maps ] = convolution( input_maps, kernels, biases )
%CONVOLUTION Summary of this function goes here
%   Detailed explanation goes here

    % If MatConvNet is not installed use Matlab (much slower)
    if(exist('vl_nnconv', 'file') == 3)
        output_maps = vl_nnconv(single(input_maps), kernels, biases);
    else
        n_filters = size(kernels, 4);

        kernels2 = kernels(:,:,end:-1:1,:);
        for i=1:n_filters
            for n_in_maps=1:size(kernels,3)
                kernels2(:,:,n_in_maps,i) = fliplr(squeeze(kernels2(:,:,n_in_maps,i)));
                kernels2(:,:,n_in_maps,i) = flipud(squeeze(kernels2(:,:,n_in_maps,i)));
            end
        end
        output_maps = [];
        for i=1:n_filters
            output_maps = cat(3, output_maps, convn(input_maps, kernels2(:,:,:,i), 'valid') + biases(i));
        end    
    end
end

