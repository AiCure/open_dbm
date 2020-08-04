function Write_patch_experts_multi_modal(locationTxt, locationMlab, trainingScale, centers, visiIndex, patch_experts, normalisationOptions)
    
    patches_file = fopen(locationTxt, 'w');        
    
    [views, landmarks, ~] = size(patch_experts.patch_experts{1});
    
    fprintf(patches_file, '# scaling factor of training\r\n%f\r\n', trainingScale);
    
    % write out the scaling factor as this is what will be used when
    % fitting on the window
    fprintf(patches_file, '# number of views\r\n%d\r\n', views);

    % Write out the information about the view's and centers here
    fprintf(patches_file, '# centers of the views\r\n');

    for i=1:views
        % this indicates that we're writing a 3x1 double matrix
        writeMatrix(patches_file, centers(i,:)', 6);
    end
            
    fprintf(patches_file, '# visibility indices per view\r\n');
    
    for i=1:views
        % this indicates that we're writing a 3x1 double matrix
        writeMatrix(patches_file, visiIndex(i,:)', 4);
    end
    
    fprintf(patches_file, '# Patches themselves (1 line patches of a vertex)\r\n');
    
    for i=1:views
        for j=1:landmarks

            num_patches = size(patch_experts.patch_experts, 1);

            % MPatch(3), width, height, nPatches(1 or 0), Patch(2), type(0),
            % scaling(1) bias, rows, cols, type
            fprintf(patches_file, '%d %d %d %d ', 3, 11, 11, num_patches);
            
            for k=1:num_patches
                
                
                if(strcmp(patch_experts.types{k}, 'reg'))
                   type = 0; 
                elseif(strcmp(patch_experts.types{k}, 'grad'))
                   type = 1; 
                else
                   fprintf('Not supported patch type\n');
                   type = 0;
                end
                % also add patch confidence based on correlation scores
                fprintf(patches_file, '%d %d %f %f %f %d %d %d ', 2, type, patch_experts.correlations{k}(i,j), patch_experts.patch_experts{k}(i,j,1), patch_experts.patch_experts{k}(i,j,2), 11, 11, 5);
                fprintf(patches_file, '%f ', patch_experts.patch_experts{k}(i,j,3:end));
                fprintf(patches_file,'\r\n');
            end
            % the actual matrix and gain
        end    
    end

    fclose(patches_file);

    save(locationMlab, 'patch_experts', 'trainingScale', 'centers', 'visiIndex', 'normalisationOptions');
end