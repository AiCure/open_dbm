function [ labels, vid_inds, frame_inds ] = extract_au_labels( input_folders, au_id)
%EXTRACT_AU_LABELS Summary of this function goes here
%   Detailed explanation goes here

    labels = [];    
    vid_inds = [];
    frame_inds = [];
    for i=1:numel(input_folders)
        
        in_file = sprintf('%s_au%d.txt', input_folders{i}, au_id);
        
        A = dlmread(in_file, ',');
                
        vid_inds_curr = cell(numel(A(:,2)), 1);
        
        labels = cat(1, labels, A(:,2));
        
        [~,curr_name,~] = fileparts(input_folders{i});
        
        frame_inds_curr = 0:numel(A(:,2))-1;
        frame_inds = cat(1, frame_inds, frame_inds_curr');
        
        vid_inds_curr(:) = {curr_name};
        vid_inds = cat(1, vid_inds, vid_inds_curr);
        
    end

end

