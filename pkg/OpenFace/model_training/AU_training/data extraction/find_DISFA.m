% load all of the data together (for efficiency)
% it will be split up accordingly at later stages
if(exist('F:/datasets/DISFA/', 'file'))
    DISFA_dir = 'F:/datasets/DISFA/';
elseif(exist('D:/Databases/DISFA/', 'file'))        
    DISFA_dir = 'D:/Databases/DISFA/';
elseif(exist('D:\datasets\face_datasets\DISFA/', 'file'))        
    DISFA_dir = 'D:\datasets\face_datasets\DISFA/';    
elseif(exist('D:\Datasets\DISFA/', 'file'))        
    DISFA_dir = 'D:\Datasets\DISFA/';  
elseif(exist('Z:/datasets/DISFA/', 'file'))        
    DISFA_dir = 'Z:/Databases/DISFA/';
elseif(exist('E:/datasets/DISFA/', 'file'))        
    DISFA_dir = 'E:/datasets/DISFA/';
elseif(exist('C:/tadas/DISFA/', 'file'))        
    DISFA_dir = 'C:/tadas/DISFA/';
else
    fprintf('DISFA location not found (or not defined)\n'); 
end

hog_data_dir = [DISFA_dir, '/hog_aligned_rigid/'];

users = {'SN001';
         'SN002';
         'SN003';
         'SN004';
         'SN005';
         'SN006';
         'SN007';
         'SN008';
         'SN009';
         'SN010';
         'SN011';
         'SN012';
         'SN016';
         'SN017';
         'SN018';
         'SN021';
         'SN023';
         'SN024';
         'SN025';
         'SN026';
         'SN027';
         'SN028';
         'SN029';
         'SN030';
         'SN031';
         'SN032';
         'SN013'};
