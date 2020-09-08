function SimilarityMatrix = similarityGauss(x, sigma, range, mask)
%spatial distance measure, based on exponential decay, creates a matrix of
%similarities

% get the euclidean distance for each pair
if(numel(range) > 0)
Distances = exp(-pdist(x(:,range))/sigma); % 0.05 best so far
else
Distances = exp(-pdist(x)/sigma); % 0.05 best so far    
end
SimilarityMatrix = squareform(Distances);

% invalidate the illegal values from the mask (if at least one element is
% not present in the mask set similarity to 0)
if(numel(mask) ~= 0)    
    invalidInds = sum(mask(:,range),2) < numel(range);

    SimilarityMatrix(invalidInds,:) = 0;
    SimilarityMatrix(:,invalidInds) = 0;
end

SimilarityMatrix = SimilarityMatrix + eye(size(x, 1));

end

