function [ labels, valid_ids, filenames  ] = extract_Bosphorus_labels( Bosphorus_dir, recs, aus )
%EXTRACT_SEMAINE_LABELS Summary of this function goes here
%   Detailed explanation goes here
    
    % Ignoring rare ones or ones that don't overlap with other datasets
    aus_Bosphorus = [1, 2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 17, 20, 23, 25, 26, 43];
    aus(aus == 45) = 43;
    
    %%
    fid = fopen([Bosphorus_dir, './facscodes/facscodes.lst']);
    % Skipping the header
    fgetl(fid);
    fgetl(fid);
    
    % Starting to read
    data = fgetl(fid);
    
    all_aus = [];
    valid = [];
    
    id = 1;

    filenames = {};
    
    while ischar(data)
        
        d = strsplit(data, '->');
        data = fgetl(fid);
        
        filename = strtrim(d{1});
                        
        % Skip extreme poses
        if(~isempty(findstr(filename, 'CR')) || ~isempty(findstr(filename, 'YR') > 0) || ~isempty(findstr(filename, 'PR_U'))|| ~isempty(findstr(filename, 'PR_D')))
           continue; 
        end
        
        % ignore labels from non requested users
        if(isempty(strmatch(filename(1:5), recs)))
            continue;
        end
        
        filenames = cat(1, filenames, filename);
        
        aus_str = d{2}(3:end);

        % decode the AU data
        aus_c = strsplit(aus_str, '+');
        
        curr_img_au = zeros(1, 80);
        
        for i=1:numel(aus_c)
            
            if(aus_c{i} == '0')
                
                continue
            end
            
            intensity = -1;
            
            intensity_str = aus_c{i}(end);
            if(intensity_str == 'A')
                intensity = 1;
            elseif(intensity_str == 'B')
                intensity = 2;               
            elseif(intensity_str == 'C')
                intensity = 3;               
            elseif(intensity_str == 'D')
                intensity = 4;               
            elseif(intensity_str == 'E')
                intensity = 5;               
            end
            
            if(~isempty(str2num(aus_c{i}(1))))
                if(intensity ~= -1)
                    num = str2num(aus_c{i}(1:end-1));
                else
                    num = str2num(aus_c{i}(1:end));
                    intensity = 3; % if no intensity given just assume 3
                end
            else
                if(intensity ~= -1)
                    num = str2num(aus_c{i}(2:end-1));
                else
                    num = str2num(aus_c{i}(2:end));
                    intensity = 3; % if no intensity given just assume 3
                end
            end
                                    
            curr_img_au(1, num) = intensity;
        end
        all_aus = cat(1, all_aus, curr_img_au);
        valid = cat(1, valid, [true]);
        
        id = id + 1;

    end
    %aus_bosph = dlmread(, '->', 3, 0);
    fclose(fid);
    
    valid_ids = logical(valid);
    labels = all_aus(:, aus);
end

