function [ labels, valid_ids, filenames  ] = extract_FERA2011_labels( FERA2011_dir, recs, aus )
%EXTRACT_SEMAINE_LABELS Summary of this function goes here
%   Detailed explanation goes here
    
    num_files = numel(recs);

    % speech invalidates lower face AUs    
    labels = cell(num_files, 1);
    valid_ids = cell(num_files, 1);
    filenames = cell(num_files, 1);
    
    file_id = 1;
    
    for i=1:numel(recs)

        file = [FERA2011_dir, '/', recs{i}, '/', recs{i}, '-au.dat'];
    
        [~, filename,~] = fileparts(file);
        filenames{file_id} = filename;

        data = dlmread(file); %import annotations for one video file
       
        speech = data(:,end);

        labels{file_id} = data(:, aus);

        % Finding the invalid regions
        if(aus(1) >= 10)
            valid = speech == 0;
        else
            valid = true(size(speech,1), 1);
        end
        
        % all indices in SEMAINE are valid
        valid_ids{file_id} = valid;

        file_id = file_id + 1;
    end
    
    labels = labels(1:file_id-1);
    valid_ids = valid_ids(1:file_id-1);
    filenames = filenames(1:file_id-1);
    
end

