function [ vid_locs, bboxes, gts_all, invalid_frames ] = CollectTestData( db_root, bb_root, extra_dir )
%COLLECTTESTDATA Summary of this function goes here
%   Detailed explanation goes here

    cat_1 = [ 114, 124, 125, 126, 150, 158, 401, 402, 505, 506, 507, 508, 509, 510, 511, 514, 515, 518, 519, 520, 521, 522, 524, 525, 537, 538, 540, 541, 546, 547, 548];
    cat_2 = [203, 208, 211, 212, 213, 214, 218, 224, 403, 404, 405, 406, 407, 408, 409, 412, 550, 551, 553];
    cat_3 = [410, 411, 516, 517, 526, 528, 529, 530, 531, 533, 557, 558, 559, 562];

    all_test = cat(2, cat_1, cat_2, cat_3);

    vid_locs = cell(numel(all_test),1);
    bboxes = cell(numel(all_test),1);
    gts_all = cell(numel(all_test),1);
    invalid_frames = cell(numel(all_test),1);
    for i=1:numel(all_test)
        vid_locs{i} = [db_root '/', num2str(all_test(i)), '/vid.avi'];         
        bboxes{i} = dlmread([bb_root,  num2str(all_test(i)), '_dets.txt'], ',');
        
        %% Grab the ground truth
        fps_all = dir([db_root, '/', num2str(all_test(i)), '/annot/*.pts']);
        gt_landmarks = zeros([68, 2, size(fps_all)]);
        for k = 1:size(fps_all)
            gt_landmarks_frame = dlmread([db_root, '/', num2str(all_test(i)), '/annot/', fps_all(k).name], ' ', 'A4..B71');
            gt_landmarks(:,:,k) = gt_landmarks_frame;
        end
        % Remove unreliable frames
        if(exist([extra_dir, '/', num2str(all_test(i)), '.mat'], 'file'))
            inv_frames = load([extra_dir, '/', num2str(all_test(i)), '.mat']);
            
            gt_landmarks(:,:,int32(inv_frames.error)) = [];
            invalid_frames{i} = inv_frames.error;
        end          
        gts_all{i} = gt_landmarks;
    end
 
end

