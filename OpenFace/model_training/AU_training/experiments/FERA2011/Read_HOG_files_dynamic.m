function [hog_data, valid_data, vid_id] = Read_HOG_files_dynamic(users, hog_data_dir)

    hog_data = [];
    vid_id = {};
    valid_data = [];
    
    feats_filled = 0;
    
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
        
        hog_file = [hog_data_dir, '/au_training_' users{i} '.hog'];
        
        f = fopen(hog_file, 'r');
                          
        curr_data = [];
        curr_ind = 0;
        
        while(~feof(f))
                        
            if(curr_ind == 0)
                num_cols = fread(f, 1, 'int32');
                if(isempty(num_cols))
                    break;
                end

                num_rows = fread(f, 1, 'int32');
                num_chan = fread(f, 1, 'int32');

                curr_ind = curr_ind + 1;            

                % preallocate some space
                if(curr_ind == 1)
                    curr_data = zeros(5000, 1 + num_rows * num_cols * num_chan);
                    num_feats =  1 + num_rows * num_cols * num_chan;
                end

                if(curr_ind > size(curr_data,1))
                    curr_data = cat(1, curr_data, zeros(6000, 1 + num_rows * num_cols * num_chan));
                end
                feature_vec = fread(f, [1, 1 + num_rows * num_cols * num_chan], 'float32');
                curr_data(curr_ind, :) = feature_vec;
            else
            
                % Reading in batches of 5000
                
                feature_vec = fread(f, [4 + num_rows * num_cols * num_chan, 5000], 'float32');
                feature_vec = feature_vec(4:end,:)';
                
                num_rows_read = size(feature_vec,1);
                
                curr_data(curr_ind+1:curr_ind+num_rows_read,:) = feature_vec;
                
                curr_ind = curr_ind + size(feature_vec,1);
                
            end
                        
        end
        
        fclose(f);
        
        curr_data = curr_data(1:curr_ind,:);
        
        for k=1:numel(users_group)
            if(~isempty(strmatch(users{i}, users_group{k})))
                user_inds = cat(1, user_inds, k * ones(curr_ind,1));
            end
        end
        
        valid = logical(curr_data(:, 1));
        
        vid_id_curr = cell(curr_ind,1);
        vid_id_curr(:) = users(i);
        
        vid_id = cat(1, vid_id, vid_id_curr);
        
        % Assume same number of frames per video
        if(i==1)
            hog_data = zeros(curr_ind*numel(users), num_feats);
        end
        
        if(size(hog_data,1) < feats_filled+curr_ind)
           hog_data = cat(1, hog_data, zeros(size(hog_data,1), num_feats));
        end
        
        hog_data(feats_filled+1:feats_filled+curr_ind,:) = curr_data;
        
        feats_filled = feats_filled + curr_ind;
        
    end
        
    if(numel(users) > 0)        
        
        % Perform normalization here
        u_id = unique(user_inds)';
        
        valid_data = hog_data(1:feats_filled,1) > 0;
        
        for u=u_id
            hog_data(user_inds==u, 2:end) = bsxfun(@plus, hog_data(user_inds==u, 2:end), -median(hog_data(user_inds==u & valid_data, 2:end)));
        end
        
        hog_data = hog_data(1:feats_filled,2:end);
    end
end