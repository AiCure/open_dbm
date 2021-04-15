function Script_CLNF_wild()

addpath(genpath('../'));

% Replace this with the location of in 300 faces in the wild data
if(exist([getenv('USERPROFILE') '/Dropbox/AAM/test data/'], 'file'))
    root_test_data = [getenv('USERPROFILE') '/Dropbox/AAM/test data/'];    
else
    root_test_data = 'F:\Dropbox\AAM\test data/';
end

[images, detections, labels] = Collect_wild_imgs(root_test_data);
%% loading the patch experts and pdms
   
[ patches, pdm, clmParams ] = Load_CLNF_wild();
%views = [0,0,0];
% Use the multi-hypothesis model, as bounding box tells nothing about
% orientation
views = [0,0,0; 0,-30,0; 0,30,0; 0,0,30; 0,0,-30;];
views = views * pi/180;                                                                                     

% for recording purposes
experiment.params = clmParams;

%% Change if you want to visualize the outputs
verbose = false;
output_img = false;

if(output_img)
    output_root = './clnf_out_wild/';
    if(~exist(output_root, 'dir'))
        mkdir(output_root);
    end
end
if(verbose)
    f = figure;
end

%% For recording

shapes_all = zeros(size(labels,2),size(labels,3), size(labels,1));
labels_all = zeros(size(labels,2),size(labels,3), size(labels,1));
lhoods = zeros(numel(images),1);

%% Fitting the model to the provided image

tic
for i=1:numel(images)

    image = imread(images(i).img);
    image_orig = image;

    if(size(image,3) == 3)
        image = rgb2gray(image);
    end              

    bbox = detections(i,:);                  

    [shape,~,~,lhood,lmark_lhood,view_used] = Fitting_from_bb_multi_hyp(image, [], bbox, pdm, patches, clmParams, views);

    shapes_all(:,:,i) = shape;                    

    labels_all(:,:,i) = labels(i,:,:);

    if(mod(i, 200)==0)
        fprintf('%d done\n', i );
    end

    lhoods(i) = lhood;

    
    if(output_img)
        v_points = sum(squeeze(labels(i,:,:)),2) > 0;
        DrawFaceOnImg(image_orig, shape, sprintf('%s/%s%d.jpg', output_root, 'fit', i), bbox, v_points);
    end
    
    if(verbose)
        v_points = sum(squeeze(labels(i,:,:)),2) > 0;
        DrawFaceOnFig(image_orig, shape, bbox, v_points);
    end

end
toc

experiment.errors_normed = compute_error(labels_all, shapes_all + 1.0);
experiment.lhoods = lhoods;
experiment.shapes = shapes_all;
experiment.labels = labels_all;

fprintf('Done: mean normed error %.3f median normed error %.4f\n', ...
    mean(experiment.errors_normed), median(experiment.errors_normed));

%%
output_results = 'results/results_clnf_wild.mat';
save(output_results, 'experiment');
    
end
