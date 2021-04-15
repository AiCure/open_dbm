function [geom_data, valid_ids] = Read_geom_files_dynamic(users, vid_ids, hog_data_dir)

    geom_data = [];
    valid_ids = [];
    
    load('../../pca_generation/pdm_68_aligned_wild.mat');   
    
    for i=1:numel(users)
        
        geom_file = [hog_data_dir, '/train/' users{i} '.csv'];
        m_file = [hog_data_dir, '/train/' users{i} '.params.mat'];
        if(~exist(geom_file, 'file'))            
            geom_file = [hog_data_dir, '/devel/' users{i} '.csv'];
            m_file = [hog_data_dir, '/devel/' users{i} '.params.mat'];
        end
        
        if(~exist(m_file, 'file'))
            if(~exist('shape_inds', 'var'))
                tab = readtable(geom_file);
                column_names = tab.Properties.VariableNames; 
                valid_ind = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'success'));
                shape_inds = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'p_'));
            end
        
            res = dlmread(geom_file, ',', 1, 0);

            valid = res(:, valid_ind) > 0.7;        
            res = res(:, shape_inds);

            % Do not consider global parameters
            res = res(:, 7:end);
            
            res = res(vid_ids(i,1)+1:vid_ids(i,2),:);
            save(m_file, 'res', 'valid');
        else
            load(m_file);
        end             
        
        actual_locs = res * V';
        res = cat(2, actual_locs, res);

        valid_ids = cat(1, valid_ids, valid);
                
        res = bsxfun(@plus, res, -median(res));

        geom_data = cat(1, geom_data, res);
                
    end
end