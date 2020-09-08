% A test script on image sequences, making sure grayscale and 16 bit
% sequences work

clear

% The location executable will depend on the OS
if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

% Input file
in_dirs = {'../../samples/image_sequence',...
    '../../samples/image_sequence_gray', ...
    '../../samples/image_sequence_16bit'};

% Where to store the output
output_dir = './processed_features/';

for i=1:numel(in_dirs)
    command = sprintf('%s -fdir "%s" -out_dir "%s" -verbose', executable, in_dirs{i}, output_dir);

    if(isunix)
        unix(command);
    else
        dos(command);
    end
end