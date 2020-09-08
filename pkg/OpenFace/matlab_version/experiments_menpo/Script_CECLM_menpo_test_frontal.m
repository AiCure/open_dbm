function Script_CECLM_menpo_test_frontal()

addpath(genpath('../'));
addpath(genpath('./menpo_challenge_helpers'));

[images, detections] = Collect_menpo_test_frontal('G:\Datasets\menpo\testset\semifrontal/');

%% loading the CE-CLM model and parameters   
[patches, pdm, clmParams, early_term_params] = Load_CECLM_menpo();
views = [0,0,0; 0,-30,0; 0,30,0; 0,-55,0; 0,55,0; 0,0,30; 0,0,-30; 0,-90,0; 0,90,0; 0,-70,40; 0,70,-40];
views = views * pi/180;  

%% Setup recording
experiment.params = clmParams;

num_points = numel(pdm.M)/3;

shapes_all = cell(numel(images), 1);
lhoods = zeros(numel(images),1);
all_lmark_lhoods = zeros(num_points, numel(images));
all_views_used = zeros(numel(images),1);

% Change if you want to visualize the outputs
verbose = false;
output_img = false;

if(output_img)
    output_root = './ceclm_menpo_test/';
    if(~exist(output_root, 'dir'))
        mkdir(output_root);
    end
end
if(verbose)
    f = figure;
end

out_pts = './out_semifrontal/';
if(~exist(out_pts, 'dir'))
    mkdir(out_pts);
end

%%
for i=1:numel(images)

    image = imread(images(i).img);
    image_orig = image;
    
    if(size(image,3) == 3)
        image = rgb2gray(image);
    end              

    bbox = squeeze(detections(i,:));                  
    
    [shape,~,~,lhood,lmark_lhood,view_used] =...
        Fitting_from_bb_multi_hyp(image, [], bbox, pdm, patches, clmParams, views, early_term_params);

    shape = shape + 0.5;
    [~, name_org, ~] = fileparts(images(i).img);
    name = [out_pts, name_org, '.pts'];
    
    shape = write_menpo_frontal(shape, name);
    
    all_lmark_lhoods(:,i) = lmark_lhood;
    all_views_used(i) = view_used;

    shapes_all{i} = shape;

    if(mod(i, 200)==0)
        fprintf('%d done\n', i );
    end

    lhoods(i) = lhood;

    if(output_img)
        v_points = logical(patches(1).visibilities(view_used,:))';
        DrawFaceOnImg(image_orig, shape, sprintf('%s/%s%d.jpg', output_root, 'fit', i), bbox, v_points);
    end
    
    if(verbose)
        v_points = logical(patches(1).visibilities(view_used,:))';
        DrawFaceOnFig(image_orig, shape, bbox, v_points);
    end

end

experiment.lhoods = lhoods;
experiment.shapes = shapes_all;
experiment.all_lmark_lhoods = all_lmark_lhoods;
experiment.all_views_used = all_views_used;

%%
output_results = 'results/results_test_menpo_semifrontal.mat';
save(output_results, 'experiment');
    
end
