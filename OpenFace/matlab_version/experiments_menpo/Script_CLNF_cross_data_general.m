function Script_CLNF_cross_data_general()

addpath(genpath('../'));

% Replace this with the location of the Menpo dataset
[images, detections, labels] = Collect_menpo_imgs('G:\Datasets\menpo/');

%% loading the patch experts
   
[ patches, pdm, clmParams ] = Load_CLNF_general();
views = [0,0,0; 0,-30,0; 0,30,0; 0,-55,0; 0,55,0; 0,0,30; 0,0,-30; 0,-90,0; 0,90,0; 0,-70,40; 0,70,-40];
views = views * pi/180;                                                                                     

[ patches_51, pdm_51, clmParams_51, inds_full, inds_inner ] = Load_CLNF_inner();

shapes_all = zeros(size(labels,2),size(labels,3), size(labels,1));
labels_all = zeros(size(labels,2),size(labels,3), size(labels,1));
lhoods = zeros(numel(images),1);

% for recording purposes
experiment.params = clmParams;

num_points = numel(pdm.M)/3;

shapes_all = cell(numel(images), 1);
labels_all = cell(numel(images), 1);
lhoods = zeros(numel(images),1);
all_lmark_lhoods = zeros(num_points, numel(images));
all_views_used = zeros(numel(images),1);

verbose = false; % set to true to visualise the fitting

tic
for i=1:numel(images)

    image = imread(images(i).img);
    image_orig = image;

    if(size(image,3) == 3)
        image = rgb2gray(image);
    end              

    bbox = detections(i,:);                  

    [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb_multi_hyp(image, [], bbox, pdm, patches, clmParams, views);
             
    % Perform inner landmark fitting now
    [shape, shape_inner] = Fitting_from_bb_hierarch(image, pdm, pdm_51, patches_51, clmParams_51, shape, inds_full, inds_inner);
    
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
toc

experiment.lhoods = lhoods;
experiment.shapes = shapes_all;
experiment.labels = labels_all;
experiment.all_lmark_lhoods = all_lmark_lhoods;
experiment.all_views_used = all_views_used;

%%
output_results = 'results/results_clnf_cross-data_general.mat';
save(output_results, 'experiment');
    
end
