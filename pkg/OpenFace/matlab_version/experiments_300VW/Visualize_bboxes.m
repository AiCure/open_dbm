clear; 
addpath(genpath('../'));

%% select database and load bb initializations
db_root = 'D:\Datasets\300VW_Dataset_2015_12_14\300VW_Dataset_2015_12_14/';
bb_root = 'C:\Users\tbaltrus\Documents\MTCNN_face_detection\code\codes\MTCNNv2/300VW_dets/';
extra_dir = 'D:\Datasets\300VW_Dataset_2015_12_14\extra';
[ vid_locs, bboxes_mtcnn, gts_all, invalid_frames ] = CollectTestData(db_root, bb_root, extra_dir);
bb_root = '../..//matlab_runners/Feature Point Experiments/300VW_face_dets/';
[ vid_locs, bboxes_hog, gts_all, invalid_frames ] = CollectTestData(db_root, bb_root, extra_dir);

%% Select video
for i=1:numel(vid_locs)

    vid = VideoReader(vid_locs{i});

    bounding_boxes_hog = bboxes_hog{i};
    bounding_boxes_mtcnn = bboxes_mtcnn{i};

    n_frames = size(bounding_boxes_hog,1);
    for f=1:n_frames
        input_image = readFrame(vid);
                        
        %% plot the result
        imshow(input_image);
        hold on;
        bbox_hog = bounding_boxes_hog(f,:);
        bbox_mtcnn = bounding_boxes_mtcnn(f,:);
        
        rectangle('Position', bbox_hog, 'EdgeColor', 'r');
        rectangle('Position', bbox_mtcnn, 'EdgeColor', 'g');
        hold off;
        drawnow expose
        
    end
    
end