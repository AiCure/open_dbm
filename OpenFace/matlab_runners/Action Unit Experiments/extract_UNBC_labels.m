function [ labels, valid_ids, filenames  ] = extract_UNBC_labels( UNBC_dir, recs, aus )
%EXTRACT_SEMAINE_LABELS Summary of this function goes here
%   Detailed explanation goes here
    
    UNBC_dir = [UNBC_dir, '/Frame_Labels/FACS/'];

    aus_UNBC = [4, 6, 7, 9, 10, 12, 20, 25, 26, 43];
    
    inds_to_use = [];
    
    for i=1:numel(aus)
    
        inds_to_use = cat(1, inds_to_use, find(aus_UNBC == aus(i)));
        
    end
    aus_UNBC = aus_UNBC(inds_to_use);
    labels_all = {};
    valid_ids_all = {};
    filenames_all = {};
    
    for i=1:numel(recs)

        % get all the dirs, etc.
        
        sessions = dir([UNBC_dir, recs{i}]);
        sessions = sessions(3:end);
        
        num_sessions = numel(sessions);
        
        labels = cell(num_sessions, 1);
        valid_ids = cell(num_sessions, 1);
        filenames = cell(num_sessions, 1);

        for s=1:numel(sessions)

            frames = dir([UNBC_dir, '/', recs{i}, '/', sessions(s).name, '/*.txt']);

            labels_c = zeros(numel(frames), numel(aus));
            
            for f=1:numel(frames)

                file = [UNBC_dir, '/', recs{i}, '/', sessions(s).name, '/', frames(f).name];

                fileID = fopen(file);                
                C = textscan(fileID,'%d %d %d %d\n');
                fclose(fileID); 
                
%                 OCC = csvread(file); %import annotations for one video file
                for au = 1:numel(C{1})                    
                    labels_c(f, aus_UNBC == C{1}(au)) = C{2}(au);
                end
                
            end 
            labels{s} = labels_c;
            filenames(s) = {sessions(s).name};
            valid_ids{s} = true(size(labels_c,1),1);
        end
        
        
        labels_all = cat(1, labels_all, labels);
        valid_ids_all = cat(1, valid_ids_all, valid_ids);
        filenames_all = cat(1, filenames_all, filenames);

    end
    
    labels = labels_all;
    valid_ids = valid_ids_all;
    filenames = filenames_all;
end

