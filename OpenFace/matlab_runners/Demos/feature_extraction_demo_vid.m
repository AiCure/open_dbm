% A demo script that demonstrates how to process a single video file using
% OpenFace and extract and visualize all of the features

clear

% The location executable will depend on the OS
if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

% Input file
in_file = '../../samples/default.wmv';

% Where to store the output
output_dir = './processed_features/';

% This will take file after -f and output all the features to directory
% after -out_dir
command = sprintf('%s -f "%s" -out_dir "%s" -verbose', executable, in_file, output_dir);
                 
if(isunix)
    unix(command);
else
    dos(command);
end

%% Demonstrating reading the output files

% Most of the features will be in the csv file in the output directory with
% the same name as the input file
[~,name,~] = fileparts(in_file);
output_csv = sprintf('%s/%s.csv', output_dir, name);

% First read in the column names, to know which columns to read for
% particular features
tab = readtable(output_csv);
column_names = tab.Properties.VariableNames;

% Read all of the data
all_params  = dlmread(output_csv, ',', 1, 0);

% This indicates which frames were succesfully tracked

% Find which column contains success of tracking data and timestamp data
valid_ind = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'success'));
time_stamp_ind = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'timestamp'));

% Extract tracking success data and only read those frame
valid_frames = logical(all_params(:,valid_ind));

% Get the timestamp data
time_stamps = all_params(valid_frames, time_stamp_ind);

%% Finding which header line starts with p_ (basically model params)
shape_inds = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'p_'));

% Output rigid (first 6) and non-rigid shape parameters
shape_params  = all_params(valid_frames, shape_inds);

figure
plot(time_stamps, shape_params);
title('Shape parameters');
xlabel('Time (s)');

%% Demonstrate 2D landmarks
landmark_inds_x = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'x_'));
landmark_inds_y = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'y_'));

xs = all_params(valid_frames, landmark_inds_x);
ys = all_params(valid_frames, landmark_inds_y);

eye_landmark_inds_x = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'eye_lmk_x_'));
eye_landmark_inds_y = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'eye_lmk_y_'));

eye_xs = all_params(valid_frames, eye_landmark_inds_x);
eye_ys = all_params(valid_frames, eye_landmark_inds_y);

figure

for j = 1:size(xs,1)
    plot(xs(j,:), -ys(j,:), '.');
    hold on;
    plot(eye_xs(j,:), -eye_ys(j,:), '.r');
    hold off;
    
    xlim([min(xs(1,:)) * 0.5, max(xs(2,:))*1.4]);
    ylim([min(-ys(1,:)) * 1.4, max(-ys(2,:))*0.5]);
    xlabel('x (px)');
    ylabel('y (px)');
    drawnow
end


%% Demonstrate 3D landmarks
landmark_inds_x = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'X_'));
landmark_inds_y = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'Y_'));
landmark_inds_z = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'Z_'));

xs = all_params(valid_frames, landmark_inds_x);
ys = all_params(valid_frames, landmark_inds_y);
zs = all_params(valid_frames, landmark_inds_z);

eye_landmark_inds_x = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'eye_lmk_X_'));
eye_landmark_inds_y = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'eye_lmk_Y_'));
eye_landmark_inds_z = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'eye_lmk_Z_'));

eye_xs = all_params(valid_frames, eye_landmark_inds_x);
eye_ys = all_params(valid_frames, eye_landmark_inds_y);
eye_zs = all_params(valid_frames, eye_landmark_inds_z);

figure
for j = 1:size(xs,1)
    plot3(xs(j,:), ys(j,:), zs(j,:), '.');axis equal;
    hold on;
    plot3(eye_xs(j,:), eye_ys(j,:), eye_zs(j,:), '.r');
    hold off;
    xlabel('X (mm)');
    ylabel('Y (mm)');    
    zlabel('Z (mm)');    
    drawnow
end

%% Demonstrate AUs
au_reg_inds = cellfun(@(x) ~isempty(x) && x==5, strfind(column_names, '_r'));

aus = all_params(valid_frames, au_reg_inds);
figure
plot(time_stamps, aus);
title('Facial Action Units (intensity)');
xlabel('Time (s)');
ylabel('Intensity');
ylim([0,6]);

au_class_inds = cellfun(@(x) ~isempty(x) && x==5, strfind(column_names, '_c'));

aus = all_params(valid_frames, au_class_inds);
figure
plot(time_stamps, aus);
title('Facial Action Units (presense)');
xlabel('Time (s)');
ylim([0,2]);
%% Demo pose
pose_inds = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'pose_'));

pose = all_params(valid_frames, pose_inds);
figure
plot(time_stamps, pose);
title('Pose (rotation and translation)');
xlabel('Time (s)');

%% Demo gaze
gaze_inds = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'gaze_angle'));

% Read gaze (x,y,z) for one eye and (x,y,z) for another
gaze = all_params(valid_frames, gaze_inds);

plot(time_stamps, gaze(:,1), 'DisplayName', 'Left - right');
hold on;
plot(time_stamps, gaze(:,2), 'DisplayName', 'Up - down');
xlabel('Time(s)') % x-axis label
ylabel('Angle radians') % y-axis label
legend('show');
hold off;

%% Output HOG files
output_hog_file = sprintf('%s/%s.hog', output_dir, name);
[hog_data, valid_inds] = Read_HOG_file(output_hog_file);

%% Output aligned images
output_aligned_dir = sprintf('%s/%s_aligned/', output_dir, name);
img_files = dir([output_aligned_dir, '/*.bmp']);
imgs = cell(numel(img_files, 1));
for i=1:numel(img_files)
   imgs{i} = imread([ output_aligned_dir, '/', img_files(i).name]);
   imshow(imgs{i})
   drawnow
end