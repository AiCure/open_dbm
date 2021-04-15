function [train_users, dev_users] = get_balanced_fold(UNBC_dir, users, au, prop_test, offset)


    [ labels_train, valid_ids_train, filenames ] = extract_UNBC_labels(UNBC_dir, users, au);
    
    % trimming the filenames a bit
    for f=1:numel(filenames)
        filenames{f} = filenames{f}(1:5);
    end
    
    counts = zeros(numel(users),1);
    for k=1:numel(users)
        counts(k) = sum(cat(1, labels_train{strcmp(filenames, users{k}(5:end))}));
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
    fprintf('Mean train %.2f, mean test %.2f\n', count_train / numel(train_users), count_dev / numel(dev_users));
    
end