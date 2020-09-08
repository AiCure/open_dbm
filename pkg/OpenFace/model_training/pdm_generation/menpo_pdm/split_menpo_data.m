% Script for internal menpo data split, convert the original training data
% to 2/3rds training and 1/3rd validation

menpo_root = 'D:\Datasets\menpo/';

pts_files = dir([menpo_root, '/*.jpg']);
jpg_files = dir([menpo_root, '/*.pts']);

% Do the actual copying to respective folders
out_train = [menpo_root, '/train/'];
out_valid = [menpo_root, '/valid/'];
mkdir(out_train);
mkdir(out_valid);

load('train_valid_split');

for i=1:numel(train_imgs)
   
    copyfile([menpo_root, train_pts(i).name], [out_train, train_pts(i).name]);
    copyfile([menpo_root, train_imgs(i).name], [out_train, train_imgs(i).name]);
    
end

for i=1:numel(valid_imgs)
   
    copyfile([menpo_root, valid_pts(i).name], [out_valid, valid_pts(i).name]);
    copyfile([menpo_root, valid_imgs(i).name], [out_valid, valid_imgs(i).name]);
    
end