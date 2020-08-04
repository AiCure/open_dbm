function Collect_all_patches(trainingLoc, frontalView, profile_views, scaling, sigma, version, varargin)
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
AppendTraining(trainingLoc, frontalView, scaling, sigma, ratio_neg, num_samples, 0, version, varargin{:});

fprintf('Frontal done\n');

% now do the profile views
for i=1:numel(profile_views)
    AppendTraining(trainingLoc, profile_views(i), scaling, sigma, ratio_neg, num_samples, i, version, varargin{:});
    fprintf('Profile %d done\n', i);    
end

end

function AppendTraining(training_data_loc, view, scale, sigma, ratio_neg, num_samples, varargin)
    
    Collect_patches_view(training_data_loc, view, scale, sigma, ratio_neg, num_samples, varargin{:});
   
end
