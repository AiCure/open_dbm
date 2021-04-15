function [ out_map ] = PReLU( input_maps, PReLU_params )
%PRELU Summary of this function goes here
%   Detailed explanation goes here

    out_map = zeros(size(input_maps));
    if(numel(size(input_maps)) > 2)
        for i=1:size(input_maps,3)
             
            % A more readable but slower version
            % in_map = input_maps(:,:,i,:);
            % in_map(in_map < 0) = in_map(in_map<0) * PReLU_params(i);
            
            % alternative
%             out_map(:,:,i,:) = max(input_maps(:,:,i,:),0) + min(input_maps(:,:,i,:),0)*PReLU_params(i);            

            out_map(:,:,i,:) = input_maps(:,:,i,:) .* (PReLU_params(i) + (1 - PReLU_params(i)) * (input_maps(:,:,i,:) > 0)) ;
        end  
    else
        for i=1:size(input_maps,2)
            in_map = input_maps(:,i);
            in_map(in_map < 0) = in_map(in_map<0) * PReLU_params(i);
            out_map(:,i) = in_map;
        end        
    end 
end

