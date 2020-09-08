clear

if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end
    
if(exist([getenv('USERPROFILE') '/Dropbox/AAM/test data/'], 'file'))
    database_root = [getenv('USERPROFILE') '/Dropbox/AAM/test data/'];    
elseif(exist('D:/Dropbox/Dropbox/AAM/test data/', 'file'))
    database_root = 'D:/Dropbox/Dropbox/AAM/test data/';
elseif(exist('F:/Dropbox/AAM/test data/', 'file'))
    database_root = 'F:/Dropbox/AAM/test data/';
elseif(exist('/media/tadas/5E08AE0D08ADE3ED/Dropbox/AAM/test data/', 'file'))
    database_root = '/media/tadas/5E08AE0D08ADE3ED/Dropbox/AAM/test data/';
else
    database_root = '/multicomp/datasets/';
end

database_root = [database_root, '/ytceleb/'];

in_vids = dir([database_root '/*.avi']);

%%
output = 'yt_res/ce-clm';

command = sprintf('%s -2Dfp -out_dir "%s" ', executable, output);
% add all videos to single argument list (so as not to load the model anew
% for every video)
for i=1:numel(in_vids)
    
    in_file_name = [database_root, '/', in_vids(i).name];        
    
    command = cat(2, command, [' -f "' in_file_name '" ']);                     
end

if(isunix)
    unix(command, '-echo')
else
    dos(command);
end
%%
output = 'yt_res/clnf';

command = sprintf('%s -2Dfp -out_dir "%s" -mloc model/main_clnf_general.txt ', executable, output);

% add all videos to single argument list (so as not to load the model anew
% for every video)
for i=1:numel(in_vids)    
    in_file_name = [database_root, '/', in_vids(i).name];            
    command = cat(2, command, [' -f "' in_file_name '"']);                     
end

if(isunix)
    unix(command, '-echo')
else
    dos(command);
end

%%
output = 'yt_res/clm';

command = sprintf('%s -2Dfp -out_dir "%s" -mloc model/main_clm_general.txt ', executable, output);

% add all videos to single argument list (so as not to load the model anew
% for every video)
for i=1:numel(in_vids)    
    in_file_name = [database_root, '/', in_vids(i).name];            
    command = cat(2, command, [' -f "' in_file_name '"']);                     
end

if(isunix)
    unix(command, '-echo')
else
    dos(command);
end
%% evaluating yt datasets
d_loc = 'yt_res/ce-clm/';
d_loc_clnf = 'yt_res/clnf/';
d_loc_clm = 'yt_res/clm/';

files_yt = dir([d_loc, '/*.csv']);
preds_all = [];
preds_all_clnf = [];
preds_all_clm = [];
gts_all = [];
for i = 1:numel(files_yt)
    [~, name, ~] = fileparts(files_yt(i).name);

    fname = [d_loc, files_yt(i).name];
    if(i == 1)
        % First read in the column names
        tab = readtable(fname);
        column_names = tab.Properties.VariableNames;

        confidence_id = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'confidence'));
        x_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'x_'));
        y_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'y_'));
    end

    all_params  = dlmread(fname, ',', 1, 0);
    
    xs = all_params(:, x_ids);
    ys = all_params(:, y_ids);
    pred_landmarks = zeros([size(xs,2), 2, size(xs,1)]);
    pred_landmarks(:,1,:) = xs';
    pred_landmarks(:,2,:) = ys';
    
    all_params  = dlmread([d_loc_clnf,  files_yt(i).name], ',', 1, 0);
    
    xs = all_params(:, x_ids);
    ys = all_params(:, y_ids);
    pred_landmarks_clnf = zeros([size(xs,2), 2, size(xs,1)]);
    pred_landmarks_clnf(:,1,:) = xs';
    pred_landmarks_clnf(:,2,:) = ys';    

    all_params  = dlmread([d_loc_clm,  files_yt(i).name], ',', 1, 0);
    
    xs = all_params(:, x_ids);
    ys = all_params(:, y_ids);
    pred_landmarks_clm = zeros([size(xs,2), 2, size(xs,1)]);
    pred_landmarks_clm(:,1,:) = xs';
    pred_landmarks_clm(:,2,:) = ys';    
    
    load([database_root, name, '.mat']);
    preds_all = cat(3, preds_all, pred_landmarks);
    preds_all_clnf = cat(3, preds_all_clnf, pred_landmarks_clnf);
    preds_all_clm = cat(3, preds_all_clm, pred_landmarks_clm);
    gts_all = cat(3, gts_all, labels);
end

%%
[ceclm_error, err_pp_ceclm] = compute_error( gts_all - 1.5,  preds_all);
[clnf_error, err_pp_clnf] = compute_error( gts_all - 1.5,  preds_all_clnf);
[clm_error, err_pp_clm] = compute_error( gts_all - 1.5,  preds_all_clm);

filename = sprintf('results/fps_yt');
save(filename);

% Also save them in a reasonable .txt format for easy comparison
f = fopen('results/fps_yt.txt', 'w');
fprintf(f, 'Model, mean,  median\n');
fprintf(f, 'OpenFace (CE-CLM):  %.4f,   %.4f\n', mean(ceclm_error), median(ceclm_error));
fprintf(f, 'OpenFace (CLNF):  %.4f,   %.4f\n', mean(clnf_error), median(clnf_error));
fprintf(f, 'CLM:   %.4f,   %.4f\n', mean(clm_error), median(clm_error));

fclose(f);
clear 'f'