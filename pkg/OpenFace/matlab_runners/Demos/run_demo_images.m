clear
if(isunix)
    executable = '"../../build/bin/FaceLandmarkImg"';
else
    executable = '"../../x64/Release/FaceLandmarkImg.exe"';
end
    
in_dir  = '../../samples/';
out_dir = './demo_img/';

model = 'model/main_ceclm_general.txt'; % Trained on in the wild, menpo and multi-pie data (a CE-CLM model)

% Uncomment the below models if you want to try them
%model = 'model/main_clnf_general.txt'; % Trained on in the wild and multi-pie data (a CLNF model)

%model = 'model/main_clnf_wild.txt'; % Trained on in-the-wild data only

%model = 'model/main_clm_general.txt'; % Trained on in the wild and multi-pie data (less accurate SVR/CLM model)
%model = 'model/main_clm_wild.txt'; % Trained on in-the-wild

% Load images (-fdir), output images and all the features (-out_dir), use a
% user specified model (-mloc), and visualize everything (-verbose)
command = sprintf('%s -fdir "%s" -out_dir "%s" -verbose -mloc "%s" ', executable, in_dir, out_dir, model);

% Demonstrates the multi-hypothesis slow landmark detection (more accurate
% when dealing with non-frontal faces and less accurate face detections)
% Comment to skip this functionality
command = cat(2, command, ' -wild -multi_view 1');

if(isunix)
    unix(command);
else
    dos(command);
end