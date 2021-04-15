clear
if(isunix)
    features_exe = '"../../../build/bin/FeatureExtraction"';
else
    features_exe = '"../../../x64/Release/FeatureExtraction.exe"';
end
ck_loc = 'E:\Datasets\ck+\cohn-kanade-images\';

out_loc = 'E:\datasets\face_datasets_processed/ck+';

% Go two levels deep
ck_dirs = dir(ck_loc);
ck_dirs = ck_dirs(3:end);

parfor f1=1:numel(ck_dirs)

    ck_dirs_level_2 = dir([ck_loc, ck_dirs(f1).name]);
    ck_dirs_level_2 = ck_dirs_level_2(3:end);
   
    for f2=1:numel(ck_dirs_level_2)

        if(~isdir([ck_loc, ck_dirs(f1).name, '/', ck_dirs_level_2(f2).name]))
           continue; 
        end       
        
        curr_vid = [ck_loc, ck_dirs(f1).name, '/', ck_dirs_level_2(f2).name];
        
        name = [ck_dirs(f1).name, '_',  ck_dirs_level_2(f2).name];

        command = sprintf('%s -fdir "%s" -out_dir "%s" -of %s -hogalign -pdmparams', features_exe, curr_vid, out_loc, name);
        
        dos(command);
            
    end    
    
end