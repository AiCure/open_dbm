AU_dir = 'D:/Databases/DISFA/ActionUnit_Labels/';

aus = [1,2,4,5,6,9,12,15,17,20,25,26];

subjects = dir([AU_dir, 'SN*']);

% Store all of the AU directories in a cell
input_label_dirs = cell(numel(subjects), 1);
for i=1:numel(subjects)
    input_label_dirs{i} = [AU_dir, subjects(i).name, '/', subjects(i).name];
end

for user=1:numel(subjects)

    testing_label_files = input_label_dirs(user);

    training_label_files = setdiff(input_label_dirs, testing_label_files);  
    
    training_labels_all = [];
    
    testing_labels_all = [];
    
    % First extract AU information
    for au=aus

        % Extract all of the AUs from the current user
        [training_labels, training_vid_inds_all, training_frame_inds_all] = extract_au_labels(training_label_files, au);        
        [testing_labels, testing_vid_inds_all, testing_frame_inds_all] = extract_au_labels(testing_label_files, au);        

        training_labels_all = cat(2, training_labels_all, training_labels);
        testing_labels_all = cat(2, testing_labels_all, testing_labels);        
        
    end

    % File lists for each of the AUs
    for au_ind=1:numel(aus)
                   
        % extract the interesting frames for training, the interesting ones
        % are the AU

        positive_samples = training_labels_all(:,au_ind) > 0;
        
        active_samples = sum(training_labels_all,2) > 10;
                
        % Remove neighboring images as they are not very informative
        negative_samples = sum(training_labels_all,2) == 0;
        neg_inds = find(negative_samples);
        neg_to_use = randperm(numel(neg_inds));
        % taking a number of neutral samples that bring the positive and
        % negative samples to a balanced level
        neg_to_use = neg_inds(neg_to_use(1:(2*sum(positive_samples) - sum(active_samples | positive_samples))));
        negative_samples(:) = false;
        negative_samples(neg_to_use) = true;
        
        % Collect all the data for training now
        training_samples = positive_samples | active_samples | negative_samples;
        
        % Create a training file list file        
        f_train_file_list = fopen(sprintf('%s/%s_au%02d_filelist_train.txt', 'single_au_class', subjects(user).name, aus(au_ind)), 'w');
        
        sample_inds_train = find(training_samples);
        
        for sample_ind = sample_inds_train'
            
            img_file_l = sprintf('../../LeftVideo%s_comp/frame_det_%06d.png', training_vid_inds_all{sample_ind}, training_frame_inds_all(sample_ind));
            img_file_r = sprintf('../../RightVideo%s_comp/frame_det_%06d.png', training_vid_inds_all{sample_ind}, training_frame_inds_all(sample_ind));
            
            au_class = training_labels_all(sample_ind, au_ind) > 1;
            
            fprintf(f_train_file_list, '%s %d\r\n', img_file_l, au_class);                        
            fprintf(f_train_file_list, '%s %d\r\n', img_file_r, au_class);                        
            
        end                
        fclose(f_train_file_list);
        
         % Create a testing file list file        
        f_train_file_list = fopen(sprintf('%s/%s_au%02d_filelist_test.txt', 'single_au_class', subjects(user).name, aus(au_ind)), 'w');
        
        
        testing_samples = true(size(testing_labels_all,1),1);        
        sample_inds_test = find(testing_samples);
        
        for sample_ind = sample_inds_test'
            
            img_file_l = sprintf('../../LeftVideo%s_comp/frame_det_%06d.png', testing_vid_inds_all{sample_ind}, testing_frame_inds_all(sample_ind));
            img_file_r = sprintf('../../RightVideo%s_comp/frame_det_%06d.png', testing_vid_inds_all{sample_ind}, testing_frame_inds_all(sample_ind));
            
            au_class = testing_labels_all(sample_ind, au_ind) > 1;
            
            fprintf(f_train_file_list, '%s %d\r\n', img_file_l, au_class);                        
            fprintf(f_train_file_list, '%s %d\r\n', img_file_r, au_class);                        
            
        end                
        fclose(f_train_file_list);       
        
    end
    
end