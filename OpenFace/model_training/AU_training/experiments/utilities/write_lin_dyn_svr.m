function [ success ] = write_lin_dyn_svr( location, means, w, b, cutoff)
%WRITE_LIN_SVR Summary of this function goes here
%   Detailed explanation goes here

    fileID = fopen(location, 'w');

    if(fileID ~= -1)
        
        % Write the regressor type 1 - linear dynamic SVR
        fwrite(fileID, 1, 'uint');
        
        fwrite(fileID, cutoff, 'float64');
        
        writeMatrixBin(fileID, means, 6);
        writeMatrixBin(fileID, w, 6);
        fwrite(fileID, b, 'float64');
                
        fclose(fileID);
        
        success = true;
        
    else
        success = false; 
    end
    
end

