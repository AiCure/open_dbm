function [data_train, labels_train, data_devel, labels_devel, raw_devel, PC, means_norm, stds_norm, devel_ids, devel_success] = ...
    Prepare_HOG_AU_data(train_users, devel_users, au_train, rest_aus, Bosphorus_dir, params_data_dir)

%%
addpath(genpath('../data extraction/'));

% First extracting the labels
[ labels_train, valid_ids_train, filenames ] = extract_Bosphorus_labels(Bosphorus_dir, train_users, au_train);

[ labels_other, ~, ~ ] = extract_Bosphorus_labels(Bosphorus_dir, train_users, rest_aus);

% Reading in the HOG data (of only relevant frames)
[train_appearance_data, valid_ids_train_hog, vid_ids_train_string] = Read_HOG_files(filenames, params_data_dir);

[train_geom_data] = Read_geom_files(filenames,  params_data_dir);

% Subsample the data to rebalance it
if(numel(train_users) > 0)
    reduced_inds = false(size(labels_train,1),1);
    reduced_inds(labels_train > 0) = true;

    % make sure the same number of positive and negative samples is taken
    pos_count = sum(labels_train > 0);
    neg_count = sum(labels_train == 0);

    num_other = floor( pos_count / (size(labels_other, 2)));

    inds_all = 1:size(labels_train,1);

    for i=1:size(labels_other, 2)+1
   
        if(i > size(labels_other, 2))
            % fill the rest with a proportion of neutral
            inds_other = inds_all(sum(labels_other,2)==0 & ~labels_train );   
                num_other_i = min(numel(inds_other), pos_count - sum(labels_train(reduced_inds,:)==0));     
        else
                % take a proportion of each other AU
            inds_other = inds_all(labels_other(:, i) & ~labels_train );      
            num_other_i = min(numel(inds_other), num_other);        
        end
        inds_other_to_keep = inds_other(round(linspace(1, numel(inds_other), num_other_i)));
        reduced_inds(inds_other_to_keep) = true;

    end

    % Remove invalid ids based on CLM failing or AU not being labelled
    reduced_inds(~valid_ids_train) = false;
    reduced_inds(~valid_ids_train_hog) = false;

    labels_other = labels_other(reduced_inds, :);
    labels_train = labels_train(reduced_inds,:);
    train_appearance_data = train_appearance_data(reduced_inds,:);
    train_geom_data = train_geom_data(reduced_inds,:);
    vid_ids_train_string = vid_ids_train_string(reduced_inds,:);
end
%% Extract devel data

% First extracting the labels
[ labels_devel, valid_ids_devel, filenames_devel ] = extract_Bosphorus_labels(Bosphorus_dir, devel_users, au_train);

% Reading in the HOG data (of only relevant frames)
[devel_appearance_data, valid_ids_devel_hog, vid_ids_devel_string] = Read_HOG_files(filenames_devel, params_data_dir);
devel_success = valid_ids_devel_hog;
devel_ids = vid_ids_devel_string;

[devel_geom_data] = Read_geom_files(filenames_devel, params_data_dir);

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
     
% Grab all data for validation as want good params for all the data
raw_devel = cat(2, devel_appearance_data, devel_geom_data);

devel_appearance_data = bsxfun(@times, bsxfun(@plus, devel_appearance_data, -means_norm), 1./stds_norm);

data_devel = devel_appearance_data * PC;

data_devel = cat(2, data_devel, devel_geom_data);

valid_ids_devel = valid_ids_devel & devel_success;
data_devel = data_devel(valid_ids_devel,:);
labels_devel = labels_devel(valid_ids_devel,:);
raw_devel = raw_devel(valid_ids_devel,:);
devel_success = devel_success(valid_ids_devel,:);
devel_ids = devel_ids(valid_ids_devel);

if(numel(train_users) > 0)
    train_appearance_data = bsxfun(@times, bsxfun(@plus, train_appearance_data, -means_norm), 1./stds_norm);

    data_train = train_appearance_data * PC;
    data_train = cat(2, data_train, train_geom_data);
else
    data_train = [];
end

geom_size = max(size(train_geom_data, 2), size(devel_geom_data, 2));

PC_n = zeros(size(PC)+geom_size);
PC_n(1:size(PC,1), 1:size(PC,2)) = PC;
PC_n(size(PC,1)+1:end, size(PC,2)+1:end) = eye(geom_size);
PC = PC_n;

means_norm = cat(2, means_norm, zeros(1, geom_size));
stds_norm = cat(2, stds_norm, ones(1, geom_size));

end