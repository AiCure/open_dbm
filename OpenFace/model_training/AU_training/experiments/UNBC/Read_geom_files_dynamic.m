function [geom_data, valid_ids] = Read_geom_files_dynamic(users, model_param_data_dir)

    geom_data = [];
    valid_ids = [];
    
    load('../../pca_generation/pdm_68_aligned_wild.mat');
    
    for i=1:numel(users)
        
        geom_files = dir([model_param_data_dir, '/' users{i} '*.csv']);
        
        geom_data_curr_p = [];
        
        for g=1:numel(geom_files)
            m_file = [model_param_data_dir, '/', geom_files(g).name, '.mat'];

            if(~exist(m_file, 'file'))
                
                if(~exist('shape_inds', 'var'))
                    tab = readtable([model_param_data_dir, '/', geom_files(g).name]);
                    column_names = tab.Properties.VariableNames; 
                    valid_ind = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'success'));
                    shape_inds = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'p_'));
                end
        
                res = dlmread([model_param_data_dir, '/', geom_files(g).name], ',', 1, 0);

                valid = res(:, valid_ind) > 0.7;        
                res = res(:, shape_inds);

                % Do not consider global parameters
                res = res(:, 7:end);

                save(m_file, 'res', 'valid');
            else
                load(m_file);
            end

            actual_locs = res * V';
            res = cat(2, actual_locs, res);

            valid_ids = cat(1, valid_ids, valid);

            geom_data_curr_p = cat(1, geom_data_curr_p, res);
        end
        geom_data_curr_p = bsxfun(@plus, geom_data_curr_p, -median(geom_data_curr_p));
        
        geom_data = cat(1, geom_data, geom_data_curr_p);
        
    end
end