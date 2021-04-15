function [geom_data, valid_ids] = Read_geom_files(users, params_data_dir)

    geom_data = [];
    valid_ids = [];
    
    load('../../pca_generation/pdm_68_aligned_wild.mat');
    
    for i=1:numel(users)
        
        geom_file = [params_data_dir, '/au_training_' users{i} '.csv'];        
        
        if(i == 1)
            tab = readtable(geom_file);
            column_names = tab.Properties.VariableNames; 
            valid_ind = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'success'));
            shape_inds = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'p_'));
        end
                
        res = dlmread(geom_file, ',', 1, 0);    

        % Check the confidence of detection
        valid = logical(res(:, valid_ind));              
        res = res(:, shape_inds);
                
        % Do not consider global parameters
        res = res(:, 7:end);
                          
        actual_locs = res * V';
        res = cat(2, actual_locs, res);

        valid_ids = cat(1, valid_ids, valid);
            
        geom_data = cat(1, geom_data, res);
                
    end
end