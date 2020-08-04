clear

load('menpo_68_pts_flip');

pdmLoc = ['../../models/pdm/pdm_68_aligned_wild.mat'];
load(pdmLoc);
% Before plugging into NRSFM, align the points in 2D
num_pts = size(all_pts,1)/2;
    
num_lmks = numel(M) / 3;
m = reshape(M, num_lmks, 3)';
width_model = max(m(1,:)) - min(m(1,:));
height_model = max(m(2,:)) - min(m(2,:));
    
for i=1:size(all_pts,1)/2
    
    shape2D = cat(2, all_pts(i,:)', all_pts(i+num_pts,:)'); 
    
    M_n = M;

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

    all_pts(i,all_pts(i,:)~=-1) = shape2D(:,1);
    all_pts(i+num_pts,all_pts(i+num_pts,:)~=-1) = shape2D(:,2);
end

%%
% to_rem = randperm(round(0.1*num_pts)); % Remove 10% to break some symmetry
% all_pts([to_rem, to_rem+num_pts],:) = [];
num_pts = size(all_pts,1)/2;

left_ids = all_pts(1:num_pts,10) == -1;
right_ids = all_pts(1:num_pts,8) == -1;
frontal = true(num_pts,1);
frontal(left_ids | right_ids) = false;

%%
xs = all_pts(1:num_pts,:);
ys = all_pts(num_pts+1:end,:);

% Randperm the data, as a test

% xs_f = xs(frontal,:);
% ys_f = ys(frontal,:);
% scatter(xs_f(:), -ys_f(:));

%% Perform NRSFM by Torresani 
addpath('../nrsfm-em');
% (T is the number of frames, J is the number of points)

J = size(all_pts,2);
T = size(all_pts,1)/2;

use_lds = 0; % not modeling a linear dynamic system here
max_em_iter = 200;
tol = 0.001;
K = 30; % number of deformation shapes

MD = all_pts(1:end/2,:)==-1;

[P3, S_hat, V, RO, Tr, Z] = em_sfm(all_pts, MD, K, use_lds, tol, max_em_iter);

save('Torr_menpo', 'P3', 'S_hat', 'V', 'RO', 'Tr', 'Z');

%%
% xs = P3(1:num_pts,:);
% ys = P3(num_pts+1:2*num_pts,:);
% zs = P3(2*num_pts+1:end,:);
% % 
% xs_f = xs(left_ids,:);
% ys_f = ys(left_ids,:);
% zs_f = zs(left_ids,:);
% scatter3(xs_f(:), ys_f(:), zs_f(:));