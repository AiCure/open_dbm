function Write_CNN_to_binary(location_binary, cnn)

    addpath('../../../PDM_helpers/');
    
    % use little-endian
    cnn_binary_file = fopen(location_binary, 'w', 'l');        
              
    num_layers = size(cnn.layers,2);

    % Get the number of layers
    fwrite(cnn_binary_file, num_layers, 'uint'); % 4 bytes

    for layers=1:num_layers

        % write layer type: 0 - convolutional, 1 - max pooling, 2 -
        % fully connected, 3 - prelu, 4 - sigmoid
        if(strcmp(cnn.layers{layers}.type, 'conv'))

            % write the type (convolutional)
            fwrite(cnn_binary_file, 0, 'uint'); % 4 bytes

            num_in_map = size(cnn.layers{layers}.weights{1},3);

            % write the number of input maps
            fwrite(cnn_binary_file, num_in_map, 'uint'); % 4 bytes

            num_out_kerns = size(cnn.layers{layers}.weights{1},4);

            % write the number of kernels for each output map
            fwrite(cnn_binary_file, num_out_kerns, 'uint'); % 4 bytes

            % Write output map bias terms
            for k2=1:num_out_kerns    
                fwrite(cnn_binary_file, cnn.layers{layers}.weights{2}(k2), 'float32'); % 4 bytes
            end

            for k=1:num_in_map                                        
                for k2=1:num_out_kerns
                    % Write out the kernel                              
                    W = squeeze(cnn.layers{layers}.weights{1}(:,:,k,k2));
                    writeMatrixBin(cnn_binary_file, W, 5);                
                end
            end    
        elseif(strcmp(cnn.layers{layers}.type, 'fc'))

            % This is the fully connected layer
            fwrite(cnn_binary_file, 2, 'uint'); % 4 bytes

            % the bias term
            writeMatrixBin(cnn_binary_file, cnn.layers{layers}.weights{2}, 5);
            % the weights
            writeMatrixBin(cnn_binary_file, cnn.layers{layers}.weights{1}, 5);

        elseif(strcmp(cnn.layers{layers}.type, 'max_pooling'))
            fwrite(cnn_binary_file, 1, 'uint'); % 4 bytes, indicate max pooling layer
            % params kernel and stride size
            fwrite(cnn_binary_file, cnn.layers{layers}.kernel_size_x, 'uint'); % 4 bytes
            fwrite(cnn_binary_file, cnn.layers{layers}.kernel_size_y, 'uint'); % 4 bytes
            fwrite(cnn_binary_file, cnn.layers{layers}.stride_x, 'uint'); % 4 bytes
            fwrite(cnn_binary_file, cnn.layers{layers}.stride_y, 'uint'); % 4 bytes
           
        elseif(strcmp(cnn.layers{layers}.type, 'prelu'))
            fwrite(cnn_binary_file, 3, 'uint'); % 4 bytes, indicate a parametric relu layer
            writeMatrixBin(cnn_binary_file, cnn.layers{layers}.weights{1}, 5);
        end            
    end
    
    fclose(cnn_binary_file);
    
end