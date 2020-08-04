% Convert the training images into a suitable format
function Prepare_data_wild_all()

    % replace with folder where you downloaded and extracted the 300-W challenge data
    data_root = 'C:\Users\tbaltrus\Dropbox\AAM/test data/';
    
    PrepareTrainingWild(data_root, 0.25);
    PrepareTrainingWild(data_root, 0.35);
    PrepareTrainingWild(data_root, 0.5);
    PrepareTrainingWild(data_root, 1.0);
end

function PrepareTrainingWild( data_root, training_scale )
%PREPARETRAININGIMAGEMPIE Summary of this function goes here
%   Detailed explanation goes here

    % img size

    imgSize = [400, 400] * training_scale;
    
    %%
    addpath('PDM_helpers/');
    load 'PDM_helpers/pdm_68_aligned_wild.mat';

    output_location = '../prepared_data/wild_';
    output_location = [output_location num2str(training_scale,3)];

    num_landmarks = 68;
    
    % Use mirror images to provide extra training data
    mirror_inds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
                  32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
                  61,65;62,64;68,66];

    % The centres of views we want to extract
    centres_all = [    0,   0,  0
                      0, -20,  0
                      0,  20,  0
                      ];
    
    num_centers = size(centres_all, 1);
            
    counter_colour = zeros(num_centers,1);

    % use only 2 of the subsets (others used for testing)
    % You just need to provide the location in your system
    dataset_locs = { [data_root, '/helen/trainset/'];
                     [data_root, '/lfpw/trainset/']};
    
    landmark_labels = [];
    img_locations = {};
    
    % read in all of the labels, together with names of images used
    for i=1:numel(dataset_locs)
        curr_labels = dir([dataset_locs{i} '\*.pts']);
        imgs = dir([dataset_locs{i} '\*.jpg']);
        if(isempty(imgs))
            imgs = dir([dataset_locs{i} '\*.png']);
        end
        
        for p=1:numel(curr_labels)
            landmarks = dlmread([dataset_locs{i}, curr_labels(p).name], ' ', [3,0,68+2,1]);
            landmark_labels = cat(3, landmark_labels, landmarks);
            img_locations = cat(1, img_locations, [dataset_locs{i} imgs(p).name]);
        end
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
        labels = landmark_labels(:,:,lbl) - 0.5;
        
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
        [A_img2ref, T_img2ref, ~, ~] = AlignShapesWithScale(labels, refShape(:,1:2));

        T_img2ref = T_img2ref + [imgSize(1)/2, imgSize(2)/2];
        
        % Create a transform, from shape in image to reference shape
        T = affine2d([A_img2ref';T_img2ref]);
                
        % transform the current shape to the reference one
        shape2D_in_ref = bsxfun(@plus, (A_img2ref * labels')', T_img2ref);        
        
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
            
        end
        
        all_images = cat(1, allExamplesColourAllViews{r}(1:counter_colour(r),:,:), mirrorImgs);
        
        landmark_locations = cat(1, landmarkLocationsAllViews{r}(1:counter_colour(r),:,:), mirrorLbls);
        
        actual_imgs_used = actual_imgs_used_all_views{r};
        actual_imgs_used = cat(1, actual_imgs_used_all_views{r}, actual_imgs_used_all_views{mirrorIdx});
        
        centres = centres_all(r,:);

        visiIndex = ones(1,68);
        save([output_location '_' num2str(r) '.mat'], 'all_images', 'landmark_locations', 'training_scale', 'centres', 'actual_imgs_used', 'visiIndex', '-v7.3');

    end 
        
                
end