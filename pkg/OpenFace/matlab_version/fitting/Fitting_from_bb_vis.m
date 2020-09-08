function Fitting_from_bb_vis( Image, DepthImage, bounding_box, PDM, patchExperts, clmParams, out_dir, varargin)
%FITTING Summary of this function goes here
%   Detailed explanation goes here

    % the bounding box format is [minX, minY, maxX, maxY];   

    % the mean model shape
    M = PDM.M;         

    num_points = numel(M) / 3;
    
    if(any(strcmp(varargin,'orientation')))
        orientation = varargin{find(strcmp(varargin, 'orientation'))+1};        
        rot = Euler2Rot(orientation);        
    else
        rot = eye(3);
        orientation = [0;0;0];
    end
    
    rot_m = rot * reshape(M, num_points, 3)';
    width_model = max(rot_m(1,:)) - min(rot_m(1,:));
    height_model = max(rot_m(2,:)) - min(rot_m(2,:));

    a = (((bounding_box(3) - bounding_box(1)) / width_model) + ((bounding_box(4) - bounding_box(2))/ height_model)) / 2;
        
    tx = (bounding_box(3) + bounding_box(1))/2;
    ty = (bounding_box(4) + bounding_box(2))/2;
    
    % correct it so that the bounding box is just around the minimum
    % and maximum point in the initialised face
    tx = tx - a*(min(rot_m(1,:)) + max(rot_m(1,:)))/2;
    ty = ty - a*(min(rot_m(2,:)) + max(rot_m(2,:)))/2;

    % visualisation of the initial state
    %hold off;imshow(Image);hold on;plot(a*rot_m(1,:)+tx, a*rot_m(2,:)+ty,'.r');hold on;rectangle('Position', [bounding_box(1), bounding_box(2), bounding_box(3)-bounding_box(1), bounding_box(4)-bounding_box(2)]);
    global_params = [a, 0, 0, 0, tx, ty]';
    global_params(2:4) = orientation;

    local_params = zeros(numel(PDM.E), 1);
    
    if(any(strcmp(varargin,'gparam')))
        global_params = varargin{find(strcmp(varargin, 'gparam'))+1};
    end
    
    if(any(strcmp(varargin,'lparam')))
        local_params = varargin{find(strcmp(varargin, 'lparam'))+1};
    end
    
    scale = clmParams.startScale;              
            
    if(size(Image, 3) == 1)
        GrayImage = Image;
    else
        GrayImage = rgb2gray(Image);
    end
    
    [heightImg, widthImg] = size(GrayImage);

    % Some predefinitions for faster patch extraction
    [xi, yi] = meshgrid(0:widthImg-1,0:heightImg-1);
    xi = double(xi);
    yi = double(yi);
    
    GrayImageDb = double(GrayImage);
    
    % multi iteration refinement using NU-RLMS in each one
    i=1;
      
    current_patch_scaling = patchExperts(scale).trainingScale;
    visibilities = patchExperts(scale).visibilities;

    view = GetView(patchExperts(scale).centers, global_params(2:4));  

    % The shape fitting is performed in the reference frame of the
    % patch training scale
    refGlobal = [current_patch_scaling, 0, 0, 0, 0, 0]';

    % the reference shape
    refShape = GetShapeOrtho(M, PDM.V, local_params, refGlobal);

    % shape around which the patch experts will be evaluated in the original image
    [shape2D] = GetShapeOrtho(M, PDM.V, local_params, global_params);
    shape2D_img = shape2D(:,1:2);

    % Create transform using a slightly modified version of Kabsch that
    % takes scaling into account as well, in essence we get a
    % similarity transform from current estimate to reference shape
    [A_img2ref, T_img2ref, ~, ~] = AlignShapesWithScale(shape2D_img(:,1:2),refShape(:,1:2));

    % Create a transform, from shape in image to reference shape
    T = maketform('affine', [A_img2ref;T_img2ref]);

    shape_2D_ref = tformfwd(T, shape2D_img);

    % transform the current shape to the reference one, so we can
    % interpolate
    shape2D_in_ref = (A_img2ref * shape2D_img')';

    sideSizeX = (clmParams.window_size(i,1) - 1)/2;
    sideSizeY = (clmParams.window_size(i,2) - 1)/2;

    patches = zeros(size(shape2D_in_ref,1), clmParams.window_size(i,1) * clmParams.window_size(i,2));

    Ainv = inv(A_img2ref);

    % extract patches on which patch experts will be evaluted
    for l=1:size(shape2D_in_ref,1)      
        if(visibilities(view,l))

            xs = (shape2D_in_ref(l,1)-sideSizeX):(shape2D_in_ref(l,1)+sideSizeX);
            ys = (shape2D_in_ref(l,2)-sideSizeY):(shape2D_in_ref(l,2)+sideSizeY);                

            [xs, ys] = meshgrid(xs, ys);

            pairs = [xs(:), ys(:)];

            actualLocs = (Ainv * pairs')';

            actualLocs(actualLocs(:,1) < 0,1) = 0;
            actualLocs(actualLocs(:,2) < 0,2) = 0;
            actualLocs(actualLocs(:,1) > widthImg - 1,1) = widthImg - 1;
            actualLocs(actualLocs(:,2) > heightImg - 1,2) = heightImg - 1;

            [t_patch] = interp2_mine(xi, yi, GrayImageDb, actualLocs(:,1), actualLocs(:,2), 'bilinear');
            t_patch = reshape(t_patch, size(xs));

            patches(l,:) = t_patch(:);

        end
    end

    % Calculate patch responses, either SVR or CCNF
    if(strcmp(patchExperts(scale).type, 'SVR'))            
        responses = PatchResponseSVM_multi_modal( patches, patchExperts(scale).patch_experts(view,:), visibilities(view,:), patchExperts(scale).normalisationOptionsCol, clmParams, clmParams.window_size(i,:));

        for r=1:numel(responses)
            out_patch = reshape(patches(r,:)/255, size(xs));
            imwrite(out_patch, [out_dir, '/', num2str(r), '_a.png']);
           imwrite(responses{r}/max(responses{r}(:)), [out_dir, '/', num2str(r), '_svr.png']);  
        end

    elseif(strcmp(patchExperts(scale).type, 'CCNF'))                        
        responses = PatchResponseCCNF( patches, patchExperts(scale).patch_experts(view,:), visibilities(view,:), patchExperts(scale), clmParams.window_size(i,:));
        for r=1:numel(responses)
           imwrite(responses{r}/max(responses{r}(:)), [out_dir, '/', num2str(r), '_lnf.png']);  
        end
    elseif(strcmp(patchExperts(scale).type, 'DNN'))                        
        responses = PatchResponseDNN( patches, patchExperts(scale).patch_experts(view,:), visibilities(view,:), patchExperts(scale), clmParams.window_size(i,:));
        for r=1:numel(responses)
           imwrite(responses{r}/max(responses{r}(:)), [out_dir, '/', num2str(r), '_dnn.png']);  
        end
    end
        
              
    
end


function [id] = GetView(centers, rotation)

    [~,id] = min(sum((centers * pi/180 - repmat(rotation', size(centers,1), 1)).^2,2));

end