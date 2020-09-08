clear

addpath(genpath('helpers/'));
find_SEMAINE;

out_loc = './AU_predictions/out_SEMAINE/';
if(~exist(out_loc, 'file'))
    mkdir(out_loc);
end

if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end
%%
parfor f1=1:numel(devel_recs)


    if(isdir([SEMAINE_dir, devel_recs{f1}]))
        
        vid_file = dir([SEMAINE_dir, devel_recs{f1}, '/*.avi']);

        f1_dir = devel_recs{f1};

        curr_vid = [SEMAINE_dir, f1_dir, '/', vid_file.name];

        command = sprintf('%s -aus -f "%s" -out_dir "%s" ', executable, curr_vid, out_loc);
        
        if(isunix)
            unix(command, '-echo');
        else
            dos(command);
        end

    end
end

%% Actual model evaluation
[ labels, valid_ids, vid_ids, vid_names ] = extract_SEMAINE_labels(SEMAINE_dir, devel_recs, aus_SEMAINE);

labels_gt = cat(1, labels{:});

%% Identifying which column IDs correspond to which AU
tab = readtable([out_loc, vid_names{1}, '.csv']);
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
inds_au_class = zeros(size(aus_SEMAINE));

for ind=1:numel(aus_SEMAINE)  
    if(~isempty(find(aus_pred_class==aus_SEMAINE(ind), 1)))
        inds_au_class(ind) = inds_class_in_file(aus_pred_class==aus_SEMAINE(ind));
    end
end

preds_all = [];
for i=1:numel(vid_names)
   
    fname = [out_loc, vid_names{i}, '.csv'];
    preds = dlmread(fname, ',', 1, 0);
    preds_all = cat(1, preds_all, preds(vid_ids(i,1):vid_ids(i,2) - 1, :));
end

%%
f = fopen('results/SEMAINE_valid_res.txt', 'w');
f1s = zeros(1, numel(aus_SEMAINE));
for au = 1:numel(aus_SEMAINE)
    
    if(inds_au_class(au) ~= 0)
        tp = sum(labels_gt(:,au) == 1 & preds_all(:, inds_au_class(au)) == 1);
        fp = sum(labels_gt(:,au) == 0 & preds_all(:, inds_au_class(au)) == 1);
        fn = sum(labels_gt(:,au) == 1 & preds_all(:, inds_au_class(au)) == 0);
        tn = sum(labels_gt(:,au) == 0 & preds_all(:, inds_au_class(au)) == 0);

        precision = tp./(tp+fp);
        recall = tp./(tp+fn);

        f1 = 2 * precision .* recall ./ (precision + recall);
        f1s(au) = f1;
        fprintf(f, 'AU%d class, Precision - %.3f, Recall - %.3f, F1 - %.3f\n', aus_SEMAINE(au), precision, recall, f1);
    end    
    
end
fclose(f);