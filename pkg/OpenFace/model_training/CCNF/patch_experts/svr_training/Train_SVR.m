function [w, b] = Train_SVR(samples, labels)
%Train_SVR creating a linear support vector regressor
     
    % liblinear training
    addpath('C:\liblinear\matlab');
      
    % Remove redundant data
    [samples, inds] = unique(samples, 'rows');
    labels = labels(inds,:);
    
    cmd = ['-s 11 -B 1 -q'];
    
    svr_regressor = train(labels, sparse(double(samples)), cmd);

    w = svr_regressor.w(1:end-1)';
    b = svr_regressor.w(end);
    
end