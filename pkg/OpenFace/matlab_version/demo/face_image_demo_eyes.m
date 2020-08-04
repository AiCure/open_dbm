clear
addpath('../PDM_helpers/');
addpath(genpath('../fitting/'));
addpath('../models/');
addpath(genpath('../face_detection'));
addpath('../CCNF/');

%% loading the patch experts

% Default OpenFace landmark model, using CE-CLM patch experts
[patches, pdm, clmParams, early_term_params] = Load_CECLM_general();

% faster but less accurate
%[patches, pdm, clmParams] = Load_CLNF_general();

% even faster but even less accurate
%[patches, pdm, clmParams] = Load_CLM_general();

% Using a multi-view approach
views = [0,0,0; 0,-30,0; 0,30,0; 0,0,30; 0,0,-30;];
views = views * pi/180;  

% Load the eye landmark models that will be used
[ clmParams_eye, pdm_right_eye, pdm_left_eye, ...
    patches_left_eye, patches_right_eye,...
    left_eye_inds_in_68, right_eye_inds_in_68,...
    left_eye_inds_in_28, right_eye_inds_in_28] = Load_eye_models();

%%
% root_dir = 'C:\Users\Tadas\Dropbox\AAM\test data\gaze_original\p00/';
% images = dir([root_dir, '*.jpg']);

%root_dir = './sample_eye_imgs/';
%images = dir([root_dir, '/*.png']);
root_dir = '../../samples/';
images = dir([root_dir, '*.jpg']);

verbose = true;

for img=1:numel(images)
    image_orig = imread([root_dir images(img).name]);

    % Face detection
    [bboxs] = detect_faces(image_orig, 'mtcnn');
    
    % If MTCNN detector not available, can use the cascaded regression one
    % [bboxs] = detect_faces(image_orig, 'cascade');
    
    if(size(image_orig,3) == 3)
        image_gray = rgb2gray(image_orig);
    else
        image_gray = image_orig; 
    end

    %%

    if(verbose)
        f = figure;    
        if(max(image_orig(:)) > 1)
            imshow(double(image_orig)/255, 'Border', 'tight');
        else
            imshow(double(image_orig), 'Border', 'tight');
        end
        axis equal;
        hold on;
    end

    for i=1:size(bboxs,1)

        % Convert from the initial detected shape to CLM model parameters,
        % if shape is available
        
        bbox = bboxs(i,:);
        
        [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb_multi_hyp(image_gray, [], bbox, pdm, patches, clmParams, views);
        
        % Perform eye fitting now
        [shape, shape_r_eye] = Fitting_from_bb_hierarch(image_gray, pdm, pdm_right_eye, patches_right_eye, clmParams_eye, shape, right_eye_inds_in_68, right_eye_inds_in_28);
        [shape, shape_l_eye] = Fitting_from_bb_hierarch(image_gray, pdm, pdm_left_eye, patches_left_eye, clmParams_eye, shape, left_eye_inds_in_68, left_eye_inds_in_28);
        
        % Convert it to matlab convention
        shape_r_eye = shape_r_eye + 1;
        shape_l_eye = shape_l_eye + 1;
        
        plot(shape_l_eye(9:20,1), shape_l_eye(9:20,2), '.g', 'MarkerSize',7);
        plot(shape_l_eye(1:8,1), shape_l_eye(1:8,2), '.b', 'MarkerSize',7);

        plot(shape_r_eye(9:20,1), shape_r_eye(9:20,2), '.g', 'MarkerSize',7);
        plot(shape_r_eye(1:8,1), shape_r_eye(1:8,2), '.b', 'MarkerSize',7);
    end
    hold off;
    
end