% If a different type of PDM is to be trained, prepare training data here

clear
load('menpo_68_pts_flip.mat');
addpath('../PDM_helpers');

xs = all_pts(1:end/2,:);
ys = all_pts(end/2+1:end,:);
num_imgs = size(xs, 1);

pdmLoc = ['../../models/pdm/pdm_68_aligned_wild.mat'];
% pdmLoc = ['pdm_68_aligned_menpo_v1.mat'];

load(pdmLoc);

pdm = struct;
pdm.M = double(M);
pdm.E = double(E);
pdm.V = double(V);
errs_poss = [];

all_shapes = -200 * ones(num_imgs, 68 * 2);
min_x = 0;
max_x = 0;
min_y = 0;
max_y = 0;

for i=1:num_imgs
    
    shape2D = cat(2, all_pts(i,:)', all_pts(i+num_imgs,:)'); 
    
    M_n = M;
    ind_rem = find(shape2D(:,1) == -1);
    to_keep = setdiff(1:68, ind_rem);
    
    if(sum(shape2D(:)==-1) > 0)        

        hidden = true;
        % which indices to remove
        inds_to_rem = shape2D(:,1) == -1 | shape2D(:,2) == -1;

        shape2D = shape2D(~inds_to_rem,:);

        inds_to_rem = repmat(inds_to_rem, 3, 1);

        M_n = M(~inds_to_rem);
        
    end
    
    % To deal with really extreme cases of roll
    M2D = cat(2, M_n(1:end/3), M_n(end/3+1:2*end/3));
    [ A, t, error, alignedShape, s ] = AlignShapesWithScale(M2D, shape2D);
    R = A/s;
    
    % Transform the shape
    shape2D(:,1) = shape2D(:,1) - t(1);
    shape2D(:,2) = shape2D(:,2) - t(2);
    
    shape2D = (R' * shape2D')/s;
    shape2D = shape2D';
       
%     all_pts(i,all_pts(i,:)~=-1) = shape2D(:,1);
%     all_pts(i+num_pts,all_pts(i+num_pts,:)~=-1) = shape2D(:,2);    
%     
    all_shapes(i,[to_keep,to_keep+68]) = shape2D(:);
    
    if(min(shape2D(:,1)) < min_x)
        min_x = min(shape2D(:,1));
    end
    if(min(shape2D(:,2)) < min_y)
        min_y = min(shape2D(:,2));
    end
    if(max(shape2D(:,1)) > max_x)
        max_x = max(shape2D(:,1));
    end
    if(max(shape2D(:,2)) > max_y)
        max_y = max(shape2D(:,2));
    end
end

% Scaling and shifting the model so that all points are from -1 to 1
MD = all_shapes == -200;

xs = 2 * (all_shapes(:,1:68) - min_x)/(max_x-min_x) - 1;
ys = 2 * (all_shapes(:,69:end) - min_y)/(max_y - min_y) - 1;

all_shapes = cat(2, xs, ys);
all_shapes(MD) = -2;

xs = all_shapes(:,1:68);
ys = all_shapes(:,69:end);

save('menpo_train.mat', 'all_shapes');

%%
load('menpo_68_pts_valid.mat');

xs = all_pts(1:end/2,:);
ys = all_pts(end/2+1:end,:);
num_imgs = size(xs, 1);

all_shapes = -200 * ones(num_imgs, 68 * 2);

for i=1:num_imgs
    
    shape2D = cat(2, all_pts(i,:)', all_pts(i+num_imgs,:)'); 
    
    M_n = M;
    ind_rem = find(shape2D(:,1) == -1);
    to_keep = setdiff(1:68, ind_rem);
    
    if(sum(shape2D(:)==-1) > 0)        

        hidden = true;
        % which indices to remove
        inds_to_rem = shape2D(:,1) == -1 | shape2D(:,2) == -1;

        shape2D = shape2D(~inds_to_rem,:);

        inds_to_rem = repmat(inds_to_rem, 3, 1);

        M_n = M(~inds_to_rem);
        
    end
    
    % To deal with really extreme cases of roll
    M2D = cat(2, M_n(1:end/3), M_n(end/3+1:2*end/3));
    [ A, t, error, alignedShape, s ] = AlignShapesWithScale(M2D, shape2D);
    R = A/s;
    
    % Transform the shape
    shape2D(:,1) = shape2D(:,1) - t(1);
    shape2D(:,2) = shape2D(:,2) - t(2);
    
    shape2D = (R' * shape2D')/s;
    shape2D = shape2D';
       
%     all_pts(i,all_pts(i,:)~=-1) = shape2D(:,1);
%     all_pts(i+num_pts,all_pts(i+num_pts,:)~=-1) = shape2D(:,2);    
%     
    all_shapes(i,[to_keep,to_keep+68]) = shape2D(:);

end

% Scaling and shifting the model so that all points are from -1 to 1
MD = all_shapes == -200;

xs = 2 * (all_shapes(:,1:68) - min_x)/(max_x-min_x) - 1;
ys = 2 * (all_shapes(:,69:end) - min_y)/(max_y - min_y) - 1;

all_shapes = cat(2, xs, ys);
all_shapes(MD) = -2;

xs = all_shapes(:,1:68);
ys = all_shapes(:,69:end);

save('menpo_valid.mat', 'all_shapes');
