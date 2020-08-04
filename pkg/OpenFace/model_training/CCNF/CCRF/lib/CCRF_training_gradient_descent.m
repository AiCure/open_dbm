function [ alphas, betas, scaling, finalLikelihood] = CCRF_training_gradient_descent( nIterations, nExamples, learningRate, threshold, x, y, yUnnormed, masks, alphas, betas, lambda_a, lambda_b, similarityFNs, useIndicators, verbose)
%GRADIENTDESCENTCCRF Performs CCRF gradient descen given the initial state
%and gradient descent parameters
%   Detailed explanation goes here

    if(verbose)
        logLikelihood = zeros(round(nIterations/10)+1, 1);
        alphaTrack = zeros(nIterations, numel(alphas));
        betaTrack = zeros(nIterations, numel(betas));
    end

    logAlphas = log(alphas);
    logBetas = log(betas);

    K = numel(similarityFNs);
    
    %calculate similarity measures for each of the sequences
    Similarities = cell(nExamples, 1);
    PrecalcQ2s = cell(nExamples,1);
    PrecalcQ2sFlat = cell(nExamples,1);
    
    PrecalcYqDs = zeros(nExamples, K);
    
    for q = 1 : nExamples

        yq = y{q};
        xq = x{q};
        mask = masks{q};
        
        n = size(yq, 1);
        Similarities{q} = zeros([n, n, K]);
%         PrecalcQ2s{q} = zeros([n, n, K]);
        PrecalcQ2s{q} = cell(K,1);
%         PrecalcQ2sFlat{q} = cell(K,1);
        PrecalcQ2sFlat{q} = zeros((n*(n+1))/2,K);
        % go over all of the similarity metrics and construct the
        % similarity matrices
        for k=1:K
            Similarities{q}(:,:,k) = similarityFNs{k}(xq, mask);
            S = Similarities{q}(:,:,k);
            D =  diag(sum(S));
            B = D - S;
%             PrecalcQ2s{q}(:,:,k) = B;
            PrecalcQ2s{q}{k} = B;
%             PrecalcQ2sFlat{q}{k} = PrecalcQ2s{q}{k}(logical(tril(ones(size(S)))));
            PrecalcQ2sFlat{q}(:,k) = B(logical(tril(ones(size(S)))));
            PrecalcYqDs(q,k) = -yq'*B*yq;
        end
    end    
    
    %stochastic gradient descent
    for iter = 1 : nIterations
        prevAlphas = alphas;
        prevBetas = betas;        

        for q = 1 : nExamples

            yq = y{q};
            xq = x{q};
            mask = masks{q};

            PrecalcQ2 = PrecalcQ2s{q};
            PrecalcQ2Flat = PrecalcQ2sFlat{q};
            [ logGradientsAlphas, logGradientsBetas] = gradientCCRF(alphas, betas, lambda_a, lambda_b, PrecalcQ2, xq, yq, mask, PrecalcYqDs(q, :), useIndicators, PrecalcQ2Flat);
            
%             [logGradientAlphasAnalytical, logGradientBetasAnalytical] = gradientAnalytical(PrecalcQ2, alphas, betas, lambda, xq, yq, mask);
%  
%             diffInGradientsAlpha = mean(abs(logGradientsAlphas - logGradientAlphasAnalytical));
%             diffInGradientsBeta = mean(abs(logGradientsBetas - logGradientBetasAnalytical));
            
            %update log alpha
            logAlphas = logAlphas + learningRate * logGradientsAlphas;
            alphas = exp(logAlphas);

            %update log beta
            logBetas = logBetas + learningRate * logGradientsBetas;
            betas = exp(logBetas);

            if(verbose)
                %record alpha and beta values for each iteration for debug purposes
                alphaTrack(iter,:) = alphas(:);
                betaTrack(iter,:) = betas;
            end
        end

        %check for convergence 
        if (norm([prevAlphas;prevBetas] - [alphas;betas])/norm([prevAlphas;prevBetas]) < threshold || norm([logGradientsAlphas;logGradientsBetas]) < threshold)
            break;
        end
        
        if(verbose)
            if(mod(iter, 10)==0)
                logLikelihood(iter/10 + 1) = LogLikelihoodCCRF(y, x, masks, alphas, betas, lambda_a, lambda_b, PrecalcQ2sFlat, useIndicators);
                fprintf('Iteration %d; logL %f\n', iter, logLikelihood(iter/10 + 1));
            end
            
        end
    end

    % establish the scaling
    scaling = getScaling(alphas, betas, x, yUnnormed, masks, PrecalcQ2s, useIndicators);

    if(verbose)  
        figure
        subplot(1,3,1)
        plot(betaTrack(1:iter,:));
        title('beta');
        subplot(1,3,2)
        plot(alphaTrack(1:iter,:))
        title('alpha');
        subplot(1,3,3)
        plot(logLikelihood(1:round(iter/10),:))
        title('log likelihood');
        finalLikelihood = LogLikelihoodCCRF(y, x, masks, alphas, betas, lambda_a, lambda_b, PrecalcQ2sFlat, useIndicators);
        fprintf('Final log likelihood at iteration %d; logL %f, learning rate %f\n', iter, finalLikelihood, learningRate);
    else
        finalLikelihood = LogLikelihoodCCRF(y, x, masks, alphas, betas, lambda_a, lambda_b, PrecalcQ2sFlat, useIndicators);
        fprintf('Final log likelihood at iteration %d; logL %f, learning rate %f\n', iter, finalLikelihood, learningRate);
    end
    
end

