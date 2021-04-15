clear
addpath('../PDM_helpers/');
addpath(genpath('../fitting/'));
addpath('../models/');
addpath(genpath('../face_detection'));
addpath('../CCNF/');

%% 
vid_dir = '../../samples/';
vids = cat(1, dir([vid_dir, '*.avi']), dir([vid_dir, '*.wmv']));

%%
verbose = true;
record = true;

%% loading the patch experts
% Default OpenFace landmark model, using CE-CLM patch experts
[patches, pdm, clmParams, early_term_params] = Load_CECLM_general();

% faster but less accurate
%[patches, pdm, clmParams] = Load_CLNF_general();

% even faster but even less accurate
%[patches, pdm, clmParams] = Load_CLM_general();

% load the face validator and add its dependency
load('../face_validation/trained/faceCheckers.mat', 'faceCheckers');
addpath(genpath('../face_validation'));
od = cd('../face_validation/');
setup;
cd(od);

% Setup the face detector (remove the setup mconvnet if not using
% MatConvNet)
setup_mconvnet;
addpath('../face_detection/mtcnn/');


%%
for v=1:numel(vids)
    % load the video
    vr = VideoReader([vid_dir, vids(v).name]);
    
    [~,fname,~] = fileparts(vids(v).name);
    
    if(record)
        if(~exist('./tracked_vids', 'file'))
            mkdir('tracked_vids');
        end
        writerObj = VideoWriter(sprintf('./tracked_vids/%s.avi', fname));
        open(writerObj);
    end
    
    det = false;
    initialised = false;
    
    nFrames = vr.NumberOfFrames;
    % Read one frame at a time.

    all_local_params = zeros(nFrames, numel(pdm.E));
    all_global_params = zeros(nFrames,6);

    for i = 1 : nFrames

        % if this version throws a "Dot name reference on non-scalar structure"
        % error change obj.NumberOfFrames to obj(1).NumberOfFrames (in two
        % places in read function) or surround it with an empty try catch
        % statement
        image_orig = read(vr, i);
        if((~det && mod(i,4) == 0) || ~initialised)
            
            % Face detection
            [bboxs] = detect_faces(image_orig, 'mtcnn');

            % If MTCNN detector not available, can use the cascaded regression one
            % [bboxs] = detect_faces(image_orig, 'cascade');

            if(~isempty(bboxs))

                % Pick the biggest face for tracking
                [~,ind] = max(bboxs(:,3) - bboxs(:,1));                    
                bbox = bboxs(ind,:);
                
                % Discard overly small detections
                if(bbox(3) - bbox(1) > 40)
                    
                    % Either infer the local and global shape parameters
                    % from the detected landmarks or just using the
                    % bounding box
                        
                    num_points = numel(pdm.M) / 3;

                    M = reshape(pdm.M, num_points, 3);
                    width_model = max(M(:,1)) - min(M(:,1));
                    height_model = max(M(:,2)) - min(M(:,2));

                    a = (((bbox(3) - bbox(1)) / width_model) + ((bbox(4) - bbox(2))/ height_model)) / 2;

                    tx = (bbox(3) + bbox(1))/2;
                    ty = (bbox(4) + bbox(2))/2;

                    % correct it so that the bounding box is just around the minimum
                    % and maximum point in the initialised face
                    tx = tx - a*(min(M(:,1)) + max(M(:,1)))/2;
                    ty = ty + a*(min(M(:,2)) + max(M(:,2)))/2;

                    % visualisation
                    g_param_n = [a, 0, 0, 0, tx, ty]';

                    l_param_n = zeros(size(pdm.E));
                    
                    % If tracking has not started trust the detection
                    if(~initialised)
                        g_param = g_param_n;
                        l_param = l_param_n;
                        det = true;
                        initialised = true;
                    else
                        % If tracking has already started double check the
                        % detection
                        shape_new = GetShapeOrtho(pdm.M, pdm.V, params, g_param_n);
                    
                        dec = face_check_cnn(image, shape_new, g_param, faceCheckers);
                        
                        if(dec < 0.5)
                            det = true;
                            g_param = g_param_n;
                            l_param = l_param_n;
                        else      
                            det = false;
                        end
                    end
                    
                end
            end
        end
        if(size(image_orig,3) == 3)
            image = rgb2gray(image_orig);
        else
            image = image_orig;
        end

        d_image = [];             

        if(initialised)
            [shape,g_param,l_param,lhood,lmark_lhood,view_used] = Fitting_from_bb(image, d_image, bbox, pdm, patches, clmParams, 'gparam', g_param, 'lparam', l_param);
            all_local_params(i,:) = l_param;
            all_global_params(i,:) = g_param;
            
            dec = face_check_cnn(image, shape, g_param, faceCheckers);
            
            if(dec < 0.5)
                clmParams.window_size = [19,19; 17,17;];
                clmParams.numPatchIters = 2;
                det = true;
            else
                clmParams.window_size = [21,21; 19,19; 17,17;];
                clmParams.numPatchIters = 3;
                det = false;
            end
        end
        
        if(verbose)

            try
            if(max(image_orig(:)) > 1)
                imshow(double(image_orig)/255, 'Border', 'tight');
            else
                imshow(double(image_orig), 'Border', 'tight');
            end
            axis equal;
            hold on;

            if(initialised)
                plot(shape(:,1), shape(:,2),'.r','MarkerSize',20);
                plot(shape(:,1), shape(:,2),'.b','MarkerSize',10);
            end
            hold off;
            drawnow expose;
            pause(0.01);

            if(record)
                frame = getframe;
                writeVideo(writerObj,frame);
            end
            
            catch warn
                fprintf('%s', warn.message);
            end
        end

    end
    if(record)
        close(writerObj);
    end
    
    close all;
    
    experiments.local_params = all_local_params;
    experiments.global_params = all_global_params;

end