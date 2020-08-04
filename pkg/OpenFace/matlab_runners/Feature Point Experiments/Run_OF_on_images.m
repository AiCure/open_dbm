function [ err_outline, err_no_outline ] = Run_OF_on_images(output_loc, database_root, varargin)

dataset_dirs = {};

if(any(strcmp(varargin, 'use_afw')))
    afw_loc = [database_root '/AFW/'];
    dataset_dirs = cat(1, dataset_dirs, afw_loc); 
end
if(any(strcmp(varargin, 'use_lfpw')))
    lfpw_loc = [database_root 'lfpw/testset/'];
    dataset_dirs = cat(1, dataset_dirs, lfpw_loc); 
end
if(any(strcmp(varargin, 'use_ibug')))
    ibug_loc = [database_root 'ibug/'];
    dataset_dirs = cat(1, dataset_dirs, ibug_loc); 
end
if(any(strcmp(varargin, 'use_helen')))
    helen_loc = [database_root '/helen/testset/'];
    dataset_dirs = cat(1, dataset_dirs, helen_loc); 
end

if(any(strcmp(varargin, 'verbose')))
    verbose = true;
else
    verbose = false;
end
      
if(isunix)
    executable = '"../../build/bin/FaceLandmarkImg"';
else
    executable = '"../../x64/Release/FaceLandmarkImg.exe"';
end
    
if(any(strcmp(varargin, 'model')))
    model = varargin{find(strcmp(varargin, 'model')) + 1};
else
    % the default model is the 68 point in the wild one
    model = '"model/main_wild.txt"';
end

if(any(strcmp(varargin, 'multi_view')))
    multi_view = varargin{find(strcmp(varargin, 'multi_view')) + 1};
else
    multi_view = 0;
end

command = sprintf('%s -mloc %s -multi_view %s -2Dfp ', executable, model, num2str(multi_view));

tic
for i=1:numel(dataset_dirs)
    
    command_c = sprintf('%s -fdir "%s" -bboxdir "%s" -out_dir "%s" -wild ',...
        command, dataset_dirs{i},  dataset_dirs{i}, output_loc);
    
    if(isunix)
        unix(command_c, '-echo');
    else
        dos(command_c);
    end
    
end
toc

%%

% Extract the error sizes
dirs = {[database_root '/AFW/'];
    [database_root '/ibug/'];
    [database_root '/helen/testset/'];
    [database_root 'lfpw/testset/'];};

landmark_dets = dir([output_loc '/*.csv']);

landmark_det_dir = [output_loc '/'];

num_imgs = size(landmark_dets,1);

labels = zeros(68,2,num_imgs);

shapes = zeros(68,2,num_imgs);

curr = 0;

% work out which columns in the csv file are relevant
tab = readtable([landmark_det_dir, landmark_dets(1).name]);
column_names = tab.Properties.VariableNames;
landmark_inds_x = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'x_'));
landmark_inds_y = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'y_'));

for i=1:numel(dirs)
    
    
    gt_labels = dir([dirs{i}, '*.pts']); 
    
    for g=1:numel(gt_labels)
        curr = curr+1;
        
        gt_landmarks = dlmread([dirs{i}, gt_labels(g).name], ' ', 'A4..B71');
        [~, name, ~] = fileparts(gt_labels(g).name);
        % find the corresponding detection       
        all_params  = dlmread([landmark_det_dir, name, '.csv'], ',', 1, 0);

        landmark_det = [all_params(landmark_inds_x); all_params(landmark_inds_y)]';
        
        labels(:,:,curr) = gt_landmarks;
            
        if(size(landmark_det,1) == 66)
            inds_66 = [[1:60],[62:64],[66:68]];
            shapes(inds_66,:,curr) = landmark_det;
        else
            shapes(:,:,curr) = landmark_det;
        end
    end
    
end
         
% Convert to correct format, so as to have same feature points in ground
% truth and detections
if(size(shapes,2) == 66 && size(labels,2) == 68)
    inds_66 = [[1:60],[62:64],[66:68]];
    
    labels = labels(inds_66,:,:);
    shapes = shapes(inds_66,:,:);
end

% Center the pixel, and convert to OCV format
labels = labels - 2.0;

err_outline = compute_error(labels, shapes);

labels_no_out = labels(18:end,:,:);
shapes_no_out = shapes(18:end,:,:);

err_no_outline = compute_error(labels_no_out, shapes_no_out);

%%

save([output_loc, 'res.mat'], 'labels', 'shapes', 'err_outline', 'err_no_outline');
    
end