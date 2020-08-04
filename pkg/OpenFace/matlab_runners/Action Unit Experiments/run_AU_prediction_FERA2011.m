clear

addpath(genpath('helpers/'));
find_FERA2011;

out_loc = './AU_predictions/out_fera/';
if(~exist(out_loc, 'file'))
    mkdir(out_loc);
end

%%
if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

fera_dirs = dir([FERA2011_dir, 'train*']);

for f1=1:numel(fera_dirs)

    vid_files = dir([FERA2011_dir, fera_dirs(f1).name, '/*.avi']);

    for v=1:numel(vid_files)

        command = [executable ' -aus -au_static '];

        curr_vid = [FERA2011_dir, fera_dirs(f1).name, '/', vid_files(v).name];

        command = cat(2, command, [' -f "' curr_vid '" -out_dir "' out_loc '"']);

        if(isunix)
            unix(command, '-echo');
        else
            dos(command);
        end
    end
end

%%
[ labels_gt, valid_ids, filenames] = extract_FERA2011_labels(FERA2011_dir, all_recs, all_aus);
labels_gt = cat(1, labels_gt{:});

for i=1:numel(filenames)
    filenames{i} = filenames{i}(1:end-3);
end

%% Identifying which column IDs correspond to which AU
tab = readtable([out_loc, 'train_001.csv']);
column_names = tab.Properties.VariableNames;

% As there are both classes and intensities list and evaluate both of them
aus_pred_class = [];

inds_class_in_file = [];

for c=1:numel(column_names)
    if(strfind(column_names{c}, '_c') > 0)
        aus_pred_class = cat(1, aus_pred_class, int32(str2num(column_names{c}(3:end-2))));
        inds_class_in_file = cat(1, inds_class_in_file, c);
    end
end

%%
inds_au_class = zeros(size(all_aus));

for ind=1:numel(all_aus)  
    if(~isempty(find(aus_pred_class==all_aus(ind), 1)))
        inds_au_class(ind) = find(aus_pred_class==all_aus(ind));
    end
end

%%
preds_all_class = [];

for i=1:numel(filenames)
   
    fname = dir([out_loc, '/*', filenames{i}, '.csv']);
    fname = fname(1).name;
    
    preds = dlmread([out_loc '/' fname], ',', 1, 0);
    
    % Read all of the intensity AUs
    preds_class = preds(:, inds_class_in_file);
    
    preds_all_class = cat(1, preds_all_class, preds_class);
end

%%
f = fopen('results/FERA2011_res_class.txt', 'w');
au_res = [];
for au = 1:numel(all_aus)
    if(inds_au_class(au) ~= 0)

        tp = sum(labels_gt(:,au) == 1 & preds_all_class(:, inds_au_class(au)) == 1);
        fp = sum(labels_gt(:,au) == 0 & preds_all_class(:, inds_au_class(au)) == 1);
        fn = sum(labels_gt(:,au) == 1 & preds_all_class(:, inds_au_class(au)) == 0);
        tn = sum(labels_gt(:,au) == 0 & preds_all_class(:, inds_au_class(au)) == 0);

        precision = tp./(tp+fp);
        recall = tp./(tp+fn);

        f1 = 2 * precision .* recall ./ (precision + recall);

        fprintf(f, 'AU%d class, Precision - %.3f, Recall - %.3f, F1 - %.3f\n', all_aus(au), precision, recall, f1);
        au_res = cat(1, au_res, f1);
    end
    
end
fclose(f);