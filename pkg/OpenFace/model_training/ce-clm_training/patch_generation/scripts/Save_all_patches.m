function Save_all_patches(trainingLoc, frontalView, profile_views, scaling, sigma, version, patches_loc, varargin)
% need some documentation here

if(sum(strcmp(varargin,'ratio_neg')))
    ind = find(strcmp(varargin,'ratio_neg')) + 1;
    ratio_neg = varargin{ind};
else
    ratio_neg = 20;
end

if(sum(strcmp(varargin,'num_samples')))
    ind = find(strcmp(varargin,'num_samples')) + 1;
    num_samples = varargin{ind};
else
    num_samples = 5e5;
end

% first do the frontal view
imgs_used = Save_patches(trainingLoc, frontalView, scaling, sigma, ratio_neg, num_samples, patches_loc, 'frontal', varargin{:});

fprintf('Frontal done\n');

% now do the profile views
for i=1:numel(profile_views)
    view_name = sprintf(['profile%s'], num2str(i));
    imgs_used_profile = ...
        Save_patches(trainingLoc, profile_views(i), scaling, sigma, ratio_neg, num_samples, patches_loc, view_name, varargin{:});
    fprintf('Profile %d done\n', i);
    
    imgs_used = cat(1, imgs_used, imgs_used_profile);

end

% save the images used
[status,msg,msgID] = mkdir('generated');
location_imgs_used = sprintf('generated/imgs_used_%s.mat', version);
save(location_imgs_used, 'imgs_used');

end
