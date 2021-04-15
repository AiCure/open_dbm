function [ SparsityMatrix ] = sparsity_grid( x, side, width, width_end)
%sparsity_grid Summary of this function goes here
%   Detailed explanation goes here
  
    % width and width-end define the start and end for the sparsity (or
    % similarity) grid, allowing to control enforced smoothnes and
    % sparsity/inhibition

    SimilarityMatrix = zeros(side*side);
    for i=1:width
        SimilarityMatrix = (similarity_neighbor_grid_further(x, side, [1,2,3,4], i) | SimilarityMatrix);
    end
    
    SimilarityMatrix_end = zeros(side*side);
    for i=1:width_end
        SimilarityMatrix_end = (similarity_neighbor_grid_further(x, side, [1,2,3,4], i) | SimilarityMatrix_end);
    end
    
    SparsityMatrix = double(SimilarityMatrix_end & (~SimilarityMatrix));
    
    assert(isequal(SparsityMatrix, SparsityMatrix'));
end