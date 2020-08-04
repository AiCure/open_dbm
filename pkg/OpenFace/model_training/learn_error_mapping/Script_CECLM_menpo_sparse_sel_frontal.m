clear
addpath(genpath('../'));

[images, detections, labels] = Collect_menpo_train_imgs('G:\datasets\menpo/');

%% Setup recording
[~, pdm, ~, ~] = Load_CECLM_OF();

%% Identify orientation of each of the training images
orientations = zeros(numel(images), 3);
for i=1:numel(images)
    landmarks = standardise_landmarks(labels{i});
    [ a, R, T, T3D, params, error, shapeOrtho ] = fit_PDM_ortho_proj_to_2D(pdm.M, pdm.E, pdm.V, landmarks);
    orientations(i,:) = Rot2Euler(R);
end

%% Keep only the relevant orientations for that view

angle_dist = sum(abs(orientations)')';

to_keep = angle_dist < 25 * pi/180;
images = images(to_keep);
detections = detections(to_keep,:);
labels = labels(to_keep);

%%

% Change if you want to visualize the outputs
verbose = false;

if(verbose)
    f = figure;
end

view = 1;

%% Mirror indices
mirror_inds = [1,17;2,16;3,15;4,14;5,13;6,12;7,11;8,10;18,27;19,26;20,25;21,24;22,23;...
              32,36;33,35;37,46;38,45;39,44;40,43;41,48;42,47;49,55;50,54;51,53;60,56;59,57;...
              61,65;62,64;68,66];
      
remove_all = cell(4, 1);
errors_all_med = cell(4,1);
errors_all_mean = cell(4,1);

% To start where we finished across scales
gparams = cell(numel(images), 1);
lparams = cell(numel(images), 1);

for scale = 1:4
    
    remove_all_c = [];
    errors_all_med_c = [];
    errors_all_mean_c = [];

    [patches, pdm, clmParams, early_term_params] = Load_CECLM_OF();
    
    clmParams.numPatchIters = 1;
    clmParams.startScale = scale;
    
    patches = patches(1:scale);
    
    for s=1:scale
        patches(s).correlations = patches(s).correlations(view,:);
        patches(s).centers = patches(s).centers(view,:);
        patches(s).rms_errors = patches(s).rms_errors(view,:);
        patches(s).visibilities = patches(s).visibilities(view,:);
        patches(s).patch_experts = patches(s).patch_experts(view,:);
    end
    visi_old = patches(scale).visibilities;
    
    shapes_base = cell(numel(labels), 1);
    
    % First establish the basic error without removing landmarks at this
    % scale
    for i=1:numel(images)

        image = imread(images(i).img);
        image_orig = image;

        if(size(image,3) == 3)
            image = rgb2gray(image);
        end              

        bbox = squeeze(detections(i,:)); 

        % Precomputing patch experts
        if(scale == 1)
            [shape] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams, []);
        else
            [shape] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams, 'gparam', gparams{i}, 'lparam', lparams{i});
        end
        shapes_base{i} = shape;

%         v_points = logical(patches(scale).visibilities(1,:))';
%         DrawFaceOnFig(image_orig, shape, bbox, v_points);
    end

    error_base_mean = mean(compute_error_menpo_1(labels, shapes_base));
    error_base_med = median(compute_error_menpo_1(labels, shapes_base));
    fprintf('Base error scale %d - %.3f\n', scale, error_base_med);
    
    for s=1:30

        % First remove the indicies already decided to remove
        patches(scale).visibilities = visi_old;
        patches(scale).visibilities(view, remove_all_c) = 0;

        % Indices to test removing

        % Identify which indices to remove
        to_rem_potential = find(patches(scale).visibilities(view,:));
        % Now remove the mirror inds from them
        to_remove = intersect(mirror_inds(:,2), to_rem_potential);

        for i=numel(to_remove):-1:1
            to_rem_potential(to_rem_potential==to_remove(i)) = [];
        end

        to_test_num = numel(to_rem_potential);

        gparams_all = cell(numel(images), to_test_num);
        lparams_all = cell(numel(images), to_test_num);
    
        shapes_all = cell(numel(images), to_test_num);
        labels_all = cell(numel(images), to_test_num);

        to_rems = to_rem_potential;
        for i=1:numel(images)

            image = imread(images(i).img);
            image_orig = image;

            if(size(image,3) == 3)
                image = rgb2gray(image);
            end              

            bbox = squeeze(detections(i,:)); 

            % Precomputing patch experts
            if(scale == 1)
                [~,~,~,~,~,~, precomp] = Fitting_from_bb_precomp(image, [], bbox, pdm, patches, clmParams, []);
            else
                [~,~,~,~,~,~, precomp] = Fitting_from_bb_precomp(image, [], bbox, pdm, patches, clmParams, [], 'gparam', gparams{i}, 'lparam', lparams{i});
            end
            for v=1:numel(to_rem_potential)

                patches(scale).visibilities(view, to_rem_potential(v)) = 0;

                mirr_id = union(mirror_inds(find(mirror_inds(:,1)==to_rem_potential(v),1),2),... ;
                            mirror_inds(find(mirror_inds(:,2)==to_rem_potential(v),1),1));

                if(~isempty(mirr_id))
                    patches(scale).visibilities(view, mirr_id) = 0;
                end          

                %% Fitting the model to the provided images    
                if(scale == 1)
                    [shape,gparams_all{i,v},lparams_all{i,v},lhood,lmark_lhood,view_used] = Fitting_from_bb_precomp(image, [], bbox, pdm, patches, clmParams, precomp);
                else
                    [shape,gparams_all{i,v},lparams_all{i,v},lhood,lmark_lhood,view_used] = Fitting_from_bb_precomp(image, [], bbox, pdm, patches, clmParams, precomp, 'gparam', gparams{i}, 'lparam', lparams{i});
                end
                shapes_all{i,v} = shape;
                labels_all{i,v} = labels{i};

                if(mod(i, 200)==0)
                    fprintf('%d done\n', i );
                end

                if(verbose)
                    v_points = logical(patches(scale).visibilities(view_used,:))';
                    DrawFaceOnFig(image_orig, shape, bbox, v_points);
                end

                % Clean up      
                patches(scale).visibilities = visi_old;
                patches(scale).visibilities(view, remove_all_c) = 0;            
            end        

        end 
        errors_mean = zeros(numel(to_rem_potential),1);
        errors_median = zeros(numel(to_rem_potential),1);
        for v=1:numel(to_rem_potential)
            errors_mean(v) = mean(compute_error_menpo_1(labels_all(:,v), shapes_all(:,v)));
            errors_median(v) = median(compute_error_menpo_1(labels_all(:,v), shapes_all(:,v)));
        end

        [~, id] = min(errors_mean);
        
        val_med = errors_median(id);
        val_mean = errors_mean(id);

        remove_all_c = cat(2, remove_all_c, to_rems(id));
        errors_all_med_c = cat(2, errors_all_med_c, val_med);
        errors_all_mean_c = cat(2, errors_all_mean_c, val_mean);

        mirr_id = mirror_inds(find(mirror_inds(:,1)==to_rems(id),1),2);

        if(~isempty(mirr_id))
            remove_all_c = cat(2, remove_all_c, mirr_id);
            errors_all_med_c = cat(2, errors_all_med_c, val_med);
            errors_all_mean_c = cat(2, errors_all_mean_c, val_mean);        
        end
        
        remove_all{scale} = remove_all_c;
        errors_all_med{scale} = errors_all_med_c;
        errors_all_mean{scale} = errors_all_mean_c;
        
        %%
        output_results = 'sparse_selection/menpo_frontal_sparse.mat';
        save(output_results, 'remove_all', 'errors_all_med', 'errors_all_mean');    
    
        fprintf('Curr error rem %d - %.3f\n', s, errors_all_med_c(end));
    
        % Going to the next scale
        if(0.99 * errors_all_med_c(end) > error_base_med)             
            break; 
        end
        
    end
    
    gparams = gparams_all(:,id);
    lparams = lparams_all(:,id);    
    
end
