function [ vid_locs, bboxes, gts_all, invalid_frames ] = CollectTrainData( db_root, bb_root, extra_dir )
%COLLECTTESTDATA Summary of this function goes here
%   Detailed explanation goes here

%     all_train = [1,2,3,4,7,9,10,11,13,15,16,17,18,19,20,22,25,27,28,29,31,33,34,35,37,39,41,43,44,46,47,48,49,53,57,59,112,113,115,119,120,123,138,143,144,160,204,205,223,225];
    all_train = [1,2,3,4,7,9,10,11,13,15,16,17,18,19,20,22,25,27,29,31,33,34,35,37,39,41,43,44,46,47,48,49,53,57,59,112,113,115,119,120,123,138,143,144,160,204,205,223,225];

    vid_locs = cell(numel(all_train),1);
    bboxes = cell(numel(all_train),1);
    gts_all = cell(numel(all_train),1);
    invalid_frames = cell(numel(all_train),1);
    for i=1:numel(all_train)
        id = sprintf('%03d', all_train(i));
        
        vid_locs{i} = [db_root '/', id, '/vid.avi'];         
        bboxes{i} = dlmread([bb_root,  id, '_dets.txt'], ',');
        
        %% Grab the ground truth
        fps_all = dir([db_root, '/', id, '/annot/*.pts']);
        gt_landmarks = zeros([68, 2, size(fps_all)]);
        for k = 1:size(fps_all)
            gt_landmarks_frame = dlmread([db_root, '/', id, '/annot/', fps_all(k).name], ' ', 'A4..B71');
            gt_landmarks(:,:,k) = gt_landmarks_frame;
        end
        % Remove unreliable frames
        if(exist([extra_dir, '/', num2str(all_train(i)), '.mat'], 'file'))
            inv_frames = load([extra_dir, '/', num2str(all_train(i)), '.mat']);
            
            gt_landmarks(:,:,int32(inv_frames.error)) = [];
            invalid_frames{i} = inv_frames.error;
        end          
        gts_all{i} = gt_landmarks;
    end
 
end

