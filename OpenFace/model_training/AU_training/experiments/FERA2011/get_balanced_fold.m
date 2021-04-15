function [train_users, dev_users] = get_balanced_fold(FERA_dir, users, au, prop_test, offset)


    [ labels_train, valid_ids_train, filenames ] = extract_FERA2011_labels(FERA_dir, users, au);
    
    % Make sure the folds are user independent
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
    
    counts = zeros(numel(users_group),1);
    for k=1:numel(users_group)
        for f=1:numel(filenames)            
            if(~isempty(strmatch(filenames{f}(1:9), users_group{k})))
                counts(k) = counts(k) + sum(labels_train{f});
            end
        end
    end

    % Now group them together by users
    
    [sorted, inds] = sort(counts);
    dev_inds = inds(offset:round(1/prop_test):end);
    train_inds = setdiff(inds, dev_inds);
    
    dev_users = users_group(dev_inds);
    dev_users = cat(2, dev_users{:})';
    
    train_users = users_group(train_inds);
    train_users = cat(2, train_users{:})';
    
end