function [ PrecalcYqDs ] = CalculateYqDs( n_sequences, x, similarityFNs, sparsityFNs, y)
%CALCULATESIMILARITIES Summary of this function goes here
%   Detailed explanation goes here

    K = numel(similarityFNs);
    K2 = numel(sparsityFNs);
    
    PrecalcYqDs = zeros(n_sequences, K + K2);
    

    sample_length = size(y,1);

    similarities = cell(K, 1);
    sparsities = cell(K2, 1);

    Similarities = zeros([sample_length, sample_length, K+K2]);

    Bs = zeros([sample_length, sample_length, K+K2]);

    for k=1:K
        similarities{k} = similarityFNs{k}(x);
        Similarities(:,:,k) = similarities{k};
        S = Similarities(:,:,k);
        D =  diag(sum(S));
        Bs(:,:,k) = D - S;

    end    
    
    for k=1:K2
        % this is constant so don't need to recalc
        sparsities{k} = sparsityFNs{k}(x);
        
        Similarities(:,:,K+k) = sparsities{k};
        S = Similarities(:,:,K+k);
        D =  diag(sum(S));
        %             PrecalcQ2s{q}(:,:,k) = D - S;
        Bs(:,:,K+k) = D + S;
        %             PrecalcQ2sFlat{q}{k} = PrecalcQ2s{q}{k}(logical(tril(ones(size(S)))));

    end
    
    for q = 1 : n_sequences

        % go over all of the similarity metrics and construct the
        % similarity matrices
        yq = y(:,q);
   
        for k=1:K+K2
            PrecalcYqDs(q,k) = -yq'*Bs(:,:,k)*yq;                       
        end

    end
end

