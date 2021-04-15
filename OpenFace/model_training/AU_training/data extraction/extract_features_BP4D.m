clear
if(isunix)
    features_exe = '"../../../build/bin/FeatureExtraction"';
else
    features_exe = '"../../../x64/Release/FeatureExtraction.exe"';
end

find_BP4D;
BP4D_dir = [BP4D_dir '\..\BP4D-training\'];

bp4d_dirs = train_recs;
out_loc = 'E:\datasets\face_datasets_processed\bp4d\train';

parfor f1=1:numel(bp4d_dirs)

    if(isdir([BP4D_dir, bp4d_dirs{f1}]))
        
        bp4d_2_dirs = dir([BP4D_dir, bp4d_dirs{f1}]);
        bp4d_2_dirs = bp4d_2_dirs(3:end);
        
        f1_dir = bp4d_dirs{f1};
        
        for f2=1:numel(bp4d_2_dirs)
            f2_dir = bp4d_2_dirs(f2).name;
            if(isdir([BP4D_dir, bp4d_dirs{f1}]))
                
                curr_vid = [BP4D_dir, f1_dir, '/', f2_dir, '/'];

                name = [f1_dir '_' f2_dir];
               
                command = sprintf('%s -fx 2000 -fy 2000 -fdir "%s" -out_dir "%s" -of %s -hogalign -pdmparams', features_exe, curr_vid, out_loc, name);
                dos(command);
            end
        end
    end
end

bp4d_dirs = devel_recs;
out_loc = 'E:\datasets\face_datasets_processed\bp4d\devel';
parfor f1=1:numel(bp4d_dirs)

    if(isdir([BP4D_dir, bp4d_dirs{f1}]))
        
        bp4d_2_dirs = dir([BP4D_dir, bp4d_dirs{f1}]);
        bp4d_2_dirs = bp4d_2_dirs(3:end);
        
        f1_dir = bp4d_dirs{f1};
        
        for f2=1:numel(bp4d_2_dirs)
            f2_dir = bp4d_2_dirs(f2).name;
            if(isdir([BP4D_dir, bp4d_dirs{f1}]))
                curr_vid = [BP4D_dir, f1_dir, '/', f2_dir, '/'];

                name = [f1_dir '_' f2_dir];
               
                command = sprintf('%s -fx 2000 -fy 2000 -fdir "%s" -out_dir "%s" -of %s -hogalign -pdmparams', features_exe, curr_vid, out_loc, name);
                dos(command);

            end
        end
    end
end