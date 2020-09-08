clear
if(isunix)
    features_exe = '"../../../build/bin/FeatureExtraction"';
else
    features_exe = '"../../../x64/Release/FeatureExtraction.exe"';
end

find_UNBC;
UNBC_dir = [UNBC_dir, '/images/'];
output_dir = 'E:\datasets\face_datasets_processed\unbc';

% Go two levels deep
unbc_dirs = dir(UNBC_dir);
unbc_dirs = unbc_dirs(3:end);

parfor f1=1:numel(unbc_dirs)

    unbc_dirs_level_2 = dir([UNBC_dir, unbc_dirs(f1).name]);
    unbc_dirs_level_2 = unbc_dirs_level_2(3:end);
   
    for f2=1:numel(unbc_dirs_level_2)

        if(~isdir([UNBC_dir, unbc_dirs(f1).name, '/', unbc_dirs_level_2(f2).name]))
           continue; 
        end       
        
        input_dir = [UNBC_dir, unbc_dirs(f1).name, '/', unbc_dirs_level_2(f2).name];
        
        name = [unbc_dirs(f1).name, '_',  unbc_dirs_level_2(f2).name];

        command = sprintf('%s -fdir "%s" -out_dir "%s" -of %s -hogalign -pdmparams -verbose', features_exe, input_dir, output_dir, name );

        dos(command);
            
    end    
    
end