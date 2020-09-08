function [geom_data, valid_ids] = Read_geom_files_dynamic(users, params_data_dir)

    geom_data = [];
    valid_ids = [];
    
    load('../../pca_generation/pdm_68_aligned_wild.mat');   
    
    user1 = {'train_001', 'train_002', 'train_003', 'train_004', 'train_005',...
            'train_006', 'train_007', 'train_008', 'train_009', 'train_010',...
            'train_011', 'train_012', 'train_013', 'train_014', 'train_015',...
            'train_016', 'train_017', 'train_018'};
    
    user2 = {'train_019', 'train_020', 'train_021', 'train_022', 'train_023',...
             'train_024', 'train_025', 'train_026', 'train_027', 'train_028',...
             'train_029', 'train_030', 'train_031', 'train_032'};
        
    user3 = {'train_033', 'train_034', 'train_035', 'train_036', 'train_037',...
             'train_038', 'train_039', 'train_040', 'train_041'};
         
    user4 = {'train_042', 'train_043', 'train_044', 'train_045', 'train_046',...
             'train_047', 'train_048', 'train_049', 'train_050', 'train_051',...
             'train_052', 'train_053', 'train_054', 'train_055', 'train_056'};
    
    user5 = {'train_057', 'train_058', 'train_059', 'train_060', 'train_061',...
             'train_062', 'train_063'};
         
    user6 = {'train_064', 'train_065', 'train_066', 'train_067', 'train_068',...
             'train_069', 'train_070', 'train_071', 'train_072', 'train_073',...
             'train_074', 'train_075', 'train_076', 'train_077', 'train_078', 'train_079'};
         
    user7 = {'train_080', 'train_081', 'train_082', 'train_083', 'train_084',...
             'train_085', 'train_086', 'train_087'};
         
    users_group = cat(1, {user1}, {user2}, {user3}, {user4}, {user5}, {user6}, {user7});
    user_inds = [];    
    
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
        
        for k=1:numel(users_group)
            if(~isempty(strmatch(users{i}, users_group{k})))
                user_inds = cat(1, user_inds, k * ones(size(valid,1),1));
            end
        end
        
        actual_locs = res * V';
        res = cat(2, actual_locs, res);

        valid_ids = cat(1, valid_ids, valid);
                

        geom_data = cat(1, geom_data, res);
                
    end
   
    if(numel(users) > 0)        
        
        % Perform normalization here
        u_id = unique(user_inds)';
        for u=u_id
            geom_data(user_inds==u, :) = bsxfun(@plus, geom_data(user_inds==u, :), -median(geom_data(user_inds==u & valid_ids, :)));
        end
    end                    
    
end