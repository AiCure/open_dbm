function Prepare_data_Multi_PIE_all()

    % This bit collects all of the multi-pie labels into a single structure for
    % easy access
    labels_root = 'C:\Users\tbaltrus\Dropbox\AAM\test data\MultiPI_AAM/';
    
    % The location of the Multi-PIE data folder
    multi_pie_root = 'D:\MultiPIE/Image_Data/';
    
    multi_pie_labels = CollectMultiPieLabels(labels_root, multi_pie_root);

    %% 
    
    % Make sure same images are used across scales
    rng(0);    
    ExtractTrainingMultiPIE(0.25, multi_pie_labels);
    
    rng(0);    
    ExtractTrainingMultiPIE(0.35, multi_pie_labels);
    
    rng(0);    
    ExtractTrainingMultiPIE(0.5, multi_pie_labels);
        
    rng(0);    
    ExtractTrainingMultiPIE(1.0, multi_pie_labels);    
    
end
% Now extract the relevant information

function [multi_pie_labels] = CollectMultiPieLabels(labels_root, multi_pie_root)

    multi_pie_labels = struct;
    currentLabel = 0;
    left_to_frontal_map = [1, 28;
                        2, 29;
                        3, 30;
                        4, 31;
                        5, 34;
                        6, 36;
                        7, 27;
                        8, 26;
                        9, 25;
                        10,24;
                        11,46;
                        12,45;
                        13,44;
                        14,48;
                        15,47;
                        16,52;
                        17,53;
                        18,54;
                        19,55;
                        20,56;
                        21,57;
                        22,58;
                        23,63;
                        24,64;
                        26,66;
                        27,67;
                        30,9;
                        31,10;
                        32,11;
                        33,12;
                        34,13;
                        35,14;
                        36,15;
                        37,16;
                        38,17;];

    right_to_frontal_map = [1, 28;
                            2, 29;
                            3, 30;
                            4, 31;
                            5, 34;
                            6, 32;
                            7 ,18;
                            8 ,19;
                            9 ,20;
                            10,21;
                            11,37;
                            12,38;
                            13,39;
                            14,41;
                            15,42;
                            16,52;
                            17,51;
                            18,50;
                            19,49;
                            20,60;
                            21,59;
                            22,58;
                            23,63;
                            24,62;
                            26,68;
                            27,67;
                            30, 9;
                            31, 8;
                            32, 7;
                            33, 6;
                            34, 5;
                            35, 4;
                            36, 3;
                            37, 2;
                            38, 1];

    for i=1:4

        labelsDir = sprintf('%sSession%d/', labels_root, i);

        labels = dir([labelsDir '/*.mat']);

        double_label = false;

        for j = 1:numel(labels)
            if(double_label)
                double_label = false;
                continue;
            end

            load([labelsDir labels(j).name]);

            if(size(pts,1) ~= 68 && size(pts,1) ~= 39)
                continue;
            end

            userID = labels(j).name(1:3);        
            recID = labels(j).name(8:9);        
            camID = labels(j).name(11:12);        
            camID2 = labels(j).name(13);
            viewID = labels(j).name(15:16);

            % doubling labels seem to be odd/incorrect
            if(j < numel(labels))

                userIDN = labels(j+1).name(1:3);            
                recIDN = labels(j+1).name(8:9);            
                camIDN = labels(j+1).name(11:12);            
                camID2N = labels(j+1).name(13);

                if(strcmp(userIDN, userID) && strcmp(recID, recIDN) && strcmp(camIDN, camID) && strcmp(camID2N, camID2))
                    double_label = true;
                    continue;
                end

            end

            % camera id 08 is from a very different perspective
            if(strcmp(camID, '08') && strcmp(camID2, '1'))
                continue;
            end

            currentLabel = currentLabel + 1;

            multi_pie_labels(currentLabel).label_file = [labelsDir labels(j).name];
            multi_pie_labels(currentLabel).user_ID = userID;
            multi_pie_labels(currentLabel).rec_ID = recID;
            multi_pie_labels(currentLabel).cam_ID = camID;
            multi_pie_labels(currentLabel).cam_ID2 = camID2;

            multiPieImageDir = sprintf('%s/session0%d/multiview/%s/%s/%s_%s/', multi_pie_root, i,userID,recID,camID,camID2);
            multiPieImgs = dir([multiPieImageDir '*.png']);

            multi_pie_labels(currentLabel).img_dir = multiPieImageDir;
    %         multi_pie_labels(currentLabel).img_loc = [labels(j+1).name(1:end-7), '.png'];        
            actualLabel = dir([multiPieImageDir '/*' viewID '.png']);
            multi_pie_labels(currentLabel).img_locs = {multiPieImgs.name};
            multi_pie_labels(currentLabel).actual_img = actualLabel.name;
            landmark_labels = zeros(68,2);        

            % This is a profile image
            if(size(pts,1) == 39)
                % Determine if left or right

                if(pts(4,1) < pts(39,1))
                    multi_pie_labels(currentLabel).type = 'profile_left';
                    landmark_labels(left_to_frontal_map(:,2),:) = pts(left_to_frontal_map(:,1),:);
                else
                    multi_pie_labels(currentLabel).type = 'profile_right';
                    landmark_labels(right_to_frontal_map(:,2),:) = pts(right_to_frontal_map(:,1),:);
                end
            else
                landmark_labels = pts;
            end

            multi_pie_labels(currentLabel).landmark_labels = landmark_labels;

        end
    end
end

function ExtractTrainingMultiPIE( training_scale, multi_pie_labels)
%PREPARETRAININGIMAGEMPIE This function collects a subset of Multi-PIE
%images at different expressions and lighting conditions to store it in a
%format suitable for training patch experts

%   Detailed explanation goes here


    img_size = [400, 400] * training_scale;
    
    %%
    addpath('PDM_helpers/');
    load 'PDM_helpers/pdm_68_aligned_wild.mat';

    output_location = '../prepared_data/mpie_';
    output_location = [output_location num2str(training_scale,3)];

    num_landmarks = 68;
    
    % Use mirror images to provide extra training data
    mirror_inds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
                  32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
                  61,65;62,64;68,66];

    % The centres of views we want to extract
    centres_all = [   0,   0,  0
                      0, -20,  0
                      0, -45,  0
                      0, -70,  0                      
                      0,  20,  0
                      0,  45,  0
                      0,  70,  0                                            
                      ];
    
    num_centers = size(centres_all, 1);
            
    counter_colour = zeros(num_centers,1);

    % read in all of the labels, together with names of images used
    
    landmark_labels = zeros(68,2,numel(multi_pie_labels));
    img_locations = cell(numel(multi_pie_labels),1);
    extra_locations = cell(numel(multi_pie_labels),1);
    img_dirs = cell(numel(multi_pie_labels),1);
    
    for i=1:numel(multi_pie_labels)
               
        img_locations{i} = [multi_pie_labels(i).img_dir, multi_pie_labels(i).actual_img];
        extra_locations{i} =  multi_pie_labels(i).img_locs;        
        img_dirs{i} =  multi_pie_labels(i).img_dir;
        
        landmark_labels(:,:,i) = multi_pie_labels(i).landmark_labels;
        
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
        [ a,R ] = fit_PDM_ortho_proj_to_2D( Msm, E, Vsm, labels);
        
        eul = Rot2Euler(R);        
        eul_orig = eul * 180 / pi;
        
        if(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '24_0'))
            eul = [0, -90, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '01_0'))
            eul = [0, -75, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '20_0'))
            eul = [0, -60, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '19_0'))
            eul = [0, -45, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '04_1'))
            eul = [0, -30, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '05_0'))
            eul = [0, -15, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '05_1'))
            eul = [0, 0, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '14_0'))
            eul = [0, 15, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '13_0'))
            eul = [0, 30, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '08_0'))            
            eul = [0, 45, 0];            
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '09_0'))
            eul = [0, 60, 0];
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '12_0'))
            eul = [0, 75, 0];            
        elseif(strcmp([multi_pie_labels(lbl).cam_ID,'_', multi_pie_labels(lbl).cam_ID2], '11_0'))
            eul = [0, 90, 0];
        end
        
        % find the closest view (also mirror img?)
        [~, view] = min(sum(abs(centres_all - repmat(eul, num_centers, 1)),2));
        counter_colour(view) = counter_colour(view) + 1;
        scales(lbl) = a;
        views(lbl) = view;
    end
    
    % preallocate data
    allExamplesColourAllViews = cell(size(centres_all,1),1);    
    landmarkLocationsAllViews = cell(size(centres_all,1),1); 
    
    % if we don't have enough labelled original images add ones from diff
    % lighting conditions (that might not be perfectly labelled, but they
    % are better than fewer images)
    images_aim = 8000;
    extra_factors = ones(size(counter_colour));
    
    for r=1:size(centres_all,1)

         % see if extra is needed        
        mirrorIdx = find(sum(abs(centres_all - repmat([centres_all(r,1), -centres_all(r,2), -centres_all(r,3)], size(centres_all,1),1)),2)==0);        
        count = counter_colour(r) + counter_colour(mirrorIdx);
                        
        if(count < images_aim)
            extra_factors(r) = images_aim / count;
        end
        
    end
    
    for r=1:size(centres_all,1)
        counter_colour(r) = round(counter_colour(r) * extra_factors(r));
            
        allExamplesColourAllViews{r} = uint8(zeros(counter_colour(r), img_size(1), img_size(2)));
        landmarkLocationsAllViews{r} = zeros(counter_colour(r), num_landmarks, 2);

        actual_imgs_used_all_views{r} = cell(counter_colour(r), 1);                                    

    end
    
    counter_colour = zeros(num_centers,1);
    
    % The shape fitting is performed in the reference frame of the
    % patch training scale
    refGlobal = [training_scale, 0, 0, 0, 0, 0]';
    
    % go through all images and add to corresponding container
    for lbl=1:num_imgs                   

        labels = landmark_labels(:,:,lbl);
        occluded = labels(:,1) == 0;
        
        % Convert the labels to matlab format (we expect 1,1 to represent
        % the center of the top left pixel)
        labels = labels + 1;
        
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

        T_img2ref = T_img2ref + [img_size(1)/2, img_size(2)/2];
        
        % Create a transform, from shape in image to reference shape
        T = affine2d([A_img2ref';T_img2ref]);
                
        % transform the current shape to the reference one
        shape2D_in_ref = bsxfun(@plus, (A_img2ref * labels')', T_img2ref);        
        
        % warp the image
        resizeColImage = imwarp(imgCol, T, 'linear', 'OutputView', imref2d(img_size));             
        
        shape2D_in_ref(occluded,1) = 0;
        shape2D_in_ref(occluded,2) = 0;
        
        counter_colour(views(lbl)) = counter_colour(views(lbl)) + 1;

        allExamplesColourAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = resizeColImage;

        landmarkLocationsAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = shape2D_in_ref;
        actual_imgs_used_all_views{views(lbl)}{counter_colour(views(lbl))} = img_locations{lbl};
        
        % Here to add extra images if missing and not filled yet
        if(extra_factors(views(lbl)) > 1 && counter_colour(views(lbl)) < numel(actual_imgs_used_all_views{views(lbl)}))
           
            factor = extra_factors(views(lbl));
            
            % pick if to use this image or not
            if(randi(100) > (factor - floor(factor)) * 100)
                factor = floor(factor);
            else
                factor = ceil(factor);
            end
            
            while(factor > 1)
                
                lighting_id =  randi(20);
                [~, img_orig, ext] = fileparts(img_locations{lbl});
                img_orig = [img_orig, ext];
                if( strcmp(img_orig, extra_locations{lbl}{lighting_id}))
                    lighting_id = lighting_id + 1;
                    if(lighting_id > 20)
                        lighting_id = 1;
                    end
                end
                img_loc = [img_dirs{lbl}, extra_locations{lbl}{lighting_id}];
                imgCol = imread(img_loc);

                if(size(imgCol,3) == 3)
                    imgCol = rgb2gray(imgCol);
                end

                % resize the image to desired scale
                resizeColImage = imwarp(imgCol, T, 'linear', 'OutputView', imref2d(img_size));   

                counter_colour(views(lbl)) = counter_colour(views(lbl)) + 1;

                allExamplesColourAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = resizeColImage;

                landmarkLocationsAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = shape2D_in_ref;
                actual_imgs_used_all_views{views(lbl)}{counter_colour(views(lbl))} = img_loc;
                factor = factor - 1;
            end
            
        end
        % Make sure same one not added as well
        
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
        
        % Cap to two thousand images for space reasons, and because more
        % wouldn't actually be used        
        max_images = 2000;
        
        mirrorImgs = allExamplesColourAllViews{mirrorIdx}(1:counter_colour(mirrorIdx),:,:);
        mirrorLbls = landmarkLocationsAllViews{mirrorIdx}(1:counter_colour(mirrorIdx),:,:);

        for i=1:size(mirrorImgs,1)

            flippedImg = fliplr(squeeze(mirrorImgs(i,:,:)));

            flippedLbls = squeeze(mirrorLbls(i,:,:));
            flippedLbls(:,1) = img_size(1) - flippedLbls(:,1) + 1;

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
        actual_imgs_used = cat(1, actual_imgs_used_all_views{r}(1:counter_colour(r)), actual_imgs_used_all_views{mirrorIdx}(1:counter_colour(mirrorIdx)));  
          
        centres = centres_all(r,:);

        % identify the visibility of a point
        num_visible = sum(landmark_locations(:,:,1)~=0);
        visible_max = max(num_visible);

        visiIndex = ones(1,68);
        visiIndex(num_visible < 0.5*visible_max) = 0;
                
        if(size(all_images,1) > max_images)
            im_to_select = randperm(size(all_images,1));
            im_to_select = im_to_select(1:max_images);
            all_images = all_images(im_to_select,:,:);
            landmark_locations = landmark_locations(im_to_select,:,:);
            actual_imgs_used = actual_imgs_used(im_to_select);
        end
        save([output_location '_' num2str(r) '.mat'], 'all_images', 'landmark_locations', 'training_scale', 'centres', 'actual_imgs_used', 'visiIndex', '-v7.3');

    end 
        
                
end

