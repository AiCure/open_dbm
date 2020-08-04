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

% Dependencies for face detection (MatConvNet), remove if not present
setup_mconvnet;
addpath('../face_detection/mtcnn/');

%%
root_dir = '../../samples/';
images = dir([root_dir, '*.jpg']);

verbose = true;

for img=1:numel(images)
    image_orig = imread([root_dir images(img).name]);

    % Face detectiopn
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

        if(exist('early_term_params', 'var'))
            [shape,~,~,lhood,lmark_lhood,view_used] =...
                Fitting_from_bb_multi_hyp(image_gray, [], bbox, pdm, patches, clmParams, views, early_term_params);
        else
            [shape,~,~,lhood,lmark_lhood,view_used] =...
                Fitting_from_bb_multi_hyp(image_gray, [], bbox, pdm, patches, clmParams, views);
        end
        
        % shape correction for matlab format
        shape = shape + 1;

        if(verbose)

            % valid points to draw (not to draw self-occluded ones)
            v_points = logical(patches(1).visibilities(view_used,:));

            try

            plot(shape(v_points,1), shape(v_points',2),'.r','MarkerSize',20);
            plot(shape(v_points,1), shape(v_points',2),'.b','MarkerSize',10);

            catch warn

            end
        end

    end
    hold off;
    
end