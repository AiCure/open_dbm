function [ success ] = write_lin_svr( location, means, w, b)
%WRITE_LIN_SVR Summary of this function goes here
%   Detailed explanation goes here

    fileID = fopen(location, 'w');

    if(fileID ~= -1)
        
        % Write the regressor type 0 - linear SVR
        fwrite(fileID, 0, 'uint');
        
        writeMatrixBin(fileID, means, 6);
        writeMatrixBin(fileID, w, 6);
        fwrite(fileID, b, 'float64');
                
        fclose(fileID);
        
        success = true;
        
    else
        success = false; 
    end
    
end

