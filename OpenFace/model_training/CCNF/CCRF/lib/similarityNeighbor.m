function [ SimilarityMatrix ] = similarityNeighbor( x, n, range)
%SIMILARITYNEIGHBOR Summary of this function goes here
%   Detailed explanation goes here

    sz = size(x,1);
    SimilarityMatrix = eye(sz);

    i = 1:sz-n;
    SimilarityMatrix(sub2ind([sz, sz], i+n,i)) = 1;
    SimilarityMatrix(sub2ind([sz, sz], i,i+n)) = 1;

    % invalidate the illegal values from the mask (if at least one element is
    % not present in the mask set similarity to 0)
%     if(numel(mask)~=0)
%         invalidInds = sum(mask(:,range),2) < numel(range);
% 
%         SimilarityMatrix(invalidInds,:) = 0;
%         SimilarityMatrix(:,invalidInds) = 0;
%     end
    
    DiagMask = ones(size(x, 1)) - eye(size(x,1));
    SimilarityMatrix = SimilarityMatrix .* DiagMask;
    SimilarityMatrix = SimilarityMatrix + eye(size(x, 1));
    
end