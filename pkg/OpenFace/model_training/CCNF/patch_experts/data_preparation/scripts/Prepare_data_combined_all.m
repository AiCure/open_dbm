function Prepare_data_combined_all()

    % Read in in-the-wild data and Multi-PIE data and concatenate them
    root = '../prepared_data/';
    Collect_combined_data(root, '0.25');
    Collect_combined_data(root, '0.35');
    Collect_combined_data(root, '0.5');
    Collect_combined_data(root, '1');
end

function Collect_combined_data(root, scale)

    wild_locs = dir(sprintf('%s/wild_%s*.mat', root, scale));
    mpie_locs = dir(sprintf('%s/mpie_%s*.mat', root, scale));
    
    % For a particular loaded m_pie check if an appropriate in-the-wild
    % exists
    for i=1:numel(mpie_locs)
       
        load([root, mpie_locs(i).name]);
        
        imgs_used_pie = actual_imgs_used;
        samples_pie = all_images;
        centres_pie = centres;
        landmark_locations_pie = landmark_locations;
        
        wild_to_use = -1;
        for j=1:numel(wild_locs)
            load([root, wild_locs(j).name], 'centres');
            if(isequal(centres_pie, centres))
                wild_to_use = j;
            end                
        end
        
        % Reset the centres
        centres = centres_pie;
        
        if(wild_to_use ~= -1)
            load([root, wild_locs(wild_to_use).name]);
            actual_imgs_used = cat(1, actual_imgs_used, imgs_used_pie);
            all_images = cat(1, all_images, samples_pie);
            landmark_locations = cat(1, landmark_locations, landmark_locations_pie);
        end
        
        save(sprintf('%s/combined_%s_%d.mat', root, scale, i), 'actual_imgs_used', 'all_images', 'centres', 'landmark_locations', 'training_scale', 'visiIndex');
    end
    
end