function WriteOutFaceCheckersCNNbinary(locationTxt, faceCheckers)

    addpath('../PDM_helpers\');
    
    % use little-endian
    faceCheckerFile = fopen(locationTxt, 'w', 'l');        
    
    views = numel(faceCheckers);
    
    % Type 0 - linear SVR, 1 - feed forward neural net, 2 - CNN, 3 - new
    % CNN
    fwrite(faceCheckerFile, 3, 'uint'); % 4 bytes
            
    % Number of face checkers
    fwrite(faceCheckerFile, views, 'uint'); % 4 bytes
    
    % Matrices representing view orientations
    for i=1:views
        % this indicates that we're writing a 3x1 double matrix
        writeMatrixBin(faceCheckerFile, faceCheckers(i).centres', 6);
    end
    
    for i = 1:views
        
        % The normalisation models
        % Mean of images
        writeMatrixBin(faceCheckerFile, faceCheckers(i).mean_ex, 6);
                
        % Standard deviation of images
        writeMatrixBin(faceCheckerFile, faceCheckers(i).std_ex, 6);
                
        cnn = faceCheckers(i).cnn;
        
        num_depth_layers = size(cnn.layers,2);

        % Get the number of layers
        fwrite(faceCheckerFile, num_depth_layers, 'uint'); % 4 bytes
        
        % For disambiguation between FC and conv layers
        res = vl_simplenn(cnn, single(faceCheckers(i).mask), [], []);
        
        for layers=1:num_depth_layers
           
            % write layer type: 0 - convolutional, 1 - max pooling (2x2 stride 2), 2 -
            % fully connected, 3 - relu, 4 - sigmoid
            if(cnn.layers{layers}.type == 'conv')
                
                % First check if it is an FC layer (they are represented
                % like that in matconvnet)
                if(numel(res(layers).x) == numel(cnn.layers{layers}.weights{1}(:,:,:,1)))
                    % This is the fully connected layer
                    fwrite(faceCheckerFile, 2, 'uint'); % 4 bytes

                    % the bias term
                    writeMatrixBin(faceCheckerFile, cnn.layers{layers}.weights{2}(:), 5);
                    % the weights
                    
                    % Convert the filters to a matrix
                    weights_c = cnn.layers{layers}.weights{1};
                    size_w = size(weights_c);
                    weights = zeros(size_w(1)*size_w(2)*size_w(3), size_w(4));
                    weights(:) = weights_c;
                    writeMatrixBin(faceCheckerFile, weights, 5);
                else
                
                    % write the type (convolutional)
                    fwrite(faceCheckerFile, 0, 'uint'); % 4 bytes

                    num_in_map = size(cnn.layers{layers}.weights{1},3);

                    % write the number of input maps
                    fwrite(faceCheckerFile, num_in_map, 'uint'); % 4 bytes

                    num_out_kerns = size(cnn.layers{layers}.weights{1},4);

                    % write the number of kernels for each output map
                    fwrite(faceCheckerFile, num_out_kerns, 'uint'); % 4 bytes

                    % Write output map bias terms
                    for k2=1:num_out_kerns    
                        fwrite(faceCheckerFile, cnn.layers{layers}.weights{2}(k2), 'float32'); % 4 bytes
                    end

                    for k=1:num_in_map                                        
                        for k2=1:num_out_kerns
                            % Write out the kernel                              
                            W = squeeze(cnn.layers{layers}.weights{1}(:,:,k,k2));
                            writeMatrixBin(faceCheckerFile, W, 5);                
                        end
                    end    
                end
            elseif(cnn.layers{layers}.type == 'pool')
                fwrite(faceCheckerFile, 1, 'uint'); % 4 bytes, indicate max pooling layer, no params, assume (2x2 stride 2)
            elseif(cnn.layers{layers}.type == 'relu')
                fwrite(faceCheckerFile, 3, 'uint'); % 4 bytes, indicate relu layer, no params
            end            
        end
        

        % Piecewise affine warp
        
        nPix = faceCheckers(i).nPix;
        minX = faceCheckers(i).minX;
        minY = faceCheckers(i).minY;
               
        destination = reshape(faceCheckers(i).destination, numel(faceCheckers(i).destination), 1);         
        triangulation = faceCheckers(i).triangulation;
        triX = faceCheckers(i).triX;
        mask = faceCheckers(i).mask;
        alphas = faceCheckers(i).alphas;
        betas = faceCheckers(i).betas;
        
        fwrite(faceCheckerFile, nPix, 'uint'); % 4 bytes
        fwrite(faceCheckerFile, minX, 'float64'); % 8 bytes
        fwrite(faceCheckerFile, minY, 'float64'); % 8 bytes
        
        % Destination shape
        writeMatrixBin(faceCheckerFile, destination, 6);
        
        % Triangulation
        writeMatrixBin(faceCheckerFile, triangulation, 4);
        
        % Triangle map
        writeMatrixBin(faceCheckerFile, triX, 4);        

        % Mask
        writeMatrixBin(faceCheckerFile, mask, 4);        
        
        % Alphas
        writeMatrixBin(faceCheckerFile, alphas, 6);        

        % Betas
        writeMatrixBin(faceCheckerFile, betas, 6);        

    end
    
    fclose(faceCheckerFile);
    
end