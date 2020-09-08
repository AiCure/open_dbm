function Script_CECLM_general_cross_data_multi_hyp()

addpath(genpath('../'));

[images, detections, labels] = Collect_menpo_train_imgs('D:\Datasets\menpo/');

%% loading the patch experts
[patches, pdm, clmParams] = Load_CECLM_general();

%% Fitting the model to the provided image
views = [0,0,0; 0,-30,0; 0,30,0; 0,-55,0; 0,55,0; 0,0,30; 0,0,-30; 0,-90,0; 0,90,0; 0,-70,40; 0,70,-40];
views = views * pi/180;                                                                                     
num_views = size(views,1);

clmParams.numPatchIters = 1;

% for recording purposes
experiment.params = clmParams;

num_points = numel(pdm.M)/3;

shapes_all = cell(numel(images), num_views);
labels_all = cell(numel(images), 1);
lhoods = zeros(numel(images),num_views);
all_lmark_lhoods = zeros(num_points, numel(images),num_views);
all_views_used = zeros(numel(images),num_views);
errors_view = zeros(numel(images),num_views);
% Use the multi-hypothesis model, as bounding box tells nothing about
% orientation
verbose = true;
tic

for i=1:numel(images)

    image = imread(images(i).img);
    image_orig = image;

    if(size(image,3) == 3)
        image = rgb2gray(image);
    end              

    bbox = squeeze(detections(i,:));                  


    % Find the best orientation
    for v = 1:size(views,1)
        [shape,~,~,lhood,lmark_lhoods,view_used] = Fitting_from_bb(image, [], bbox, pdm, patches, clmParams, 'orientation', views(v,:));                                            
        shapes_all{i,v} = shape;
        all_views_used(i,v) = view_used;
        all_lmark_lhoods(:, i,v) = lmark_lhoods;
        lhoods(i,v) = lhood;
        errors_view(i,v) = compute_error_menpo_1(labels(i), {shape});
    end

    labels_all{i} = labels{i};

    if(mod(i, 200)==0)
        fprintf('%d done\n', i );
    end

end
toc

experiment.lhoods = lhoods;
experiment.errors_view = errors_view;
experiment.all_views_used = all_views_used;

%%
output_results = ['results/results_ceclm_general.mat'];
save(output_results, 'experiment');
end
