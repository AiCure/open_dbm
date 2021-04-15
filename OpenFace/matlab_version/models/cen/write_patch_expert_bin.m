function write_patch_expert_bin(location, trainingScale, centers, visiIndex, patch_experts)
          
    patches_file = fopen(location, 'w');        
    
    [n_views, n_landmarks, ~] = size(patch_experts.correlations);

    % write out the scaling factor as this is what will be used when
    % fitting on the window
    fwrite(patches_file, trainingScale, 'float64');
    
    fwrite(patches_file, n_views, 'int');
    
    % Write out the information about the view's and centers here
    for i=1:n_views
        % this indicates that we're writing a 3x1 double matrix
        writeMatrixBin(patches_file, centers(i,:)', 6);
    end
            
    % Write out the visibilities
    for i=1:n_views
        % this indicates that we're writing a 3x1 double matrix
        writeMatrixBin(patches_file, visiIndex(i,:)', 4);
    end
            
    for i=1:n_views
        for j=1:n_landmarks

            % Write out that we're writing a CEN patch expert of 11x11 support region
            fwrite(patches_file, 6, 'int');
            fwrite(patches_file, 11, 'int');
            fwrite(patches_file, 11, 'int');
            
            if(~visiIndex(i,j))       
                % Write out that there won't be any neurons for this
                % landmark
                fwrite(patches_file, 0, 'int');
                fwrite(patches_file, 0, 'int');
            else
                num_layers = numel(patch_experts.patch_experts{i,j})/2;

                fwrite(patches_file, num_layers, 'int');

                for n=1:num_layers
                    
                    % output the actual layer
                    
                    % Layer type, bias, weights
                    
                    % Type of layer, first two are relu, the final one is a
                    % sigmoid (0 - sigmoid, 1 - tanh_opt, 2 - ReLU)
                    if(n < 3)
                        fwrite(patches_file, 2, 'int');
                    else
                        fwrite(patches_file, 0, 'int');
                    end
                                                            
                    bias = patch_experts.patch_experts{i,j}{n*2};
                    
                    weights = patch_experts.patch_experts{i,j}{n*2-1};

                    % the actual bias/weight matrix
                    writeMatrixBin(patches_file, bias, 5);
                    writeMatrixBin(patches_file, weights, 5);
                end
                
                % finally write out the confidence
                fwrite(patches_file, patch_experts.correlations(i,j), 'float64');
                
            end    
        end
    end

    fclose(patches_file);
