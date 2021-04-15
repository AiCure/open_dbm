% Biwi dataset experiment

if(isunix)
    features_exe = '"../../../build/bin/FeatureExtraction"';
else
    features_exe = '"../../../x64/Release/FeatureExtraction.exe"';
end

find_DISFA;

output_dir = 'E:\datasets\face_datasets_processed\disfa';

DISFA_loc_1 = [DISFA_dir, 'Videos_LeftCamera/'];
DISFA_loc_2 = [DISFA_dir, 'Video_RightCamera/'];

disfa_loc_1_files = dir([DISFA_loc_1, '/*.avi']);
disfa_loc_2_files = dir([DISFA_loc_2, '/*.avi']);

%%
parfor i=1:numel(disfa_loc_1_files)
           
    input_file = [DISFA_loc_1 disfa_loc_1_files(i).name];
    command = sprintf('%s -f "%s" -out_dir "%s" -hogalign -pdmparams', features_exe, input_file, output_dir );
               
    dos(command);
end

%%
parfor i=1:numel(disfa_loc_2_files)
           
    input_file = [DISFA_loc_2 disfa_loc_1_files(i).name];
    command = sprintf('%s -f "%s" -out_dir "%s" -hogalign -pdmparams', features_exe, input_file, output_dir );

end
