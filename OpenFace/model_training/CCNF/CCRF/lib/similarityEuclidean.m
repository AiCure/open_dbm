function SimilarityMatrix = similarityEuclidean(x)
    %spatial distance measure
    Distances = sqrt(pdist(x)+3e-6).^-1; % 0.05 best so far

    SimilarityMatrix = squareform(Distances) + eye(size(x, 1));
     
end

