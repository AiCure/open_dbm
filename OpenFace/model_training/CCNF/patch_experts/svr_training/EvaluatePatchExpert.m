function [ rmse, correlation, responses ] = EvaluatePatchExpert( samples, labels, patch_expert, vis)
%EVALUATEPATCHEXPERT Summary of this function goes here
%   Detailed explanation goes here

    if(vis)
        % randomise for display purposes (otherwise samples from same
        % region are next to each other)
        r = randperm(size(samples,1));
        samples = samples(r,:);
        labels = labels(r,:);
    end
    
    w = patch_expert(3:end);

    % calculate the response
    svr_response = (w * samples')';

    % Now that we have the response can compute logit regressor responses
    scaling = patch_expert(1);
    bias = patch_expert(2);
    
    responses = (1 + exp(- (svr_response*scaling + bias))).^-1;
        
    rmse = sqrt(mean((responses - labels).^2));    
    correlation = corr(responses, labels)^2;
    
    % these are very add hoc
    falseNegative = (responses < 0.2) & labels > 0.8;
    falsePositive = (responses > 0.4) & labels < 0.2;
    trueNegative = (responses < 0.1) & labels < 0.1;
    truePositive = (responses > 0.3) & labels > 0.6;
    
    % Visualising the responses
    if(vis)
        subplot(2,2,1)
        maxFN = min([sum(falseNegative),100]);    
        if(maxFN > 0)
            [ false_negatives ] = generateDisplayData( samples(find(falseNegative, maxFN),:));    
            imagesc(false_negatives);
            colormap(gray)
            title('false negatives') 
        else
            imagesc([0]);
        end

        subplot(2,2,2)
        maxFP = min([sum(falsePositive),100]);    
        if(maxFP > 0)
            [ false_positives ] = generateDisplayData( samples(find(falsePositive,maxFP),:));    
            imagesc(false_positives);
            colormap(gray)
            title('false positives') 
        else
            imshow([0]);
        end

        subplot(2,2,3)

        maxTP = min([sum(truePositive),100]);    
        if(maxTP > 0)
            [ true_positives ] = generateDisplayData( samples(find(truePositive,maxTP),:)); 
            imagesc(true_positives);
            colormap(gray)
            title('true positives') 
        else
            imagesc([0]);
        end
        subplot(2,2,4)

        maxTN = min([sum(trueNegative),100]);    
        if(maxTN > 0)
            [ true_negatives ] = generateDisplayData( samples(find(trueNegative,maxTN),:));  
            imagesc(true_negatives);
            colormap(gray)
            title('true negatives') 
        else
            imshow([0]);
        end

        drawnow expose        
    end
end

