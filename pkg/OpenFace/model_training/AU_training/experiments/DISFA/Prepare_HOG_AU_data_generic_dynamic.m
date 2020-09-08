function [data_train, labels_train, data_test, labels_test, raw_test, PC, means_norm, stds_norm, vid_ids_test, success_test] = ...
    Prepare_HOG_AU_data_generic_dynamic(train_users, test_users, au_train, rest_aus, root, features_dir)

%% This should be a separate function?

input_train_label_files = cell(numel(train_users),1);
input_test_label_files = cell(numel(test_users),1);

% This is for loading the labels
for i=1:numel(train_users)   
    input_train_label_files{i} = [root, '/ActionUnit_Labels/', train_users{i}, '/', train_users{i}];
end

% This is for loading the labels
for i=1:numel(test_users)   
    input_test_label_files{i} = [root, '/ActionUnit_Labels/', test_users{i}, '/', test_users{i}];
end

% First extracting the labels
[train_geom_data] = Read_geom_files_dynamic(train_users, features_dir);
[test_geom_data] = Read_geom_files_dynamic(test_users, features_dir);

% Reading in the HOG data
[train_data, tracked_inds_hog, vid_ids_train] = Read_HOG_files_dynamic(train_users, features_dir);
[test_data, success_test, vid_ids_test] = Read_HOG_files_dynamic(test_users, features_dir);

train_data = cat(2, train_data, train_geom_data);
raw_test = cat(2, test_data, test_geom_data);

% Extracting the labels
labels_train = extract_au_labels(input_train_label_files, au_train);
labels_test = extract_au_labels(input_test_label_files, au_train);

labels_other = zeros(size(labels_train,1), numel(rest_aus));

% This is used to pick up activity of other AUs for a more 'interesting'
% data split and not only neutral expressions for negative samples    
if(numel(input_train_label_files) > 0)
    for i=1:numel(rest_aus)
        labels_other(:,i) = extract_au_labels(input_train_label_files, rest_aus(i));
    end

    % can now extract the needed training labels (do not rebalance validation
    % data)

    % make sure the same number of positive and negative samples is taken
    reduced_inds = false(size(labels_train,1),1);
    reduced_inds(labels_train > 0) = true;

    % make sure the same number of positive and negative samples is taken
    pos_count = sum(labels_train > 0);
    neg_count = sum(labels_train == 0);

    % pos_count = pos_count * 8;

    num_other = floor(pos_count / (size(labels_other, 2)));

    inds_all = 1:size(labels_train,1);

    for i=1:size(labels_other, 2)+1

        if(i > size(labels_other, 2))
            % fill the rest with a proportion of neutral
            inds_other = inds_all(sum(labels_other,2)==0 & ~labels_train);   
            num_other_i = min(numel(inds_other), pos_count - sum(labels_train(reduced_inds,:)==0));     
        else
            % take a proportion of each other AU
            inds_other = inds_all(labels_other(:, i) & ~labels_train);      
            num_other_i = min(numel(inds_other), num_other);        
        end
        inds_other_to_keep = inds_other(round(linspace(1, numel(inds_other), num_other_i)));
        reduced_inds(inds_other_to_keep) = true;

    end

    % Remove invalid ids based on CLM failing or AU not being labelled
    reduced_inds(~tracked_inds_hog) = false;

    labels_train = labels_train(reduced_inds);
    train_data = train_data(reduced_inds,:);
    
end
     
geom_size = max(size(train_geom_data,2), size(test_geom_data,2));

% Peforming zone specific masking
if(au_train < 8 || au_train == 43 || au_train == 45) % upper face AUs ignore bottom face
    % normalise the data
    pca_file = '../../pca_generation/generic_face_upper.mat';
    load(pca_file);
elseif(au_train > 9) % lower face AUs ignore upper face and the sides
    % normalise the data
    pca_file = '../../pca_generation/generic_face_lower.mat';
    load(pca_file);
elseif(au_train == 9) % Central face model
    % normalise the data
    pca_file = '../../pca_generation/generic_face_rigid.mat';
    load(pca_file);
end

PC_n = zeros(size(PC)+geom_size);
PC_n(1:size(PC,1), 1:size(PC,2)) = PC;
PC_n(size(PC,1)+1:end, size(PC,2)+1:end) = eye(geom_size);
PC = PC_n;

means_norm = cat(2, means_norm, zeros(1, geom_size));
stds_norm = cat(2, stds_norm, ones(1, geom_size));

data_test = bsxfun(@times, bsxfun(@plus, raw_test, -means_norm), 1./stds_norm);
data_test = data_test * PC;

if(numel(train_data > 0))
    data_train = bsxfun(@times, bsxfun(@plus, train_data, -means_norm), 1./stds_norm);
    data_train = data_train * PC;
else
   data_train = []; 
end

end