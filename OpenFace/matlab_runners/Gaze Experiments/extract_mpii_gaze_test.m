clear
     
curr_dir = cd('.');

% Replace this with your downloaded 300-W train data
if(exist([getenv('USERPROFILE') '/Dropbox/AAM/eye_clm/mpii_data/'], 'file'))
    database_root = [getenv('USERPROFILE') '/Dropbox/AAM/eye_clm/mpii_data/'];    
elseif(exist('D:\Dropbox/Dropbox/AAM/eye_clm/mpii_data/', 'file'))
    database_root = 'D:\Dropbox/Dropbox/AAM/eye_clm/mpii_data/';    
elseif(exist('F:\Dropbox/AAM/eye_clm/mpii_data/', 'file'))
    database_root = 'F:\Dropbox/AAM/eye_clm/mpii_data/';    
elseif(exist('/multicomp/datasets/mpii_gaze/mpii_data/', 'file'))
    database_root = '/multicomp/datasets/mpii_gaze/mpii_data/';    
elseif(exist('/media/tadas/5E08AE0D08ADE3ED/Dropbox/AAM/eye_clm/mpii_data/', 'file'))
    database_root = '/media/tadas/5E08AE0D08ADE3ED/Dropbox/AAM/eye_clm/mpii_data/';
else
    fprintf('MPII gaze dataset not found\n');
end

output = './mpii_out/';

%% Perform actual gaze predictions
if(isunix)
    executable = '"../../build/bin/FaceLandmarkImg"';
else
    executable = '"../../x64/Release/FaceLandmarkImg.exe"';
end

command = sprintf('%s -fx 1028 -fy 1028  ', executable);
p_dirs = dir([database_root, 'p*']);

parfor p=1:numel(p_dirs)
    tic

    input_loc = ['-gaze -fdir "', [database_root, p_dirs(p).name], '" '];
    out_img_loc = ['-out_dir "', [output, p_dirs(p).name], '" '];
    command_c = cat(2, command, input_loc, out_img_loc);

    if(isunix)
        unix(command_c, '-echo');
    else
        dos(command_c);
    end

end
%%

% Extract the results
predictions_l = zeros(750, 3);
predictions_r = zeros(750, 3);
gt_l = zeros(750, 3);
gt_r = zeros(750, 3);

angle_err_l = zeros(750,1);
angle_err_r = zeros(750,1);

p_dirs = dir([database_root, 'p*']);
curr = 1;
for p=1:numel(p_dirs)
    load([database_root, p_dirs(p).name, '/Data.mat']);

    for i=1:size(filenames, 1)

        fname = sprintf('%s/%s/%d_%d_%d_%d_%d_%d_%d.csv', output, p_dirs(p).name,...
             filenames(i,1), filenames(i,2), filenames(i,3), filenames(i,4),...
             filenames(i,5), filenames(i,6), filenames(i,7));
        
        if(p==1 && i==1)
            % First read in the column names
            tab = readtable(fname);
            column_names = tab.Properties.VariableNames;

            gaze_0_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'gaze_0_'));
            gaze_1_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'gaze_1_'));
        end
        
        if(exist(fname, 'file'))
            all_params  = dlmread(fname, ',', 1, 0);
        else
            all_params = [];
        end
        
        % If there was a face detected
        if(size(all_params,1)>0)
            predictions_r(curr,:) = all_params(1,gaze_0_ids);
            predictions_l(curr,:) = all_params(1,gaze_1_ids);
        else
            predictions_r(curr,:) = [0,0,-1];
            predictions_l(curr,:) = [0,0,-1];            
        end

        head_rot = headpose(i,1:3);
 
        gt_r(curr,:) = data.right.gaze(i,:)';
        gt_r(curr,:) = gt_r(curr,:) / norm(gt_r(curr,:));
        gt_l(curr,:) = data.left.gaze(i,:)';
        gt_l(curr,:) = gt_l(curr,:) / norm(gt_l(curr,:));

        angle_err_l(curr) = acos(predictions_l(curr,:) * gt_l(curr,:)') * 180/pi;
        angle_err_r(curr) = acos(predictions_r(curr,:) * gt_r(curr,:)') * 180/pi;

        curr = curr + 1;
    end

end
all_errors = cat(1, angle_err_l, angle_err_r);
mean_error = mean(all_errors);
median_error = median(all_errors);
save('mpii_1500_errs.mat', 'all_errors', 'mean_error', 'median_error');

f = fopen('mpii_1500_errs.txt', 'w');
fprintf(f, 'Mean error, median error\n');
fprintf(f, '%.3f, %.3f\n', mean_error, median_error);
fclose(f);