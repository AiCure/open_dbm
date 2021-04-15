% Convert the training images into a suitable format
function Prepare_data_COFW()

    % replace with folder where you downloaded and extracted the 300-W challenge data
    data_root = '../../../../CLM-framework/matlab_version/occlusion_experiments/data/';
    
    PrepareTrainingWild(data_root, 0.25);
    PrepareTrainingWild(data_root, 0.35);
    PrepareTrainingWild(data_root, 0.5);
end

function PrepareTrainingWild( data_root, training_scale )
%PREPARETRAININGIMAGEMPIE Summary of this function goes here
%   Detailed explanation goes here

    % img size

    imgSize = [400, 400] * training_scale;
    
    %%
    addpath('PDM_helpers/');
    load 'PDM_helpers/pdm_29_cofw_aligned.mat';

    output_location = '../prepared_data/cofw_';
    output_location = [output_location num2str(training_scale,3)];

    num_landmarks = 29;
    
    % Use mirror images to provide extra training data
    mirror_inds = [1,2; 3,4; 5,7; 6,8; 9,10; 11,12; 13,15; 14,16; 17,18; 19,20; 23,24];

    % The centres of views we want to extract
    centres_all = [ 0, 0, 0 ];
    
    num_centers = size(centres_all, 1);
            
    counter_colour = zeros(num_centers,1);

    load([data_root, '/COFW_train.mat']);
                 
    % go through all images, see which centres they match and then add to
    % the appropriate bin
    num_imgs = numel(IsTr);
    scales = zeros(num_imgs, 1);
    views = zeros(num_imgs, 1);
    for lbl=1:num_imgs
       
        Msm = M;
        Vsm = V;
        labels = reshape(phisTr(lbl,1:num_landmarks*2), num_landmarks, 2);
        
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
    occlusionsAllViews = cell(size(centres_all,1),1); 
    
    for r=1:size(centres_all,1)

        allExamplesColourAllViews{r} = zeros(counter_colour(r), imgSize(1), imgSize(2));
        landmarkLocationsAllViews{r} = zeros(counter_colour(r), num_landmarks, 2);
        occlusionsAllViews{r} = zeros(counter_colour(r), num_landmarks);
        actual_imgs_used_all_views{r} = cell(counter_colour(r), 1);
    end
    
    counter_colour = zeros(num_centers,1);
    
    % go through all images and add to corresponding container
    for lbl=1:num_imgs                   

        labels = reshape(phisTr(lbl,1:num_landmarks*2), num_landmarks, 2);
        occlusions = phisTr(lbl,(num_landmarks*2+1):end);
        
        imgCol = IsTr{lbl};

        if(size(imgCol,3) == 3)
            imgCol = rgb2gray(imgCol);
        end
        
        % resize the image to desired scale
        scalingFactor = training_scale / scales(lbl);

        resizeColImage = imresize(imgCol, scalingFactor, 'bilinear');

        labels = labels * scalingFactor;

        % we want to crop out the image now
        meanX = round(mean(labels(:,1)));
        meanY = round(mean(labels(:,2)));
        startX = round(meanX-imgSize(1)/2);            
        startY = round(meanY-imgSize(2)/2);            

        if(startX < 1)
            startX = 1;
        end
        if(startY < 1) 
            startY = 1;
        end

        endX = startX + imgSize(1) - 1;
        endY = startY + imgSize(2) - 1;

        if(endX > size(resizeColImage,2))
            resizeColImage = cat(2, resizeColImage, zeros(size(resizeColImage,1), endX - size(resizeColImage,2)));
        end

        if(endY > size(resizeColImage,1))
            resizeColImage = cat(1, resizeColImage, zeros(endY - size(resizeColImage,1), size(resizeColImage,2)));
        end
        resizeColImage = resizeColImage(startY:endY,startX:endX);        

        labels(:,1) = labels(:,1) - startX + 1;
        labels(:,2) = labels(:,2) - startY + 1;
        
        counter_colour(views(lbl)) = counter_colour(views(lbl)) + 1;

        allExamplesColourAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = resizeColImage;

        landmarkLocationsAllViews{views(lbl)}(counter_colour(views(lbl)),:,:) = labels;
        occlusionsAllViews{views(lbl)}(counter_colour(views(lbl)),:) = occlusions;
        actual_imgs_used_all_views{views(lbl)}{counter_colour(views(lbl))} = 'placeholder';
        
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
        mirrorOccls = occlusionsAllViews{mirrorIdx}(1:counter_colour(mirrorIdx),:);
        
        for i=1:size(mirrorImgs,1)
           
            flippedImg = fliplr(squeeze(mirrorImgs(i,:,:)));
                    
            flippedLbls = squeeze(mirrorLbls(i,:,:));
            flippedLbls(:,1) = imgSize(1) - flippedLbls(:,1);
            
            tmp1 = flippedLbls(mirror_inds(:,1),:);
            tmp2 = flippedLbls(mirror_inds(:,2),:);            
            flippedLbls(mirror_inds(:,2),:) = tmp1;
            flippedLbls(mirror_inds(:,1),:) = tmp2;   
        
            mirrorImgs(i,:,:) = flippedImg;
            mirrorLbls(i,:,:) = flippedLbls;
            
            tmp1 = mirrorOccls(i,mirror_inds(:,1));
            tmp2 = mirrorOccls(i,mirror_inds(:,2));
            
            mirrorOccls(i,mirror_inds(:,1)) = tmp2;
            mirrorOccls(i,mirror_inds(:,2)) = tmp1;
        end
        
        all_images = cat(1, allExamplesColourAllViews{r}(1:counter_colour(r),:,:), mirrorImgs);
        
        all_images = uint8(all_images);
        
        landmark_locations = cat(1, landmarkLocationsAllViews{r}(1:counter_colour(r),:,:), mirrorLbls);
        
        occlusions = cat(1, occlusionsAllViews{r}(1:counter_colour(r),:), mirrorOccls);
        
        actual_imgs_used = actual_imgs_used_all_views{r};
        actual_imgs_used = cat(1, actual_imgs_used_all_views{r}, actual_imgs_used_all_views{mirrorIdx});
        
        centres = centres_all(r,:);

        visiIndex = ones(1,num_landmarks);
        save([output_location '_' num2str(r) '.mat'], 'all_images', 'occlusions', 'landmark_locations', 'training_scale', 'actual_imgs_used', 'centres', 'visiIndex', '-v7.3');

    end 
        
                
end