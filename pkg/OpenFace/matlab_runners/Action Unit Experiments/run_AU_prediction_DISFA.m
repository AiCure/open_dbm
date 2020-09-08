clear

if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

if(exist('D:/Datasets/DISFA/Videos_LeftCamera/', 'file'))   
    DISFA_dir = 'D:/Datasets/DISFA/Videos_LeftCamera/';  
elseif(exist('E:/Datasets/DISFA/Videos_LeftCamera/', 'file'))   
    DISFA_dir = 'E:/Datasets/DISFA/Videos_LeftCamera/';  
elseif(exist('/multicomp/datasets/face_datasets/DISFA/Videos_LeftCamera/', 'file'))
    DISFA_dir = '/multicomp/datasets/face_datasets/DISFA/Videos_LeftCamera/';
elseif(exist('/media/tadas/2EBEA130BEA0F20F/datasets/DISFA/', 'file'))
    DISFA_dir = '/media/tadas/2EBEA130BEA0F20F/datasets/DISFA/Videos_LeftCamera/';
else
    fprintf('Cannot find DIFA location\n');
end


videos = dir([DISFA_dir, '*.avi']);

output = './AU_predictions/out_DISFA/';
if(~exist(output, 'file'))
    mkdir(output);
end

%%
for v = 1:numel(videos)
   
    vid_file = [DISFA_dir, videos(v).name];
    
    command = sprintf('%s -f "%s" -out_dir "%s" -aus ', executable, vid_file, output);
        
    if(isunix)
        unix(command, '-echo');
    else
        dos(command);
    end
    
end

%% Now evaluate the predictions

% Note that DISFA was used in training, this is not meant for experimental
% results but rather to show how to do AU prediction and how to interpret
% the results
Label_dir = [DISFA_dir, '/../ActionUnit_Labels/'];
prediction_dir = output;

label_folders = dir([Label_dir, 'SN*']);

AUs_disfa = [1,2,4,5,6,9,12,15,17,20,25,26];
labels_all = [];
label_ids = [];
for i=1:numel(label_folders)

    labels = [];
    for au = AUs_disfa
        in_file = sprintf('%s/%s/%s_au%d.txt', Label_dir, label_folders(i).name, label_folders(i).name, au);
        A = dlmread(in_file, ',');
        labels = cat(2, labels, A(:,2));
    end
    
    labels_all = cat(1, labels_all, labels);
    user_id = str2num(label_folders(i).name(3:end));
    label_ids = cat(1, label_ids, repmat(user_id, size(labels,1),1));
end

preds_files = dir([prediction_dir, '*SN*.csv']);

tab = readtable([prediction_dir, preds_files(1).name]);
column_names = tab.Properties.VariableNames;
aus_pred_int = [];
au_inds_in_file = [];
for c=1:numel(column_names)
    if(strfind(column_names{c}, '_r') > 0)
        aus_pred_int = cat(1, aus_pred_int, int32(str2num(column_names{c}(3:end-2))));
        au_inds_in_file = cat(1, au_inds_in_file, c);
    end
end
    
inds_au = zeros(numel(AUs_disfa),1);

for ind=1:numel(AUs_disfa)  
    inds_au(ind) = au_inds_in_file(aus_pred_int==AUs_disfa(ind));
end
preds_all = zeros(size(labels_all,1), numel(AUs_disfa));

for i=1:numel(preds_files)
   
    preds = dlmread([prediction_dir, preds_files(i).name], ',', 1, 0);
    %preds = preds(:,5:5+numel(aus_pred_int)-1);

    user_id = str2num(preds_files(i).name(end - 11:end-9));
    rel_ids = label_ids == user_id;
    preds_all(rel_ids,:) = preds(:,inds_au);
end

%% now do the actual evaluation that the collection has been done
f = fopen('results/DISFA_valid_res.txt', 'w');
au_res = zeros(1, numel(AUs_disfa));
for au = 1:numel(AUs_disfa)
   [ accuracies, F1s, corrs, ccc, rms, classes ] = evaluate_au_prediction_results( preds_all(:,au), labels_all(:,au));
   fprintf(f, 'AU%d results - corr %.3f, rms %.3f, ccc - %.3f\n', AUs_disfa(au), corrs, rms, ccc);
   au_res(au) = ccc;
end
fclose(f);