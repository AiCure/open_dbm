function [train_users, dev_users] = get_balanced_fold(DISFA_dir, users, au, prop_test, offset)

    % This is for loading the labels
    for i=1:numel(users)   
        input_train_label_files{i} = [DISFA_dir, '/ActionUnit_Labels/', users{i}, '/', users{i}];
    end

    % Extracting the labels
    labels_train = extract_au_labels(input_train_label_files, au);

    counts = zeros(numel(users),1);
    for k=1:numel(users)
        counts(k) = sum(labels_train((k-1)*4844+1:k*4844));
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