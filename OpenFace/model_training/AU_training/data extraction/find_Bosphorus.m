if(exist('D:/Datasets/Bosphorus/', 'file'))
    Bosphorus_dir = 'D:\Datasets\Bosphorus/';   
elseif(exist('E:/datasets/Bosphorus/', 'file'))
    Bosphorus_dir = 'E:\datasets\Bosphorus/';   
else
    fprintf('Bosphorus dataset location not found (or not defined)\n'); 
end

hog_data_dir = ['E:\Datasets\face_datasets_processed\bosph'];

all_recs = dir([Bosphorus_dir, '/BosphorusDB/BosphorusDB/bs*']);
all_recs_mat = cat(1, all_recs.name);
all_recs = cell(numel(all_recs), 1);

for i=1:size(all_recs_mat,1)
   
    all_recs{i} = all_recs_mat(i,:);
    
end

devel_recs = all_recs(1:3:end);
train_recs = setdiff(all_recs, devel_recs);

