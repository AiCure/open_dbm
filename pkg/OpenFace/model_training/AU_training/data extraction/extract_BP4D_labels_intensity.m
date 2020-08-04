function [ labels, valid_ids, vid_ids, filenames  ] = extract_BP4D_labels_intensity( BP4D_dir, recs, aus )
%EXTRACT_SEMAINE_LABELS Summary of this function goes here
%   Detailed explanation goes here
    
    files_all = dir(sprintf('%s/AU%02d/%s', BP4D_dir, aus(1), '/*.csv'));
    num_files = numel(files_all);
            
    labels = cell(num_files, 1);
    valid_ids = cell(num_files, 1);
    vid_ids = zeros(num_files, 2);
    filenames = cell(num_files, 1);
    
    file_id = 1;
    
    for r=1:numel(recs)
        
        files_root = sprintf('%s/AU%02d/', BP4D_dir, aus(1));
        files_all = dir([files_root, recs{r}, '*.csv']);

        for f=1:numel(files_all)
            for au=aus
                
                % Need to find relevant files for the relevant user and for the
                % relevant AU
                files_root = sprintf('%s/AU%02d/', BP4D_dir, au);
                files_all = dir([files_root, recs{r}, '*.csv']);
        
                file = [files_root, '/', files_all(f).name];

                [~, filename,~] = fileparts(file);
                filenames{file_id} = filename(1:7);

                intensities = csvread(file); % import annotations for one session

                frame_nums = intensities(:,1); % get all frame numbers

                codes = intensities(:,2);

                % Finding the invalid regions
                valid = codes ~= 9;

                vid_ids(file_id,:) = [frame_nums(1), frame_nums(end)];

                if(au == aus(1))
                    valid_ids{file_id} = valid;
                    labels{file_id} = codes;
                else
                    valid_ids{file_id} = valid_ids{file_id} & valid;
                    labels{file_id} = cat(2, labels{file_id}, codes);
                end

            end 
            file_id = file_id + 1;
        end
    end
    
    labels = labels(1:file_id-1);
    valid_ids = valid_ids(1:file_id-1);
    vid_ids = vid_ids(1:file_id-1, :);
    filenames = filenames(1:file_id-1);
    
end

