function [ Similarities, PrecalcQ2s, PrecalcQ2sFlat, PrecalcYqDs ] = CalculateSimilarities( n_sequences, x, similarityFNs, y)
%CALCULATESIMILARITIES Summary of this function goes here
%   Detailed explanation goes here

    K = numel(similarityFNs);
    
    %calculate similarity measures for each of the sequences
    Similarities = cell(n_sequences, 1);
    PrecalcQ2s = cell(n_sequences,1);
    PrecalcQ2sFlat = cell(n_sequences,1);
    
    PrecalcYqDs = zeros(n_sequences, K);
    
    if(iscell(x))
        for q = 1 : n_sequences

            xq = x{q};

            n = size(xq, 1);
            Similarities{q} = zeros([n, n, K]);
            
            PrecalcQ2s{q} = cell(K,1);

            PrecalcQ2sFlat{q} = zeros((n*(n+1))/2,K);
            % go over all of the similarity metrics and construct the
            % similarity matrices

            if(nargin > 3)
                yq = y{q};
            end

            for k=1:K
                Similarities{q}(:,:,k) = similarityFNs{k}(xq);
                S = Similarities{q}(:,:,k);
                D =  diag(sum(S));
    %             PrecalcQ2s{q}(:,:,k) = D - S;
                PrecalcQ2s{q}{k} = D - S;
                B = D - S;
    %             PrecalcQ2sFlat{q}{k} = PrecalcQ2s{q}{k}(logical(tril(ones(size(S)))));
                PrecalcQ2sFlat{q}(:,k) = B(logical(tril(ones(size(S)))));
                if(nargin > 3)        
                    PrecalcYqDs(q,k) = -yq'*B*yq;
                end
            end
        end
    else
        sample_length = size(x,2)/n_sequences;
        for q = 1 : n_sequences

            beg_ind = (q-1)*sample_length + 1;
            end_ind = q*sample_length;
            
            % don't take the bias term
            xq = x(2:end, beg_ind:end_ind);

            Similarities{q} = zeros([sample_length, sample_length, K]);
            
            PrecalcQ2s{q} = cell(K,1);

            PrecalcQ2sFlat{q} = zeros((sample_length*(sample_length+1))/2,K);
            
            % go over all of the similarity metrics and construct the
            % similarity matrices

            if(nargin > 3)
                yq = y(:,q);
            end

            for k=1:K
                Similarities{q}(:,:,k) = similarityFNs{k}(xq);
                S = Similarities{q}(:,:,k);
                D =  diag(sum(S));
    %             PrecalcQ2s{q}(:,:,k) = D - S;
                PrecalcQ2s{q}{k} = D - S;
                B = D - S;
    %             PrecalcQ2sFlat{q}{k} = PrecalcQ2s{q}{k}(logical(tril(ones(size(S)))));
                PrecalcQ2sFlat{q}(:,k) = B(logical(tril(ones(size(S)))));
                if(nargin > 3)        
                    PrecalcYqDs(q,k) = -yq'*B*yq;
                end
            end
        end        
    end
end

