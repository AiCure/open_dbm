if(exist('E:\datasets\FERA_2015\semaine/SEMAINE-Sessions/', 'file'))
    SEMAINE_dir = 'E:\datasets\FERA_2015\semaine/SEMAINE-Sessions/';   
elseif(exist('I:\datasets\FERA_2015\Semaine\SEMAINE-Sessions/', 'file'))
    SEMAINE_dir = 'I:\datasets\FERA_2015\Semaine\SEMAINE-Sessions/';   
elseif(exist('C:\tadas\face_datasets\fera_2015\semaine/SEMAINE-Sessions/', 'file'))
    SEMAINE_dir = 'C:\tadas\face_datasets\fera_2015\semaine/SEMAINE-Sessions/';   
elseif(exist('D:\datasets\face_datasets\fera_2015\semaine\SEMAINE-Sessions/', 'file'))
    SEMAINE_dir = 'D:\datasets\face_datasets\fera_2015\semaine\SEMAINE-Sessions/';
elseif(exist('D:\Datasets\FERA_2015\semaine\SEMAINE-Sessions/', 'file'))
    SEMAINE_dir = 'D:\Datasets\FERA_2015\semaine\SEMAINE-Sessions/';    
elseif(exist('D:/fera_2015/semaine/SEMAINE-Sessions/', 'file'))
    SEMAINE_dir = 'D:/fera_2015/semaine/SEMAINE-Sessions/';
else
    fprintf('DISFA location not found (or not defined)\n'); 
end

if(exist('SEMAINE_dir', 'var'))
    hog_data_dir = 'E:\datasets\face_datasets_processed\semaine/';
end

train_recs = {'rec1', 'rec12', 'rec14', 'rec19', 'rec23', 'rec25', 'rec37', 'rec39', 'rec43', 'rec45', 'rec48', 'rec50', 'rec52', 'rec54', 'rec56', 'rec60'};
devel_recs = {'rec9', 'rec13', 'rec15', 'rec20', 'rec24', 'rec26', 'rec38', 'rec42', 'rec44', 'rec46', 'rec49', 'rec51', 'rec53', 'rec55', 'rec58'};
