function [ correlations, rms, meanCorr, meanRMS, longCorr, longRMS, predictions, gt ] = evaluateCCRFmodel( alphas, betas, x, xOffsets, y, similarityFNs, scaling, verbose, PrecalcBsFlat)
%EVALUATEPRFMODEL Summary of this function goes here
%   Detailed explanation goes here

num_x_plots = 8;
num_y_plots = 10;

total_plots = num_x_plots * num_y_plots;

nExamples = numel(x);

if(nargin < 11)
    [ ~, ~, PrecalcBsFlat, ~ ] = CalculateSimilarities( nExamples, x, similarityFNs);
end
    
correlations = zeros(nExamples, 1);
rms = zeros(nExamples, 1);

% concatenated data for an alternative correlation
y_predConcat = [];
y_trueConcat = [];

for q=1:nExamples
     
    X = x{q};
    
    nFrames = size(X,1);
          
    PrecalcBflat = PrecalcBsFlat{q};
    
    SigmaInv = CalcSigmaCCRFflat(alphas, betas, nFrames, PrecalcBflat);
    b = CalcbCCRF(alphas, x{q});
    y_est = SigmaInv \ b;
    
%     y_est = y_est * scaling + xOffsets(q);
    y_est = y_est * scaling + xOffsets(q);

    R = corrcoef(y_est, y{q});
    correlations(q) = R(1,2);
 
    rms(q) = sqrt( (1/nFrames) * sum((y_est - y{q}).^2) );
    
    y_predConcat = cat(1, y_predConcat, y_est);
    y_trueConcat = cat(1, y_trueConcat, y{q});

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
%         legend('y_{true}','y_{ccrf}');
    
    end   
    
end

meanCorr = mean(correlations); 
meanRMS = mean(rms);
longCorr = corr(y_predConcat, y_trueConcat).^2;
longRMS = sqrt( (1/numel(y_predConcat)) * sum((y_predConcat - y_trueConcat).^2) );

predictions = y_predConcat;
gt = y_trueConcat;

if(verbose)
    figure
    plot([1:numel(y_trueConcat)],y_trueConcat,'g',[1:numel(y_trueConcat)],y_predConcat,'b');
    title(sprintf('C %.2f, R %.2f', longCorr, longRMS));
    set(gca, 'XTick', [], 'YTick', []);
end

end

