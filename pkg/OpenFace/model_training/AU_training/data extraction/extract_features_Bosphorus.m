clear
if(isunix)
    executable = '"..\..\../build/bin/FaceLandmarkImg"';
else
    executable = '"..\..\../x64/Release/FaceLandmarkImg.exe"';
end

find_Bosphorus;

out_loc = 'E:\datasets\face_datasets_processed/bosph';
Bosphorus_dir = [Bosphorus_dir, 'BosphorusDB/BosphorusDB/'];

% Go two levels deep
bosph_dirs = dir([Bosphorus_dir, 'bs*']);

parfor f1=1:numel(bosph_dirs)
    
    command = executable;

    input_dir = [Bosphorus_dir, bosph_dirs(f1).name];
    command = cat(2, command, [' -fdir "' input_dir '" -out_dir "' out_loc '"']);
    command = cat(2, command, ' -multi_view 1 -wild -pdmparams -hogalign');

    if(isunix)
        unix(command, '-echo')
    else
        dos(command);
    end
                
end