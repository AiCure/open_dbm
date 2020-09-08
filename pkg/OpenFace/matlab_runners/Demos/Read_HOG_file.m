function [hog_data, valid_inds] = Read_HOG_file(hog_file)

    valid_inds = [];
            
    f = fopen(hog_file, 'r');

    % Pre-allocated data
    curr_data = [];
    curr_ind = 0;

    while(~feof(f))

        if(curr_ind == 0)
            num_cols = fread(f, 1, 'int32');
            if(isempty(num_cols))
                break;
            end

            num_rows = fread(f, 1, 'int32');
            num_chan = fread(f, 1, 'int32');

            curr_ind = curr_ind + 1;            

            % preallocate some space
            if(curr_ind == 1)
                curr_data = zeros(1000, 1 + num_rows * num_cols * num_chan);
                num_feats =  1 + num_rows * num_cols * num_chan;
            end

            if(curr_ind > size(curr_data,1))
                curr_data = cat(1, curr_data, zeros(1000, 1 + num_rows * num_cols * num_chan));
            end
            feature_vec = fread(f, [1, 1 + num_rows * num_cols * num_chan], 'float32');
            curr_data(curr_ind, :) = feature_vec;
        else

            % Reading in batches of 5000

            feature_vec = fread(f, [4 + num_rows * num_cols * num_chan, 5000], 'float32');
            feature_vec = feature_vec(4:end,:)';

            num_rows_read = size(feature_vec,1);

            if(~isempty(feature_vec))
                curr_data(curr_ind+1:curr_ind+num_rows_read,:) = feature_vec;
                curr_ind = curr_ind + size(feature_vec,1);
            end
        end

    end

    fclose(f);

    % Do some cleanup, remove un-allocated data    
    if(~isempty(curr_data))        
        valid_inds = curr_data(1:curr_ind,1);
        hog_data = curr_data(1:curr_ind,2:end);    
    end
end