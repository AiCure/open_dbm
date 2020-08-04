function Script_CECLM_menpo_test_profile()

addpath('menpo_challenge_helpers');
addpath('../PDM_helpers/');
addpath('../fitting/normxcorr2_mex_ALL');
addpath('../fitting/');
addpath('../CCNF/');
addpath('../models/');

[images, detections] = Collect_menpo_test_profile('D:\Datasets\menpo\testset\profile/');

%% loading the patch experts
   
clmParams = struct;

clmParams.window_size = [25,25; 23,23; 21,21; 21,21];
clmParams.numPatchIters = size(clmParams.window_size,1);

[patches] = Load_DCLM_Patch_Experts( '../models/cen/', 'cen_patches_*_menpo.mat', [], [], clmParams);

%% Fitting the model to the provided image

output_root = './menpo_fit_ceclm_test_profile/';
mkdir(output_root);
out_pts = './out_profile/';
mkdir(out_pts);
% the default PDM to use
pdmLoc = ['../models/pdm/pdm_68_aligned_menpo.mat'];

load(pdmLoc);

pdm = struct;
pdm.M = double(M);
pdm.E = double(E);
pdm.V = double(V);

clmParams.regFactor = 0.9 * [35, 27, 20, 20];
clmParams.sigmaMeanShift = 1.5 * [1.25, 1.375, 1.5, 1.5]; 
clmParams.tikhonov_factor = [2.5, 5, 7.5, 7.5];

clmParams.startScale = 1;
clmParams.num_RLMS_iter = 10;
clmParams.fTol = 0.01;
clmParams.useMultiScale = true;
clmParams.use_multi_modal = 1;
clmParams.multi_modal_types  = patches(1).multi_modal_types;
clmParams.numPatchIters = 4;

% for recording purposes
experiment.params = clmParams;

num_points = numel(M)/3;

shapes_all = cell(numel(images), 1);
labels_all = cell(numel(images), 1);
lhoods = zeros(numel(images),1);
all_lmark_lhoods = zeros(num_points, numel(images));
all_views_used = zeros(numel(images),1);

% Use the multi-hypothesis model, as bounding box tells nothing about
% orientation
multi_view = true;
verbose = true;
tic
if(verbose)
    f = figure;
end

load('../pdm_generation/menpo_pdm/menpo_chin/conversion.mat');

for i=1:numel(images)

    image = imread(images(i).img);
    image_orig = image;
    
    if(size(image,3) == 3)
        image = rgb2gray(image);
    end              

    bbox = squeeze(detections(i,:));                  
    
    % have a multi-view version
    if(multi_view)

        views = [0,0,0; 0,-70,40; 0,70,-40; 0,-30,0; 0,-60,0; 0,-90,0; 0,30,0; 0,60,0; 0,90,0; 0,0,30; 0,0,-30;];
        views = views * pi/180;                                                                                     

        shapes = zeros(num_points, 2, size(views,1));
        ls = zeros(size(views,1),1);
        lmark_lhoods = zeros(num_points,size(views,1));
        views_used = zeros(size(views,1),1);
        g_params = zeros(size(views, 1), 6);
        % Find the best orientation
        for v = 1:size(views,1)      
            [shapes(:,:,v),g_params(v,:),~,ls(v),lmark_lhoods(:,v),views_used(v)] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams, 'orientation', views(v,:));                                            
        end

        [lhood, v_ind] = max(ls);
        lmark_lhood = lmark_lhoods(:,v_ind);

        shape = shapes(:,:,v_ind);
        view_used = views_used(v_ind);
        g_params = g_params(v_ind,:);
    else
        [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams);
    end

    shape = shape + 0.5;
    [~, name_org, ~] = fileparts(images(i).img);
    name = [out_pts, name_org, '.pts'];
    if(g_params(3) > 0)
        shape = write_menpo_profile(shape, name, a_left, vis_pts_left);
    else
        shape = write_menpo_profile(shape, name, a_right, vis_pts_right);        
    end
    
    all_lmark_lhoods(:,i) = lmark_lhood;
    all_views_used(i) = view_used;

    shapes_all{i} = shape;

    if(mod(i, 200)==0)
        fprintf('%d done\n', i );
    end

    lhoods(i) = lhood;

    if(verbose && mod(i,20) == 0)
        %         f = figure('visible','off');

        try
        if(max(image_orig(:)) > 1)
            imshow(double(image_orig)/255, 'Border', 'tight');
        else
            imshow(double(image_orig), 'Border', 'tight');
        end
        axis equal;
        hold on;
        plot(shape(:,1)-0.5, shape(:,2)-0.5,'.r','MarkerSize',20);
        plot(shape(:,1)-0.5, shape(:,2)-0.5,'.b','MarkerSize',10);
        rectangle('Position', [bbox(1), bbox(2), bbox(3) - bbox(1), bbox(4) - bbox(2)], 'EdgeColor', 'r', 'LineWidth', 2);
%                                         print(f, '-r80', '-dpng', sprintf('%s/%s%d.png', output_root, 'fit', i));
        print(f, '-djpeg', sprintf('%s/%s.jpg', output_root, name_org));
%                                         close(f);
        hold off;
        drawnow expose
        catch warn

        end
    end

end
toc

experiment.lhoods = lhoods;
experiment.shapes = shapes_all;
experiment.all_lmark_lhoods = all_lmark_lhoods;
experiment.all_views_used = all_views_used;

% fprintf('experiment %d done: mean normed error %.3f median normed error %.4f\n', ...
%     numel(experiments), mean(experiment.errors_normed), median(experiment.errors_normed));

%%
output_results = 'results/results_test_menpo_profile.mat';
save(output_results, 'experiments');
    
end
