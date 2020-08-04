function [train_users, dev_users] = get_balanced_fold(Bosphorus_dir, users, au, prop_test, offset)


    [ labels_train, valid_ids_train, filenames ] = extract_Bosphorus_labels(Bosphorus_dir, users, au);
        
    labels_train = labels_train(valid_ids_train,:);
    filenames = filenames(valid_ids_train);
    
    % Shorten the filenames to reflect user id
    for i=1:numel(filenames)
        filenames{i} = filenames{i}(1:5);
    end
    
    counts = zeros(numel(users),1);
    for k=1:numel(users)
        counts(k) = sum(labels_train(strcmp(filenames, users{k}))>0);
    end

    [sorted, inds] = sort(counts);
    
    dev_users = users(inds(offset:round(1/prop_test):end));
    train_users = setdiff(users, dev_users);
    
    count_dev = 0;
    count_train = 0;
    for k=1:numel(users)
        if(any(strcmp(dev_users, users{k})))
            count_dev = count_dev + counts(k);
        else
            count_train = count_train + counts(k);
        end
        
    end

end