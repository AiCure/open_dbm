% collect the training data annotations (from the menpo challenge)
clear
train_data_loc = 'D:\Datasets\menpo/';

dataset_locs = {[train_data_loc, '/train/'];};

% Mapping all the points (profile and semi-frontal) to the same 68 point
% annotation scheme
left_to_frontal_map = [17,28; 18,29; 19,30; 20,31;
                       21,34; 22,32; 23,39; 24,38; 25,37; 26,42; 27,41;
                       28,52; 29,51; 30,50; 31,49; 32,60; 33,59; 34,58;
                       35,63; 36,62; 37,61; 38,68; 39,67];
                   
right_to_frontal_map = [17,28; 18,29; 19,30; 20,31;
                       21,34; 22,36; 23,44; 24,45; 25,46; 26,47; 27,48;
                       28,52; 29,53; 30,54; 31,55; 32,56; 33,57; 34,58;
                       35,63; 36,64; 37,65; 38,66; 39,67];
            
all_pts = [];
mirr_pts = [];

add_flip = true;

mirror_inds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
              32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
              61,65;62,64;68,66];

for i=1:numel(dataset_locs)
    landmarkLabels = dir([dataset_locs{i} '\*.pts']);
    landmarkImgs = dir([dataset_locs{i} '\*.jpg']);

    for p=1:numel(landmarkLabels)
        landmarks = importdata([dataset_locs{i}, landmarkLabels(p).name], ' ', 3);
        img = imread([dataset_locs{i}, landmarkImgs(p).name]);
        landmarks = landmarks.data;
        landmark_labels = -ones(68,2); 
                        
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
        
        all_pts = cat(3, all_pts, landmark_labels);

        if(add_flip)
            
            mirror_lbls = landmark_labels;
            mirror_lbls(mirror_lbls ==-1) = nan;
            mirror_lbls(:,1) = -mirror_lbls(:,1);
            tmp1 = mirror_lbls(mirror_inds(:,1),:);
            tmp2 = mirror_lbls(mirror_inds(:,2),:);            
            mirror_lbls(mirror_inds(:,2),:) = tmp1;
            mirror_lbls(mirror_inds(:,1),:) = tmp2;    
            
            mirror_lbls(isnan(mirror_lbls)) = -1;
            
            mirr_pts = cat(3, mirr_pts, mirror_lbls);
        end
    
    end
end
all_pts_old = all_pts;
%%
xs = squeeze(all_pts(:,1,:));
ys = squeeze(all_pts(:,2,:));

all_pts = cat(2,xs,ys)';
save('menpo_68_pts', 'all_pts');

%%
all_pts = all_pts_old ;
all_pts = cat(3, all_pts, mirr_pts);

xs = squeeze(all_pts(:,1,:));
ys = squeeze(all_pts(:,2,:));

all_pts = cat(2,xs,ys)';

save('menpo_68_pts_flip', 'all_pts');
