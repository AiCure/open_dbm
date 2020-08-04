function [geom_data] = Read_geom_files(users, hog_data_dir)

    geom_data = [];
    
    load('../../pca_generation/pdm_68_aligned_wild.mat');
    
    for i=1:numel(users)
        
        geom_file = [hog_data_dir, 'LeftVideo' users{i} '_comp.csv'];        
        
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
       
        geom_data = cat(1, geom_data, res);
                
    end
end