function [ labels ] = extract_au_labels( input_folders, au_id)
%EXTRACT_AU_LABELS Summary of this function goes here
%   Detailed explanation goes here

    labels = [];
    for i=1:numel(input_folders)
        
        in_file = sprintf('%s_au%d.txt', input_folders{i}, au_id);
        
        A = dlmread(in_file, ',');
                
        labels = cat(1, labels, A(:,2));
    end

end

