function Script_CLNF_general()

addpath(genpath('../'));

% Replace this with the location of the IJB-FL data location
root_test_data = 'F:\Dropbox\janus_labeled';
[images, detections, labels] = Collect_JANUS_imgs(root_test_data);

%% loading the patch experts
   
[ patches, pdm, clmParams ] = Load_CLNF_general();
views = [0,0,0; 0,-30,0; 0,30,0; 0,-55,0; 0,55,0; 0,0,30; 0,0,-30; 0,-90,0; 0,90,0; 0,-70,40; 0,70,-40];
views = views * pi/180;                                                                                     

[ patches_51, pdm_51, clmParams_51, inds_full, inds_inner ] = Load_CLNF_inner();

shapes_all = zeros(size(labels,2),size(labels,3), size(labels,1));
labels_all = zeros(size(labels,2),size(labels,3), size(labels,1));
lhoods = zeros(numel(images),1);

% Use the multi-hypothesis model, as bounding box tells nothing about
% orientation
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

    shapes_all(:,:,i) = shape;                    

    labels_all(:,:,i) = labels(i,:,:);

    if(mod(i, 200)==0)
        fprintf('%d done\n', i );
    end

    lhoods(i) = lhood;

    if(verbose)
        v_points = sum(squeeze(labels(i,:,:)),2) > 0;
        DrawFaceOnFig(image_orig, shape, bbox, v_points);
    end

end
toc

experiment.errors_normed = compute_error(labels_all, shapes_all - 1.0);
experiment.lhoods = lhoods;
experiment.shapes = shapes_all;
experiment.labels = labels_all;

fprintf('Done: mean normed error %.3f median normed error %.4f\n', ...
    mean(experiment.errors_normed), median(experiment.errors_normed));

%%
output_results = 'results/results_clnf_general.mat';
save(output_results, 'experiment');
    
end
