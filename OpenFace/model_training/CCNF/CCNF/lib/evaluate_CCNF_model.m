function [ correlations, rms, mean_correlation, mean_RMSE, long_correlation, long_RMSE, predictions, gts ] = evaluate_CCNF_model( alphas, betas, thetas, x, y, similarityFNs, sparsityFNs, offset, scaling, verbose, PrecalcQ2sFlat)
%evaluate_CCNF_model Evaluate the trained model on test (or training data)

% For visualising time series predictions
num_x_plots = 8;
num_y_plots = 10;

total_plots = num_x_plots * num_y_plots;

if(iscell(x))        
    num_seqs = numel(x);
    x = cell2mat(x)';
    % add a bias term
    x =  cat(1, ones(1,size(x,2)), x);
else
    % if not a cell it has already been flattened, and is constant
    % (most likely)
    num_seqs = size(y,2);
    
end

% if not sure about const assume it is not
const = false;

if(nargin < 11)
    [ ~, ~, PrecalcQ2sFlat, ~ ] = CalculateSimilarities( num_seqs, x, similarityFNs, sparsityFNs, y, const);
end
    
correlations = zeros(num_seqs, 1);
rms = zeros(num_seqs, 1);

% concatenated data for an alternative correlation
y_predConcat = [];
y_trueConcat = [];

% Predict each sequence
for q=1:num_seqs
     
    if(iscell(y))        
        seq_length = size(y{q},1);
        yq = y{q};
    else
        seq_length = size(y,1);            
        yq = y(:,q);
    end
    
    X = x(:,(q-1)*seq_length+1:q*seq_length);

    h1 = 1./(1 + exp(-thetas * X));
    b = (2 * alphas' * h1)';
          
    PrecalcQ2flat = PrecalcQ2sFlat{q};

    precalc_eye = eye(seq_length);
    precalc_zeros = zeros(seq_length);

    SigmaInv = CalcSigmaCCNFflat(alphas, betas, seq_length, PrecalcQ2flat, precalc_eye, precalc_zeros);
    
    y_est = SigmaInv \ b;

    % Can optionally supply the scaling and offset used on the training
    % labels to be applied inversely
    y_est = y_est/scaling + offset;

    if(numel(y_est) > 1)        
        R = corrcoef(y_est, yq);
        correlations(q) = R(1,2);
    end
    
    rms(q) = sqrt( mean((y_est - yq).^2) );
    
    y_predConcat = cat(1, y_predConcat, y_est);
    y_trueConcat = cat(1, y_trueConcat, yq);

    if(verbose)

        if(mod(q,total_plots) == 1)
            figure;
            remainingPlots = nExamples - q;
            if(remainingPlots < total_plots)
                num_y_plots = ceil(remainingPlots / num_x_plots);            
            end            
        end        
        
        subplot(num_y_plots,num_x_plots,mod(q-1,total_plots)+1);
        t = 1:nFrames;
        plot(t,y{q},'g',t,y_est,'b');
        title(sprintf('C %.2f, R %.2f', correlations(q), rms(q)));
        set(gca, 'XTick', [], 'YTick', []);
    
    end   
    
end

% Compute the error metrics
mean_correlation = mean(correlations); 
mean_RMSE = mean(rms);
long_correlation = corr(y_predConcat, y_trueConcat).^2;

long_RMSE = sqrt(mean((y_predConcat - y_trueConcat).^2));
predictions = y_predConcat;
gts = y_trueConcat;

if(verbose)
    figure
    plot([1:numel(y_trueConcat)],y_trueConcat,'g',[1:numel(y_trueConcat)],y_predConcat,'b');
    title(sprintf('C %.2f, R %.2f', long_correlation, long_RMSE));
    set(gca, 'XTick', [], 'YTick', []);
end

end

