clear;
version = '0.4.1';

out_x86 = sprintf('OpenFace_%s_win_x86_landmarks', version);
out_x64 = sprintf('OpenFace_%s_win_x64_landmarks', version);

mkdir(out_x86);
mkdir(out_x64);

in_x86 = '../../Release/';
in_x64 = '../../x64/Release/';

% Copy models
copyfile([in_x86, 'AU_predictors'], [out_x86, '/AU_predictors'])
rmdir([ out_x86, '/AU_predictors/svm_combined'], 's');
rmdir([ out_x86, '/AU_predictors/svr_combined'], 's');
copyfile([in_x86, 'classifiers'], [out_x86, '/classifiers'])
copyfile([in_x86, 'model'], [out_x86, '/model'])

copyfile([in_x64, 'AU_predictors'], [out_x64, '/AU_predictors'])
rmdir([ out_x64, '/AU_predictors/svm_combined'], 's');
rmdir([ out_x64, '/AU_predictors/svr_combined'], 's');
copyfile([in_x64, 'classifiers'], [out_x64, '/classifiers'])
copyfile([in_x64, 'model'], [out_x64, '/model'])

%% Copy libraries
libs_x86 = dir([in_x86, '*.lib'])';

for lib = libs_x86
   
    copyfile([in_x86, '/', lib.name], [out_x86, '/', lib.name])
    
end

libs_x64 = dir([in_x64, '*.lib'])';

for lib = libs_x64
   
    copyfile([in_x64, '/', lib.name], [out_x64, '/', lib.name])
    
end

%% Copy dlls
dlls_x86 = dir([in_x86, '*.dll'])';

for dll = dlls_x86
   
    copyfile([in_x86, '/', dll.name], [out_x86, '/', dll.name])
    
end

dlls_x64 = dir([in_x64, '*.dll'])';

for dll = dlls_x64
   
    copyfile([in_x64, '/', dll.name], [out_x64, '/', dll.name])
    
end

% Copy zmq dll's
mkdir([out_x64, '/amd64']);
copyfile([in_x64, '/amd64'], [out_x64, '/amd64']);
mkdir([out_x64, '/i386']);
copyfile([in_x64, '/i386'], [out_x64, '/i386']);

mkdir([out_x86, '/amd64']);
copyfile([in_x86, '/amd64'], [out_x86, '/amd64']);
mkdir([out_x86, '/i386']);
copyfile([in_x86, '/i386'], [out_x86, '/i386']);

%% Copy exe's
exes_x86 = dir([in_x86, '*.exe'])';

for exe = exes_x86
   
    copyfile([in_x86, '/', exe.name], [out_x86, '/', exe.name])
    
end

exes_x64 = dir([in_x64, '*.exe'])';

for exe = exes_x64
   
    copyfile([in_x64, '/', exe.name], [out_x64, '/', exe.name])
    
end

%% Copy license and copyright
copyfile('../../Copyright.txt', [out_x86, '/Copyright.txt']);
copyfile('../../OpenFace-license.txt', [out_x86, '/OpenFace-license.txt']);

copyfile('../../Copyright.txt', [out_x64, '/Copyright.txt']);
copyfile('../../OpenFace-license.txt', [out_x64, '/OpenFace-license.txt']);

%% Copy icons etc. needed for GUI
img_x86 = dir([in_x86, '*.ico'])';

for img = img_x86
   
    copyfile([in_x86, '/', img.name], [out_x86, '/', img.name])
    
end

img_x64 = dir([in_x64, '*.ico'])';

for img = img_x64
   
    copyfile([in_x64, '/', img.name], [out_x64, '/', img.name])
    
end

img_x86 = dir([in_x86, '*.png'])';

for img = img_x86
   
    copyfile([in_x86, '/', img.name], [out_x86, '/', img.name])
    
end

img_x64 = dir([in_x86, '*.png'])';

for img = img_x64
   
    copyfile([in_x64, '/', img.name], [out_x64, '/', img.name])
    
end

%% Copy sample images for testing
copyfile('../../samples', [out_x86, '/samples']);
copyfile('../../samples', [out_x64 '/samples']);

%% Test if everything worked by running examples
cd(out_x64);
vid_test = sprintf('FaceLandmarkVid.exe -f samples/default.wmv');
dos(vid_test);
feat_test = sprintf('FeatureExtraction.exe -f samples/default.wmv -verbose');
dos(feat_test);
img_test = sprintf('FaceLandmarkImg.exe -fdir samples -verbose');
dos(img_test);
vid_test = sprintf('FaceLandmarkVidMulti.exe -f samples/multi_face.avi -verbose');
dos(vid_test);
rmdir('processed', 's');

%%
cd('..');
cd(out_x86);
vid_test = sprintf('FaceLandmarkVid.exe -f samples/default.wmv');
dos(vid_test);
feat_test = sprintf('FeatureExtraction.exe -f samples/default.wmv -verbose');
dos(feat_test);
img_test = sprintf('FaceLandmarkImg.exe -fdir samples -verbose');
dos(img_test);
vid_test = sprintf('FaceLandmarkVidMulti.exe -f samples/multi_face.avi -verbose');
dos(vid_test);
rmdir('processed', 's');
cd('..');
