function [ gradientParams, SigmaInvs, CholDecomps, Sigmas ] = gradientCCRFFull( params, lambda_a, lambda_b, PrecalcBs, x, y, Precalc_yBys, PrecalcBsFlat)
%GRADIENTPRF Summary of this function goes here
%   Detailed explanation goes here

    nExamples = numel(x);

    numBetas = size(PrecalcBsFlat{1},2);
    numAlphas = numel(params) - numBetas;
    
    alphasInit = params(1:numAlphas);
    betasInit = params(numAlphas+1:end);
    gradientParams = zeros(size(params));
    
    % These might be use to calculate the LogLikelihood, don't want to
    % recompute them
    SigmaInvs = cell(nExamples, 1);
    CholDecomps = cell(nExamples, 1);
    Sigmas = cell(nExamples, 1);
    gradients = zeros(nExamples, numel(params));
    for q = 1 : nExamples

        yq = y{q};
        xq = x{q};

        PrecalcB = PrecalcBs{q};
        PrecalcB_flat = PrecalcBsFlat{q};
        
        [ logGradientsAlphas, logGradientsBetas, SigmaInv, CholDecomp, Sigma ] = gradientCCRF_withoutReg(alphasInit, betasInit, PrecalcB, xq, yq, Precalc_yBys(q, :), PrecalcB_flat);
        SigmaInvs{q} = SigmaInv;
        CholDecomps{q} = CholDecomp;
        Sigmas{q} = Sigma;
        
        gradients(q,:) = [logGradientsAlphas; logGradientsBetas];
    end
    gradientParams = sum(gradients,1)';
    regAlpha = alphasInit * lambda_a;
    regBeta = betasInit * lambda_b;
    gradientParams = gradientParams - [regAlpha; regBeta];
end