function [hog_data, valid_inds, vid_id] = Read_HOG_files_dynamic(users, vid_ids, hog_data_dir)

    hog_data = [];
    vid_id = {};
    
    feats_filled = 0;

    for i=1:numel(users)
        
        hog_file = [hog_data_dir, '/train/' users{i} '.hog'];
        if(~exist(hog_file, 'file'))            
            hog_file = [hog_data_dir, '/devel/' users{i} '.hog'];
        end
        
        f = fopen(hog_file, 'r');
                        
        num_cols = fread(f, 1, 'int32');
        if(isempty(num_cols))
            break;
        end

        num_rows = fread(f, 1, 'int32');
        num_chan = fread(f, 1, 'int32');
        num_feats = num_rows * num_cols * num_chan + 1;
        
        % go to the beginning
        fseek(f, 0, 'bof');
                
        % Read only the relevant bits
        
        % Skip to the right start element (1 indexed)
        fseek(f, 4*(4+num_rows*num_rows*num_chan)*(vid_ids(i,1)-1), 'bof');
        
        feature_vec = fread(f, [4 + num_rows * num_cols * num_chan, vid_ids(i,2) - vid_ids(i,1)], 'float32');
        fclose(f);
        
        curr_data = feature_vec(4:end,:)';
        curr_ind = size(curr_data,1);
          
        vid_id_curr = cell(size(curr_data,1),1);
        vid_id_curr(:) = users(i);
        
        vid_id = cat(1, vid_id, vid_id_curr);
        
        % Assume same number of frames per video
        if(i==1)
            hog_data = zeros(sum(vid_ids(:,2)-vid_ids(:,1)), num_feats);
        end
        
        curr_data(:,2:end) = bsxfun(@plus, curr_data(:,2:end), -median(curr_data(:,2:end)));
        
        hog_data(feats_filled+1:feats_filled+curr_ind,:) = curr_data;
        
        feats_filled = feats_filled + curr_ind;
        
    end
    valid_inds = hog_data(:,1) > 0;
    hog_data = hog_data(:,2:end);
end