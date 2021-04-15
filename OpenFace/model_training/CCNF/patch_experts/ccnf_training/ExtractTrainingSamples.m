function [samples, labels, samples_unnormed, imgs_used] = ExtractTrainingSamples(examples, landmarkLoc, img_names, sigma, numSamples, landmark, normalisation_options)

%%
% for an area of interest of 19x19 and patch support region of 11x11, we
% would have 9x9=81 samples (9 is the single_input_size, 11 is
% patch_expert_support_size, 19x19 is normalisation_size, 9 would be the
% normalisation_side_size)
evaluation_size = normalisation_options.normalisationRegion;
patch_expert_support_size = normalisation_options.patchSize;

normalisation_side_size = (evaluation_size - 1)/2;
single_input_size = evaluation_size - patch_expert_support_size + 1;

% Determine the ratio of images to be sampled (most likely not all of them will be)
samples_per_img = (numSamples / (size(examples,1) * (1 + normalisation_options.rate_negative))) / (single_input_size(1)^2);

num_samples = int32(samples_per_img * (1 + normalisation_options.rate_negative) * size(examples,1) * (single_input_size(1)^2));

%% Initialise the samples and labels
samples = zeros(num_samples, patch_expert_support_size(1) * patch_expert_support_size(2));                
labels = zeros(num_samples, 1);    

%% Initialise the unnormed versions of the images

% This is done in order to assert our use of algorithms for calculating
% the responses, as for training we might use regular ml procedures,
% whereas for fitting normalised cross-correlation or just
% cross-correlation will be used, so keep some unnormed samples
samples_unnormed = zeros(int32(num_samples/300), evaluation_size(1)^2);

img_size = [size(examples,2), size(examples,3)];

% Extract only images of differing shaped faces to extract more diverse
% training samples
to_keep = FindDistantLandmarks(landmarkLoc, landmark, round(samples_per_img*size(examples,1)));

inds_all = 1:size(examples,1);
samples_to_use = inds_all(to_keep);

% Keep track of how many samples have been computed already
samples_filled = 1;
samples_unnormed_filled = 1;

%% parse the image names for reporting purposes
imgs_used = img_names(samples_to_use);
for i=1:numel(imgs_used)
    [~,name,ext] = fileparts(imgs_used{i});
    imgs_used{i} = [name, ext];
end
for i=samples_to_use

    % Do rate_negative negatives and a single positive
    for p=1:normalisation_options.rate_negative+1

        % create a gaussian
        corrPoint = landmarkLoc(i,landmark,:);
        
        % Ignore occluded points
        if(corrPoint(1) == 0)
           break; 
        end
                
        startX = 1 - corrPoint(1);
        startY = 1 - corrPoint(2);

        patchWidth = img_size(2);
        patchHeight = img_size(1);

        [X, Y] = meshgrid(startX:patchWidth + startX-1, startY:patchHeight + startY-1);

        response = exp(-0.5*(X.^2+Y.^2)/(sigma^2));

        % Choose positive or negative sample
        if(p==normalisation_options.rate_negative+1)
            sample_centre = squeeze(corrPoint) + round(1*randn(2,1));
        else
            sample_centre = squeeze(corrPoint) + round(10*randn(2,1));                
        end

        sample_centre = round(sample_centre);

        sample_centre(sample_centre <= normalisation_side_size(1)) = normalisation_side_size(1) + 1;
        sample_centre(sample_centre > img_size(1)-normalisation_side_size(1)) = img_size(1) - normalisation_side_size(1) - 1;

        patches = squeeze(examples(i, sample_centre(2) - normalisation_side_size:sample_centre(2) + normalisation_side_size, sample_centre(1) - normalisation_side_size:sample_centre(1) + normalisation_side_size));
        side = (single_input_size - 1)/2;
        responses = response(sample_centre(2) - side(2):sample_centre(2) + side(2), sample_centre(1) - side(1):sample_centre(1) + side(1));

        if(samples_unnormed_filled <= size(samples_unnormed,1))
            % even if correct size is not initialised Matlab will
            % sort that out (would only happen once anyway)
            samples_unnormed(samples_unnormed_filled,:) = patches(:);
            samples_unnormed_filled = samples_unnormed_filled + 1;
        end

        % if we want to normalise each patch individualy do it here

        patch = im2col(patches, patch_expert_support_size, 'sliding')';
        response = im2col(responses, [1,1], 'sliding');

        labels(samples_filled:samples_filled+size(patch,1)-1,:) = response;

        samples(samples_filled:samples_filled+size(patch,1)-1,:) = patch;                             
        samples_filled = samples_filled + size(patch,1);           

    end
end

if(normalisation_options.useNormalisedCrossCorr == 1)

    mean_curr = mean(samples, 2);
    patch_normed = samples - repmat(mean_curr,1, patch_expert_support_size(1)*patch_expert_support_size(2));

    % Normalising the patches using the L2 norm
    scaling = sqrt(sum(patch_normed.^2,2));
    scaling(scaling == 0) = 1;

    patch_normed = patch_normed ./ repmat(scaling, 1, patch_expert_support_size(1)*patch_expert_support_size(2));

    samples = patch_normed;
    clear 'patch_normed';
end

% Only keep the filled samples
samples = samples(1:samples_filled-1,:);
labels = labels(1:samples_filled-1,:);

if((samples_filled-1)/(single_input_size(1)*single_input_size(2)) < size(samples_unnormed,1))
    samples_unnormed = samples_unnormed(1:(samples_filled-1)/(single_input_size(1)*single_input_size(2)),:);
end

end