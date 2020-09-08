function [ SimilarityMatrix ] = similarityNeighbor( x, n, ~)
%similarityNeighbor Create a link for the n'th neighbour

    sz = size(x,1);
    SimilarityMatrix = eye(sz);

    i = 1:sz-n;
    SimilarityMatrix(sub2ind([sz, sz], i+n,i)) = 1;
    SimilarityMatrix(sub2ind([sz, sz], i,i+n)) = 1;
    
    DiagMask = ones(size(x, 1)) - eye(size(x,1));
    SimilarityMatrix = SimilarityMatrix .* DiagMask;
    SimilarityMatrix = SimilarityMatrix + eye(size(x, 1));
    
end