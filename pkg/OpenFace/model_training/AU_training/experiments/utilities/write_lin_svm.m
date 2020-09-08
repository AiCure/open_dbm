function [ success ] = write_lin_svm( location, means, w, b, pos_lbl, neg_lbl)
%WRITE_LIN_SVR Summary of this function goes here
%   Detailed explanation goes here

    fileID = fopen(location, 'w');

    if(fileID ~= -1)
        
        % Write the regressor type 4 - linear SVM
        fwrite(fileID, 4, 'uint');
        
        writeMatrixBin(fileID, means, 6);
        writeMatrixBin(fileID, w, 6);
        fwrite(fileID, b, 'float64');
                
        fwrite(fileID, pos_lbl, 'float64');
        fwrite(fileID, neg_lbl, 'float64');
        
        fclose(fileID);
        
        success = true;
        
    else
        success = false; 
    end
    
end

