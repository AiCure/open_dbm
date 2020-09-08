function [ Similarities, B_without_beta, B_without_beta_flat, y_B_y ] = CalculateSimilarities( n_sequences, x, similarityFNs, sparsityFNs, y, const)
%CALCULATESIMILARITIES Summary of this function goes here
%   Detailed explanation goes here

    K = numel(similarityFNs);
    K2 = numel(sparsityFNs);
    
    %calculate similarity measures for each of the sequences
    Similarities = cell(n_sequences, 1);
    B_without_beta = cell(n_sequences,1);
    B_without_beta_flat = cell(n_sequences,1);
    
    y_B_y = zeros(n_sequences, K + K2);
    
    if(~const)
        
        similarities = cell(K, 1);
        sparsities = cell(K2, 1);

        % y can either be in cell format (diff length seqs.) or in matrix
        %, same length seqs
        beg_ind = 1;        
        
        if(iscell(y))
            end_ind = numel(y{1});
            y_cell = true;
        else
            end_ind = size(y,1);
            y_cell = false;
        end

        for q = 1 : n_sequences
                      
            % don't take the bias term
            xq = x(2:end, beg_ind:end_ind);

            sample_length = end_ind - beg_ind + 1;
            
            Similarities{q} = zeros([sample_length, sample_length, K+K2]);
            
            B_without_beta{q} = cell(K+K2,1);

            B_without_beta_flat{q} = zeros((sample_length*(sample_length+1))/2,K+K2);
            
            % go over all of the similarity metrics and construct the
            % similarity matrices

            if(y_cell)
                yq = y{q};
            else
                yq = y(:,q);
            end
            for k=1:K
                
                if(q==1)
                    similarities{k} = similarityFNs{k}(xq');
                end
                
                Similarities{q}(:,:,k) = similarities{k};
                S = Similarities{q}(:,:,k);
                D =  diag(sum(S));
                
                B_without_beta{q}{k} = D - S;
                B = D - S;
                
                B_without_beta_flat{q}(:,k) = B(logical(tril(ones(size(S)))));
   
                y_B_y(q,k) = -yq'*B*yq;

            end
            
            for k=1:K2
                
                % this is constant so don't need to recalc
                if(q==1)
                   sparsities{k} = sparsityFNs{k}(xq');
                end
                
                Similarities{q}(:,:,K+k) = sparsities{k};
                S = Similarities{q}(:,:,K+k);
                D =  diag(sum(S));
                
                B_without_beta{q}{K+k} = D + S;
                B = D +  S;
                
                B_without_beta_flat{q}(:,K+k) = B(logical(tril(ones(size(S)))));
                
                y_B_y(q,K+k) = -yq'*B*yq;

            end

            % Update the references to sequence start/end
            if(q ~= n_sequences)
                beg_ind = end_ind + 1;
                if(iscell(y))
                    end_ind = end_ind + numel(y{q+1});
                else
                    end_ind = end_ind + size(y,1);
                end
            end
        end
    else
        sample_length = size(x,2)/n_sequences;

        similarities = cell(K, 1);
        sparsities = cell(K2, 1);
        
        B_without_beta = {cell(K+K2,1)};
        B_without_beta_flat = {zeros((sample_length*(sample_length+1))/2,K+K2)};
        Similarities = {zeros([sample_length, sample_length, K+K2])};
            
        beg_ind = 1;
        end_ind = sample_length;

        % don't take the bias term
        xq = x(2:end, beg_ind:end_ind);

        % go over all of the similarity metrics and construct the
        % similarity matrices
        for k=1:K
            similarities{k} = similarityFNs{k}(xq');

            Similarities{1}(:,:,k) = similarities{k};
            
            S = Similarities{1}(:,:,k);
            D =  diag(sum(S));
                        
            B_without_beta{1}{k} = D - S;
            
            B = D - S;
            % flatten the symmetric matrix to save space
            B_without_beta_flat{1}(:,k) = B(logical(tril(ones(size(S)))));

            y_B_y(:,k) = diag(-y'*B*y);

        end
        for k=1:K2
            % this is constant so don't need to recalc
            sparsities{k} = sparsityFNs{k}(xq');

            Similarities{1}(:,:,K+k) = sparsities{k};
            S = Similarities{1}(:,:,K+k);
            D =  diag(sum(S));
            
            B_without_beta{1}{K+k} = D + S;
            B = D + S;

            B_without_beta_flat{1}(:,K+k) = B(logical(tril(ones(size(S)))));
  
            y_B_y(:,K+k) = diag(-y'*B*y);

        end   
    end
end

