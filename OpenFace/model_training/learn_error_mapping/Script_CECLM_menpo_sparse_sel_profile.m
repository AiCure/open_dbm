function Script_CECLM_menpo_sparse_sel_profile()

addpath(genpath('../'));

[images, detections, labels] = Collect_menpo_train_imgs('G:\datasets\menpo/');


%% loading the CE-CLM model and parameters   
[patches, pdm, clmParams, early_term_params] = Load_CECLM_menpo();
patches = patches(1);

%% Setup recording
clmParams.numPatchIters = 1;
experiment.params = clmParams;

num_points = numel(pdm.M)/3;


%% Identify orientation of each of the training images
orientations = zeros(numel(images), 3);
centres_all = patches.centers;
num_centers = size(centres_all,1);
views_all = zeros(numel(images), 1);
for i=1:numel(images)
    landmarks = standardise_landmarks(labels{i});
    [ a, R, T, T3D, params, error, shapeOrtho ] = fit_PDM_ortho_proj_to_2D(pdm.M, pdm.E, pdm.V, landmarks);
    orientations(i,:) = Rot2Euler(R);
    [~, view] = min(sum(abs(centres_all * pi/180 - repmat(orientations(i,:) , num_centers, 1)),2));
%     views_all(i) = view;
end

%% Keep only the relevant orientations for that view
or_id = 2;
view = or_id;
mirr_view = 9 - view;
orientation_1 = patches.centers(or_id,:) * pi/180;
orientation_2 = orientation_1;
orientation_2(2) = -orientation_2(2);

% Keep the ones closest to orientation of interest

angle_dist_1 = sum(abs(bsxfun(@plus, orientations, -orientation_1))')';
to_keep_1 = angle_dist_1 < 15 * pi/180;

angle_dist_2 = sum(abs(bsxfun(@plus, orientations, -orientation_2))')';
to_keep_2 = angle_dist_2 < 15 * pi/180;

to_keep = to_keep_1 | to_keep_2;

% Keep track of which view is used
to_keep_1 = to_keep_1(to_keep);
to_keep_2 = to_keep_2(to_keep);

images = images(to_keep);
detections = detections(to_keep,:);
labels = labels(to_keep);

shapes_all = cell(numel(images), 1);
labels_all = cell(numel(images), 1);
lhoods = zeros(numel(images),1);
all_lmark_lhoods = zeros(num_points, numel(images));
all_views_used = zeros(numel(images),1);

%%

% Change if you want to visualize the outputs
verbose = false;

if(verbose)
    f = figure;
end

remove_all = [];
remove_all_mirr = [];
errors_all_med = [];
errors_all_mean = [];
visi_old = patches(1).visibilities;
rng(0);

%% Mirror indices
mirror_inds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
              32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
              61,65;62,64;68,66];
                    
for s=1:30
    
    % First remove the indicies already decided to remove
    patches(1).visibilities = visi_old;
    patches(1).visibilities(view, remove_all) = 0;
    patches(1).visibilities(mirr_view, remove_all_mirr) = 0;

    % Indices to test removing
    
    % Identify which indices are up for removal
    to_rem_potential = find(patches(1).visibilities(view,:));
    
    to_test_num = numel(to_rem_potential);

    errors_mean = zeros(to_test_num, 1);
    errors_median = zeros(to_test_num, 1);
    to_rems = zeros(to_test_num, 1);
    to_rems_mirr = zeros(to_test_num, 1);
    
    for v=1:numel(to_rem_potential)

        to_rem_c = to_rem_potential(v);
        
        % See if there's a mirror index to this and remove both        
        patches(1).visibilities(view, to_rem_c) = 0;
        to_rems(v) = to_rem_c;
        
        mirr_id = union(mirror_inds(find(mirror_inds(:,1)==to_rem_c,1),2),... ;
                        mirror_inds(find(mirror_inds(:,2)==to_rem_c,1),1));
        if(~isempty(mirr_id))
            patches(1).visibilities(mirr_view, mirr_id) = 0;
            to_rems_mirr(v) = mirr_id;
        else
            patches(1).visibilities(mirr_view, to_rem_c) = 0;
            to_rems_mirr(v) = to_rem_c;
        end
        
        %% Fitting the model to the provided images
        tic
        for i=1:numel(images)
            image = imread(images(i).img);
            image_orig = image;

            if(size(image,3) == 3)
                image = rgb2gray(image);
            end              

            bbox = squeeze(detections(i,:));                  

            % pick the view
            if(to_keep_1(i))
               or = orientation_1;
            else
               or = orientation_2;
            end
            [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams, 'orientation', or);

            all_lmark_lhoods(:,i) = lmark_lhood;
            all_views_used(i) = view_used;

            shapes_all{i} = shape;
            labels_all{i} = labels{i};

            if(mod(i, 200)==0)
                fprintf('%d done\n', i );
            end

            lhoods(i) = lhood;

            if(verbose)
                v_points = logical(patches(1).visibilities(view_used,:))';
                DrawFaceOnFig(image_orig, shape, bbox, v_points);
            end
        end
        
        % Reset the visibilities
        patches(1).visibilities = visi_old;
        patches(1).visibilities(view, remove_all) = 0;
        patches(1).visibilities(mirr_view, remove_all_mirr) = 0;
        
        errors_mean(v) = mean(compute_error_menpo_1(labels_all(1:i), shapes_all(1:i)));
        errors_median(v) = median(compute_error_menpo_1(labels_all(1:i), shapes_all(1:i)));
                
    end 
    
    [~, id] = min(errors_mean);

    val_med = errors_median(id);
    val_mean = errors_mean(id);
    
    remove_all = cat(2, remove_all, to_rems(id));
    remove_all_mirr = cat(2, remove_all_mirr, to_rems_mirr(id));
    errors_all_med = cat(2, errors_all_med, val_med);
    errors_all_mean = cat(2, errors_all_mean, val_mean);
       
        
    %%
    output_results = 'sparse_selection/menpo_profile_1_sparse.mat';
    save(output_results, 'remove_all', 'remove_all_mirr', 'errors_all_med', 'errors_all_mean');    
end
toc
    
end
