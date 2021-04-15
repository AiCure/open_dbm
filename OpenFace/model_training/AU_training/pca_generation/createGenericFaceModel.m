clear;
face_processed_dir = 'E:\datasets\face_datasets_processed';

%% CK+
hog_dir = [face_processed_dir, '/ck+/'];
hog_files = dir([hog_dir '*.hog']);
[appearance_data, valid_inds, vid_ids_train] = Read_HOG_files_small(hog_files, hog_dir);
appearance_data = appearance_data(valid_inds,:);
vid_ids_train = vid_ids_train(valid_inds,:);

%% Bosphorus
hog_dir = [face_processed_dir, '/bosph/'];
hog_files = dir([hog_dir '*.hog']);

% Remove non-frontal
frontal = true(size(hog_files));
for i = 1:numel(frontal)
    if(~isempty(strfind(hog_files(i).name, 'YR')) || ~isempty(strfind(hog_files(i).name, 'PR'))|| ~isempty(strfind(hog_files(i).name, 'CR')))
        frontal(i) = false;
    end   
end

hog_files = hog_files(frontal);

[appearance_data_tmp, valid_inds_tmp, vid_ids_train_tmp] = Read_HOG_files_small(hog_files, hog_dir);

appearance_data_tmp = appearance_data_tmp(valid_inds_tmp,:);
vid_ids_train_tmp = vid_ids_train_tmp(valid_inds_tmp,:);

appearance_data = cat(1,appearance_data, appearance_data_tmp);
vid_ids_train = cat(1,vid_ids_train, vid_ids_train_tmp);

%% FERA2011
hog_dir = [face_processed_dir, '/fera2011/'];
hog_files = dir([hog_dir '*.hog']);
[appearance_data_tmp, valid_inds_tmp, vid_ids_train_tmp] = Read_HOG_files_small(hog_files, hog_dir);

 appearance_data_tmp = appearance_data_tmp(valid_inds_tmp,:);
vid_ids_train_tmp = vid_ids_train_tmp(valid_inds_tmp,:);

appearance_data = cat(1,appearance_data, appearance_data_tmp);
vid_ids_train = cat(1,vid_ids_train, vid_ids_train_tmp);

%% UNBC
hog_dir = [face_processed_dir, '/unbc/'];
hog_files = dir([hog_dir '*.hog']);
[appearance_data_tmp, valid_inds_tmp, vid_ids_train_tmp] = Read_HOG_files_small(hog_files, hog_dir);

appearance_data_tmp = appearance_data_tmp(valid_inds_tmp,:);
vid_ids_train_tmp = vid_ids_train_tmp(valid_inds_tmp,:);

appearance_data = cat(1,appearance_data, appearance_data_tmp);
vid_ids_train = cat(1,vid_ids_train, vid_ids_train_tmp);



%% DISFA
hog_dir = [face_processed_dir, '/disfa/'];
hog_files = dir([hog_dir '*.hog']);

[appearance_data_tmp, valid_inds_tmp, vid_ids_train_tmp] = Read_HOG_files_small(hog_files, hog_dir);

appearance_data_tmp = appearance_data_tmp(valid_inds_tmp,:);
vid_ids_train_tmp = vid_ids_train_tmp(valid_inds_tmp,:);

appearance_data = cat(1,appearance_data, appearance_data_tmp);
vid_ids_train = cat(1,vid_ids_train, vid_ids_train_tmp);

%% BP4D train
hog_dir = [face_processed_dir, '/bp4d/train/'];
hog_files = dir([hog_dir '*.hog']);
[appearance_data_tmp, valid_inds_tmp, vid_ids_train_tmp] = Read_HOG_files_small(hog_files, hog_dir);

appearance_data_tmp = appearance_data_tmp(valid_inds_tmp,:);
vid_ids_train_tmp = vid_ids_train_tmp(valid_inds_tmp,:);

appearance_data = cat(1,appearance_data, appearance_data_tmp);
vid_ids_train = cat(1,vid_ids_train, vid_ids_train_tmp);

%% SEMAINE train
hog_dir = [face_processed_dir, '/semaine/train/'];
hog_files = dir([hog_dir '*.hog']);

[appearance_data_tmp, valid_inds_tmp, vid_ids_train_tmp] = Read_HOG_files_small(hog_files, hog_dir);

appearance_data_tmp = appearance_data_tmp(valid_inds_tmp,:);
vid_ids_train_tmp = vid_ids_train_tmp(valid_inds_tmp,:);

appearance_data = cat(1,appearance_data, appearance_data_tmp);
vid_ids_train = cat(1,vid_ids_train, vid_ids_train_tmp);

%%
means_norm = mean(appearance_data);
stds_norm = std(appearance_data);

normed_data = bsxfun(@times, bsxfun(@plus, appearance_data, -means_norm), 1./stds_norm);

[PC, score, eigen_vals] = princomp(normed_data, 'econ');

% Keep 95 percent of variability
total_sum = sum(eigen_vals);
count = numel(eigen_vals);
for i=1:numel(eigen_vals)
   if ((sum(eigen_vals(1:i)) / total_sum) >= 0.95)
      count = i;
      break;
   end
end

PC = PC(:,1:count);

save('generic_face_rigid.mat', 'PC', 'means_norm', 'stds_norm');    
