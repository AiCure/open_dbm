function train_CNN_model(varargin)

setup('useGPU', true);

tic

% Load the data
root_loc = 'D:\Datasets\detection_validation';
location = [root_loc, '/prep_data/'];

faceCheckersLoc_train = dir([location 'face_validator_train_*']);   
faceCheckersLoc_test = dir([location 'face_validator_test_*']);

corrs_all = [];
rmses_all = [];

faceCheckers = struct;

% As we will be training a classifier that will act as a regressor,
% binarize it
num_bins = 30;

for i=1:numel(faceCheckersLoc_train)
   
    load([location faceCheckersLoc_train(i).name]);
        
    % set a max value to the error
    errors(errors > 3) = 3;
    errors_train = quantizeContinuous(errors, 0, 3, num_bins);
    examples_train = single(examples);
    clear examples
    
    mean_ex = mean(examples_train);
    std_ex = std(examples_train);     
    std_ex = std_ex / 256;
    examples_train = bsxfun(@times, bsxfun(@minus, examples_train, mean_ex), 1./std_ex);
    num_examples_train = size(examples_train,1);
    
    % Add rows and columns untill we have 60 x 60 image
    
    % keep adding rows
    while(size(mask,1) < 60)        
        mask = cat(1, mask, false(1, size(mask,2)));
        triX = cat(1, triX, -ones(1, size(mask,2)));
    end
    
    % keep adding cols
    while(size(mask,2) < 60)        
        mask = cat(2, mask, false(size(mask,1),1));
        triX = cat(2, triX, -ones(size(triX,1),1));
    end

    examples_r = single(zeros(size(mask, 1), size(mask, 2), num_examples_train));
    
    img_curr = zeros(size(mask));
    for e=1:num_examples_train
        
        img_curr(mask) = examples_train(e,:);
        examples_r(:, :, e) = img_curr;
        
    end    
    
    imdb.images.data = examples_r;
    clear examples_r
    imdb.images.label = errors_train';
    imdb.images.id = 1:numel(errors_train);
     
    % Split data for training and validation (20%)
    imdb.images.set = ones(1, numel(errors_train));
    imdb.images.set(round(4*end/5):end) = 2;
    
    % Visualize some of the data
    figure(10) ; clf ; colormap gray ;
    subplot(1,2,1) ;
    pos_samples = squeeze(imdb.images.data(:,:,imdb.images.label==1));    
    vl_imarraysc(pos_samples(:,:,1:20)) ;
    axis image off ;
    title('Positive training data') ;

    subplot(1,2,2) ;
    neg_samples = squeeze(imdb.images.data(:,:,imdb.images.label>5));    
    vl_imarraysc(neg_samples(:,:,1:20)) ;
    axis image off ;
    title('Negative training data') ;
    
    net = initializeFaceCNN(num_bins) ;
    
    trainOpts.batchSize = 100 ;
    trainOpts.numEpochs = 20;
    trainOpts.continue = true ;
    trainOpts.gpus = [1] ;
    trainOpts.learningRate = 0.001 ;
    trainOpts.expDir = ['trained/intermediate/face_validator_' num2str(i)];
    trainOpts.errorFunction = 'regression';
    trainOpts = vl_argparse(trainOpts, varargin);

    % Call training function in MatConvNet
    [net,info] = cnn_train_reg(net, imdb, @getBatch, trainOpts) ;

    % Move the CNN back to the CPU if it was trained on the GPU
    if numel(trainOpts.gpus) > 0
      net = vl_simplenn_move(net, 'cpu') ;
    end

    % Save the result for later use
    net.layers(end) = [] ;
    net.imageMean = mean_ex ;
    net.imageStd = std_ex;
    
%     save('data/face-experiment/facecnn.mat', '-struct', 'net') ;

    
    % Evaluate on the test data, also evaluate using correlation and RMSE    
    load([location faceCheckersLoc_test(i).name]);
        
    % set a max value to the error
    errors(errors > 3) = 3;
    errors_test = errors;
    errors_q = quantizeContinuous(errors, 0, 3, num_bins);
    errors_test_q = errors_q;
    examples_test = single(examples);
    examples_test = bsxfun(@times, bsxfun(@minus, examples_test, net.imageMean), 1./net.imageStd);
    num_examples_test = size(examples_test,1);
    
    % keep adding rows
    while(size(mask,1) < 60)        
        mask = cat(1, mask, false(1, size(mask,2)));
        triX = cat(1, triX, -ones(1, size(mask,2)));
    end
    
    % keep adding cols
    while(size(mask,2) < 60)        
        mask = cat(2, mask, false(size(mask,1),1));
        triX = cat(2, triX, -ones(size(triX,1),1));
    end    
    
    examples_r = single(zeros(size(mask, 1), size(mask, 2), num_examples_test));
    
    img_curr = zeros(size(mask));
    for e=1:num_examples_test
        
        img_curr(mask) = examples_test(e,:);
        examples_r(:, :, e) = img_curr;
        
    end        
    examples_test = zeros(size(examples_r,1), size(examples_r,2), 1, size(examples_r,3));
    examples_test(:) = single(examples_r(:));    
    
    ids = 1:99:num_examples_test;
    
    errors_all_test = zeros(num_examples_test,1);
    for k=1:numel(ids)-1
        examples_test_sm = single(examples_test(:,:,:,ids(k):ids(k+1)-1));
        res = vl_simplenn(net, examples_test_sm, [], []);
        res = gather(res(end).x);
        [~,res] = sort(res, 3, 'descend') ;
        res = squeeze(res);
        res = res(1,:);

        errors_test_rec = unQuantizeContinuous(res, 0, 3, num_bins)';
        errors_all_test(ids(k):ids(k+1)-1) = errors_test_rec;
    end
    errors_all_test = errors_all_test(1:ids(end));
    corrs_test = corr(errors_all_test, errors_test(1:numel(errors_all_test)));
    rmse_test = sqrt(mean((errors_all_test-errors_test(1:numel(errors_all_test))).^2));

    corrs_all = cat(1, corrs_all, corrs_test);
    rmses_all = cat(1, rmses_all, rmse_test);

    net.corrs = corrs_test;
    net.rmse = rmse_test;
    save([trainOpts.expDir, '/facecnn.mat'], '-struct', 'net');
    
    % The CNN
    faceCheckers(i).cnn = net;
    
    % The orientation
    faceCheckers(i).centres = centres;
    
    % The info for preprocessing    
    faceCheckers(i).mask = mask;
    faceCheckers(i).nPix = nPix;
    faceCheckers(i).minX = minX;
    faceCheckers(i).minY = minY;
    
    faceCheckers(i).destination = shape(:,1:2);        
    tri = load([location faceCheckersLoc_train(i).name], 'triangulation');
    faceCheckers(i).triangulation = tri.triangulation;
    faceCheckers(i).triX = triX;
    faceCheckers(i).mask = mask;
    faceCheckers(i).alphas = alphas;
    faceCheckers(i).betas = betas;
    
    faceCheckers(i).mean_ex = mean_ex;
    faceCheckers(i).std_ex = std_ex;
    
    WriteOutFaceCheckersCNNbinary("trained/validator_cnn.txt", faceCheckers);    
end

save('trained/faceCheckers.mat', 'faceCheckers', 'corrs_all', 'rmses_all');

end
% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
    im = imdb.images.data(:,:,batch) ;
    im = reshape(im, 60, 60, 1, []) ;
    labels = imdb.images.label(1,batch) ;
end

