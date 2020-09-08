% A demo script that demonstrates how to extract aligned faces from a sequence, 
% also shows how to extract different sized aligned faces

clear

% The location executable will depend on the OS
if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

% Input file
in_file = '../../samples/default.wmv';

% Where to store the output
output_dir = './processed_features/';

img_sizes = [64, 112, 224];

for s=1:numel(img_sizes)
    % This will take file after -f and output all the features to directory
    % after -out_dir, with name after -of
    command = sprintf('%s -f "%s" -out_dir "%s" -simalign -simsize %d -of sample_%d', executable, in_file, output_dir, img_sizes(s), img_sizes(s) );

    if(isunix)
        unix(command);
    else
        dos(command);
    end

    %% Output aligned images
    output_aligned_dir = sprintf('%s/sample_%d_aligned/', output_dir, img_sizes(s));
    img_files = dir([output_aligned_dir, '/*.bmp']);
    imgs = cell(numel(img_files), 1);
    
    assert(numel(imgs) > 0);

    for i=1:numel(img_files)
        imgs{i} = imread([ output_aligned_dir, '/', img_files(i).name]);
    
        assert(size(imgs{i},1) == img_sizes(s) && size(imgs{i},2) == img_sizes(s));
        
        imshow(imgs{i})
        drawnow
    end
end