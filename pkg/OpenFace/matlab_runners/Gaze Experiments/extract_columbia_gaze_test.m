clear
     
curr_dir = cd('.');

database_root = ['D:\Datasets\Columbia Gaze Data Set\'];
p_dirs = dir([database_root, '0*']);

output = './columbia_out/';

%% Perform actual gaze predictions
command = sprintf('"../../Release/FaceTrackingImg.exe" -fx 19720 -fy 19720 -gaze ');

parfor p=1:numel(p_dirs)

    input_loc = ['-fdir "', [database_root, p_dirs(p).name], '" '];
    out_img_loc = ['-oidir "', [output, p_dirs(p).name], '" '];
    out_p_loc = ['-opdir "', [output, p_dirs(p).name], '" '];
    command_c = cat(2, command, input_loc, out_img_loc, out_p_loc);

    command_c = cat(2, command_c, ' -clmwild -multi_view 1');
    dos(command_c);
    
end

%% Perform the evaluation (this needs to be changed)
errors_l = [];
errors_r = [];

all_gaze_pred = [];
all_gaze_gt = [];
angle_errs = [];

angle_errs_naive = [];

frontal_faces = [];

% It's approximate as the actual eye gaze is approximate
for p=1:numel(p_dirs)
   
    out_files = dir([output, p_dirs(p).name, '/*.pose']);
    
    for i=1:numel(out_files)
        out_file = [output, p_dirs(p).name, '/', out_files(i).name];
        A = dlmread(out_file, ' ', 'A79..F79');       
        g_0 = A(1:3);
        g_1 = A(4:6);
                
        g_0 = (g_0 + g_1) / 2;
        g_0 = g_0 ./ norm(g_0);
        g_1 = g_0;
        
        
        all_gaze_pred = cat(1, all_gaze_pred, g_0);
        all_gaze_pred = cat(1, all_gaze_pred, g_1);        
        
        tokens = strsplit(out_files(i).name, '_');
        
        gaze_v_gt = str2double(tokens{4}(1:end-1)) * pi/180;
        gaze_h_gt = str2double(tokens{5}(1:end-1)) * pi/180;
        
        person_h_gt = str2double(tokens{3}(1:end-1)) * pi/180;
        
        if(person_h_gt == 0)
            frontal_faces = cat(1, frontal_faces, [1;1]);
        else
            frontal_faces = cat(1, frontal_faces, [0;0]);
        end
        
        p_target_x = tan(gaze_h_gt) * 2500;
        cam_dist = sqrt(2500^2 + p_target_x^2);                
        
        gaze_target_x = tan(gaze_h_gt) * cam_dist;
        gaze_target_y = -tan(gaze_v_gt) * cam_dist;
        
        gaze_gt_1 = [gaze_target_x, gaze_target_y, 0] - [0,0,cam_dist];
        gaze_gt_1 = gaze_gt_1 ./ norm(gaze_gt_1);
        
        gaze_gt_2 = [gaze_target_x, gaze_target_y, 0] - [0,0,cam_dist];
        gaze_gt_2 = gaze_gt_2 ./ norm(gaze_gt_2);
        
        all_gaze_gt = cat(1, all_gaze_gt, gaze_gt_1);
        all_gaze_gt = cat(1, all_gaze_gt, gaze_gt_2);
        
        % Gaze gt needs to be rotated based on person location
        
        angle_err_1 = acos(gaze_gt_1 * g_0') * 180/pi;
        angle_err_2 = acos(gaze_gt_2 * g_1') * 180/pi;
        angle_errs = cat(1, angle_errs, angle_err_1);
        angle_errs = cat(1, angle_errs, angle_err_2);
        
        angle_errs_n_1 = acos(gaze_gt_1 * [0;0;-1]) * 180/pi;
        angle_errs_n_2 = acos(gaze_gt_2 * [0;0;-1]) * 180/pi;
        angle_errs_naive = cat(1, angle_errs_naive, angle_errs_n_1);
        angle_errs_naive = cat(1, angle_errs_naive, angle_errs_n_2);
    end
    
end