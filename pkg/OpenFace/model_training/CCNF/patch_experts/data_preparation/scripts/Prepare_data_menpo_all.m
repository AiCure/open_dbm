% Convert the training images into a suitable format
function Prepare_data_menpo_all()

    % replace with folder where you downloaded and extracted the 300-W challenge data
    data_root_train = 'C:\Users\tbaltrus\Documents\menpo_data_orig\train/';
    
    PrepareTrainingMenpo(data_root_train, 0.25, 'train');
    PrepareTrainingMenpo(data_root_train, 0.35, 'train');
    PrepareTrainingMenpo(data_root_train, 0.5, 'train');
    PrepareTrainingMenpo(data_root_train, 1.0, 'train');

    data_root_valid = 'C:\Users\tbaltrus\Documents\menpo_data_orig\valid/';
    
    PrepareTrainingMenpo(data_root_valid, 0.25, 'valid');
    PrepareTrainingMenpo(data_root_valid, 0.35, 'valid');
    PrepareTrainingMenpo(data_root_valid, 0.5, 'valid');
    PrepareTrainingMenpo(data_root_valid, 1.0, 'valid');    
end

function PrepareTrainingMenpo( data_root, training_scale, postfix )
%PREPARETRAININGIMAGEMPIE Summary of this function goes here
%   Detailed explanation goes here

    % img size

    imgSize = [400, 400] * training_scale;
    
    %%
    addpath('PDM_helpers/');
    load 'PDM_helpers/pdm_68_aligned_menpo_v5.mat';

    output_location = ['../prepared_data/menpo_', postfix, '_'];
    output_location = [output_location num2str(training_scale,3)];

    num_landmarks = 68;
                   
    % Use mirror images to provide extra training data
    mirror_inds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
                  32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
                  61,65;62,64;68,66];

    % The centres of views we want to extract
    centres_all = [    0,   0,  0
                      0, -20,  0
                      0, -45,  0
                      0, -70,  0                      
                      0,  20,  0
                      0,  45,  0
                      0,  70,  0                       
                      ];
    
    num_centers = size(centres_all, 1);
            
    counter_colour = zeros(num_centers,1);
    
    img_locations = {};
    
    % read in all of the labels, together with names of images used
 
    curr_labels = dir([data_root '\*.pts']);
    imgs = dir([data_root '\*.jpg']);
    if(isempty(imgs))
        imgs = dir([data_root '\*.png']);
    end
        
    landmark_labels = zeros(68, 2, numel(curr_labels));
    for p=1:numel(curr_labels)

        landmarks_c = importdata([data_root, curr_labels(p).name], ' ', 3);
        landmarks_c = landmarks_c.data;
        
        % Correct landmarks if needed
        [new_landmarks] = correctLandmarks(landmarks_c, imgs(p).name);
        
        % Map the profile ones to proper ones
        [landmark_labels_c] = standardiseLandmarks(new_landmarks);
        
        landmark_labels(:,:,p) = landmark_labels_c;
        
        img_locations = cat(1, img_locations, [data_root imgs(p).name]);
    end
                 
    % go through all images, see which centres they match and then add to
    % the appropriate bin
    num_imgs = size(landmark_labels,3);
    scales = zeros(num_imgs, 1);
    views = zeros(num_imgs, 1);
    for lbl=1:num_imgs
       
        Msm = M;
        Vsm = V;
        labels = landmark_labels(:,:,lbl);
        
        % Find the best PDM parameters given the 2D labels
        [ a, R] = fit_PDM_ortho_proj_to_2D( Msm, E, Vsm, labels);
        
        eul = Rot2Euler(R);
        eul = eul * 180 / pi;
        
        % find the closest view
        [~, view] = min(sum(abs(centres_all - repmat(eul, num_centers, 1)),2));
        counter_colour(view) = counter_colour(view) + 1;
        scales(lbl) = a;
        views(lbl) = view;
    end
    
    % preallocate data
    allExamplesColourAllViews = cell(size(centres_all,1),1);    
    landmarkLocationsAllViews = cell(size(centres_all,1),1); 
    
    for r=1:size(centres_all,1)

        allExamplesColourAllViews{r} = uint8(zeros(counter_colour(r), imgSize(1), imgSize(2)));
        landmarkLocationsAllViews{r} = zeros(counter_colour(r), num_landmarks, 2);

        actual_imgs_used_all_views{r} = cell(counter_colour(r), 1);        
    end
    
    counter_colour = zeros(num_centers,1);
    
    % The shape fitting is performed in the reference frame of the
    % patch training scale
    refGlobal = [training_scale, 0, 0, 0, 0, 0]';
        
    % go through all images and add to corresponding container
    for lbl=1:num_imgs                   

        % shift the pixels to be centered on pixel as opposed to top left
        occluded = landmark_labels(:,1,lbl) == 0;
        labels = landmark_labels(:,:,lbl) - 0.5;
        labels(occluded,:) = 0;
        
        imgCol = imread(img_locations{lbl});

        if(size(imgCol,3) == 3)
            imgCol = rgb2gray(imgCol);
        end        
        
        % the reference shape
        [ ~, ~, ~,~, local_params] = fit_PDM_ortho_proj_to_2D( Msm, E, Vsm, labels);
        refShape = GetShapeOrtho(M, Vsm, local_params, refGlobal);
        
        % Create transform using a slightly modified version of Kabsch that
        % takes scaling into account as well, in essence we get a
        % similarity transform from current estimate to reference shape
        [A_img2ref, T_img2ref, ~, ~] = AlignShapesWithScale(labels(~occluded,:), refShape(~occluded,1:2));

        T_img2ref = T_img2ref + [imgSize(1)/2, imgSize(2)/2];
        
        % Create a transform, from shape in image to reference shape
        T = affine2d([A_img2ref';T_img2ref]);
                
        % transform the current shape to the reference one
        shape2D_in_ref = bsxfun(@plus, (A_img2ref * labels')', T_img2ref);        
        shape2D_in_ref(occluded,:) = 0;
        % warp the image
        [warped_img] = imwarp(imgCol, T, 'linear', 'OutputView', imref2d(imgSize));
                
        counter_colour(views(lbl)) = counter_colour(views(lbl)) + 1;

        allExamplesColourAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = warped_img;

        landmarkLocationsAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = shape2D_in_ref;
        actual_imgs_used_all_views{views(lbl)}{counter_colour(views(lbl))} = img_locations{lbl};
        if(mod(lbl, 100) == 0)
            fprintf('%d/%d done\n', lbl, num_imgs);
        end
    end
    
    % write out the training data for each view
    for r=1:size(centres_all,1)
        mirrorIdx = find(sum(abs(centres_all - repmat([centres_all(r,1), -centres_all(r,2), -centres_all(r,3)], size(centres_all,1),1)),2)==0);
        
        % if the mirrored view already added no need to do it again
        % so if (0,-20,0) is done no need to compute (0,20,0)
        if(mirrorIdx < r)
            continue
        end
        
        mirrorImgs = allExamplesColourAllViews{mirrorIdx}(1:counter_colour(mirrorIdx),:,:);
        mirrorLbls = landmarkLocationsAllViews{mirrorIdx}(1:counter_colour(mirrorIdx),:,:);
        
        for i=1:size(mirrorImgs,1)

            flippedImg = fliplr(squeeze(mirrorImgs(i,:,:)));

            flippedLbls = squeeze(mirrorLbls(i,:,:));
            flippedLbls(:,1) = imgSize(1) - flippedLbls(:,1) + 1;

            tmp1 = flippedLbls(mirror_inds(:,1),:);
            tmp2 = flippedLbls(mirror_inds(:,2),:);            
            flippedLbls(mirror_inds(:,2),:) = tmp1;
            flippedLbls(mirror_inds(:,1),:) = tmp2;   

            mirrorImgs(i,:,:) = flippedImg;
            mirrorLbls(i,:,:) = flippedLbls;

            % Ensure that after mirroring invalid (occluded) feature points
            % are set to 0 in both x and y dims
            mirrorLbls(i,flippedLbls(:,2)==0,1) = 0;

        end
        
        all_images = cat(1, allExamplesColourAllViews{r}(1:counter_colour(r),:,:), mirrorImgs);
        
        landmark_locations = cat(1, landmarkLocationsAllViews{r}(1:counter_colour(r),:,:), mirrorLbls);
        
        actual_imgs_used = actual_imgs_used_all_views{r};
        actual_imgs_used = cat(1, actual_imgs_used_all_views{r}, actual_imgs_used_all_views{mirrorIdx});
        
        centres = centres_all(r,:);

        % identify the visibility of a point
        num_visible = sum(landmark_locations(:,:,1)~=0);
        visible_max = max(num_visible);

        visiIndex = ones(1,68);
        visiIndex(num_visible < 0.5*visible_max) = 0;
        
        save([output_location '_' num2str(r) '.mat'], 'all_images', 'landmark_locations', 'training_scale', 'centres', 'actual_imgs_used', 'visiIndex', '-v7.3');

    end 
        
                
end

function [new_landmarks] = correctLandmarks(landmarks, name)
    if(strcmp(name, 'aflw__face_42138.jpg'))
        landmarks(23:27,:) = landmarks(27:-1:23,:);
    end

    if(strcmp(name, 'aflw__face_65193.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    if(strcmp(name, 'aflw__face_65158.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    if(strcmp(name, 'aflw__face_65153.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    if(strcmp(name, 'aflw__face_65119.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    if(strcmp(name, 'aflw__face_64862.jpg'))
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    if(strcmp(name, 'aflw__face_64849.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
    end

    if(strcmp(name, 'aflw__face_64833.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    if(strcmp(name, 'aflw__face_64806.jpg'))
        landmarks([18:22],:) = landmarks(22:-1:18,:);
    end
    if(strcmp(name, 'aflw__face_64744.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end
    if(strcmp(name, 'aflw__face_64292.jpg'))
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end
    if(strcmp(name, 'aflw__face_64170.jpg'))                
        landmarks([1:12],:) = landmarks(12:-1:1,:);
    end

    if(strcmp(name, 'aflw__face_64167.jpg'))
        landmarks([1:12],:) = landmarks(12:-1:1,:);
    end

    if(strcmp(name, 'aflw__face_63590.jpg'))
        landmarks([18:22],:) = landmarks(22:-1:18,:);
    end

    if(strcmp(name, 'aflw__face_63190.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end
    if(strcmp(name, 'aflw__face_63118.jpg'))                
        landmarks([1:12],:) = landmarks(12:-1:1,:);
    end

    if(strcmp(name, 'aflw__face_62990.jpg'))
        landmarks([18:22],:) = landmarks(22:-1:18,:);
    end

    if(strcmp(name, 'aflw__face_62534.jpg'))
        landmarks([18:22],:) = landmarks(22:-1:18,:);
    end

    if(strcmp(name, 'aflw__face_47686.jpg'))                
        landmarks([64,63,62,61,68,67,66,65],:) = landmarks(61:68,:);
    end
    if(strcmp(name, 'aflw__face_47687.jpg'))                
        landmarks([64,63,62,61,68,67,66,65],:) = landmarks(61:68,:);
    end        
    if(strcmp(name, 'aflw__face_45522.jpg'))
        outline = landmarks(1:17,:);
        outline(12:13,:) = [];
        outline = iterate_piece_wise(outline, 17);

        landmarks(1:17,:) = outline;
    end

    if(strcmp(name, 'aflw__face_43536.jpg'))
        landmarks(17:22,:) = landmarks(22:-1:17,:);
    end

    if(strcmp(name, 'aflw__face_42898.jpg'))
        landmarks(28:31,:) = landmarks(31:-1:28,:);
    end

    % Problem with the labels
    if(strcmp(name, 'aflw__face_41716.jpg'))
        landmarks(23:27,:) = landmarks(27:-1:23,:);
    end

    if(strcmp(name, 'aflw__face_41487.jpg'))
        landmarks(28:34,:) = landmarks(34:-1:28,:);
    end

    if(strcmp(name, 'aflw__face_41364.jpg'))
        landmarks(37:48,:) = landmarks([43:48, 37:42],:);
    end

    if(strcmp(name, 'aflw__face_63080.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    % Problem with the labels
    if(strcmp(name, 'aflw__face_63001.jpg'))
        landmarks(18:27,:) = landmarks([23:27, 18:22],:);
    end
    
    % Problem with the labels        
    if(strcmp(name, 'aflw__face_65249.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    % Problem with the labels
    if(strcmp(name, 'aflw__face_64866.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
    end

    % Problem with the labels
    if(strcmp(name, 'aflw__face_64771.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    if(strcmp(name, 'aflw__face_64735.jpg'))
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    % Problem with the labels
    if(strcmp(name, 'aflw__face_64238.jpg'))
        landmarks(18:22,:) = landmarks(22:-1:18,:);
    end

    if(strcmp(name, 'aflw__face_43770.jpg'))
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    % Problem with the labels
    if(strcmp(name, 'aflw__face_63080.jpg'))
        landmarks(1:12,:) = landmarks(12:-1:1,:);
        landmarks(13:16,:) = landmarks(16:-1:13,:);
    end

    % Problem with the labels
    if(strcmp(name, 'aflw__face_63001.jpg'))
        landmarks(18:27,:) = landmarks([23:27, 18:22],:);
    end
                
    new_landmarks = landmarks;
end

function [landmark_labels] = standardiseLandmarks(landmarks)

    left_to_frontal_map = [17,28; 18,29; 19,30; 20,31;
                       21,34; 22,32; 23,39; 24,38; 25,37; 26,42; 27,41;
                       28,52; 29,51; 30,50; 31,49; 32,60; 33,59; 34,58;
                       35,63; 36,62; 37,61; 38,68; 39,67];
                   
    right_to_frontal_map = [17,28; 18,29; 19,30; 20,31;
                       21,34; 22,36; 23,44; 24,45; 25,46; 26,47; 27,48;
                       28,52; 29,53; 30,54; 31,55; 32,56; 33,57; 34,58;
                       35,63; 36,64; 37,65; 38,66; 39,67];
                   
   landmark_labels = zeros(68,2); 
    
    if(size(landmarks,1) == 39)
        % Determine if the points are clock-wise or counter clock-wise
        % Clock-wise points are facing left, counter-clock-wise right
        sum = 0;
        for k=1:11
            step = (landmarks(k+1,1) - landmarks(k,1)) * (landmarks(k+1,2) + landmarks(k,2));
            sum = sum + step;
        end

        if(sum > 0)
            % First need to resample the face outline as there are 9
            % points in the near-frontal and 10 points in profile for
            % the outline of the face

            outline = iterate_piece_wise(landmarks(1:10,:), 9);
            brow = iterate_piece_wise(landmarks(13:16,:), 5);
            landmark_labels(1:9,:) = outline;
            landmark_labels(18:22,:) = brow;
            landmark_labels(left_to_frontal_map(:,2),:) = landmarks(left_to_frontal_map(:,1),:);
        else
            outline = iterate_piece_wise(landmarks(10:-1:1,:), 9);
            brow = iterate_piece_wise(landmarks(16:-1:13,:), 5);

            landmark_labels(9:17,:) = outline;
            landmark_labels(23:27,:) = brow;

            landmark_labels(right_to_frontal_map(:,2),:) = landmarks(right_to_frontal_map(:,1),:);                
        end
    else
       landmark_labels =  landmarks;
    end
end