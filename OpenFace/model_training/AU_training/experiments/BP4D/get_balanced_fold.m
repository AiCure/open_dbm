function [train_users, dev_users] = get_balanced_fold(BP4D_dir, users, au, prop_test)

    % Extracting the labels
    [labels, valid_ids, vid_ids, filenames] = extract_BP4D_labels(BP4D_dir, users, au);
    
    % the grouping should be done per person
    
    for f=1:numel(filenames)
        filenames{f} = filenames{f}(1:4);
    end
    
    counts = zeros(numel(users),1);
    for k=1:numel(users)
        counts(k) = sum(cat(1, labels{strcmp(filenames, users{k})}));
    end

    [sorted, inds] = sort(counts);

    dev_users = users(inds(1:round(1/prop_test):end));
    train_users = setdiff(users, dev_users);
end