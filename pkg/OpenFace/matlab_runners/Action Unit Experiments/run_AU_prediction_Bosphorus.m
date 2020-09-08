% Perform static model prediction using images

clear

addpath('./helpers');

find_Bosphorus;
out_loc = './AU_predictions/out_bosph/';
if(~exist(out_loc, 'file'))
    mkdir(out_loc);
end

%%
if(isunix)
    executable = '"../../build/bin/FaceLandmarkImg"';
else
    executable = '"../../x64/Release/FaceLandmarkImg.exe"';
end

bosph_dirs = dir([Bosphorus_dir, '/BosphorusDB/BosphorusDB/bs*']);

%%
parfor f1=1:numel(bosph_dirs)

    command = executable;

    input_dir = [Bosphorus_dir, '/BosphorusDB/BosphorusDB/', bosph_dirs(f1).name];
    command = cat(2, command, [' -fdir "' input_dir '" -out_dir "' out_loc '"']);
    command = cat(2, command, ' -multi_view 1 -wild -aus ');

    if(isunix)
        unix(command, '-echo')
    else
        dos(command);
    end
end

%%

aus_Bosph = [1, 2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 17, 20, 23, 25, 26, 45];

[ labels_gt, valid_ids, filenames] = extract_Bosphorus_labels(Bosphorus_dir, all_recs, aus_Bosph);

%% Read the predicted values

% First read the first file to get the column ids
tab = readtable([out_loc, filenames{1}, '.csv']);
column_names = tab.Properties.VariableNames;
aus_det_id = cellfun(@(x) ~isempty(x) && x==5, strfind(column_names, '_c'));
aus_det_cell = column_names(aus_det_id);
aus_det = zeros(size(aus_det_cell));
for i=1:numel(aus_det)
    aus_det(i) = str2num(aus_det_cell{i}(3:4));
end

%%
labels_pred = zeros(size(labels_gt));
for i=1:numel(filenames)

    % Only if face was detected in the image, if not the AUs will be 0
    if(exist([out_loc, filenames{i}, '.csv'], 'file'))
        % Will need to read the relevant AUs only
        all_params  = dlmread([out_loc, filenames{i}, '.csv'], ',', 1, 0);

        % if multiple faces detected just take the first row
        aus_pred = all_params(1, aus_det_id);

        for k=1:numel(aus_det)
            if(sum(aus_Bosph == aus_det(k))>0)
                labels_pred(i, aus_Bosph == aus_det(k)) = aus_pred(k);
            end
        end        
    end
end

%%
f = fopen('results/Bosphorus_res_class.txt', 'w');
labels_gt_bin = labels_gt;
labels_gt_bin(labels_gt_bin > 1) = 1;
f1s_class = zeros(1, numel(aus_Bosph));
for au = 1:numel(aus_Bosph)
  
    tp = sum(labels_gt_bin(:,au) == 1 & labels_pred(:, au) == 1);
    fp = sum(labels_gt_bin(:,au) == 0 & labels_pred(:, au) == 1);
    fn = sum(labels_gt_bin(:,au) == 1 & labels_pred(:, au) == 0);
    tn = sum(labels_gt_bin(:,au) == 0 & labels_pred(:, au) == 0);

    precision = tp./(tp+fp);
    recall = tp./(tp+fn);

    f1 = 2 * precision .* recall ./ (precision + recall);
    f1s_class(au) = f1;

    fprintf(f, 'AU%d class, Precision - %.3f, Recall - %.3f, F1 - %.3f\n', aus_Bosph(au), precision, recall, f1);

end
fclose(f);

%% Read the predicted values for intensities

% First read the first file to get the column ids
tab = readtable([out_loc, filenames{1}, '.csv']);
column_names = tab.Properties.VariableNames;
aus_det_id = cellfun(@(x) ~isempty(x) && x==5, strfind(column_names, '_r'));
aus_det_cell = column_names(aus_det_id);
aus_det = zeros(size(aus_det_cell));
for i=1:numel(aus_det)
    aus_det(i) = str2num(aus_det_cell{i}(3:4));
end

%%
labels_pred = zeros(size(labels_gt));
for i=1:numel(filenames)
    % Only if face was detected in the image, if not the AUs will be 0
    if(exist([out_loc, filenames{i}, '.csv'], 'file'))        
        % Will need to read the relevant AUs only
        all_params  = dlmread([out_loc, filenames{i}, '.csv'], ',', 1, 0);

        % if multiple faces detected just take the first row
        aus_pred = all_params(1, aus_det_id);

        for k=1:numel(aus_det)
            if(sum(aus_Bosph == aus_det(k))>0)
                labels_pred(i, aus_Bosph == aus_det(k)) = aus_pred(k);
            end
        end
    end
end

%%
f = fopen('results/Bosphorus_res_int.txt', 'w');
cccs_reg = zeros(1, numel(aus_Bosph));
for au = 1:numel(aus_Bosph)
  
    [ ~, ~, corrs, ccc, rms, ~ ] = evaluate_regression_results( labels_pred(:, au), labels_gt(:, au));
    
    cccs_reg(au) = ccc;
    
    fprintf(f, 'AU%d intensity, Corr - %.3f, RMS - %.3f, CCC - %.3f\n', aus_Bosph(au), corrs, rms, ccc);

end
fclose(f);
