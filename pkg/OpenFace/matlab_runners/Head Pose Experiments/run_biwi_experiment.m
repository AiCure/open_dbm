function [output_dir] = run_biwi_experiment(rootDir, biwiDir, verbose, varargin)
% Biwi dataset experiment

if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

output_dir = 'experiments/biwi_out';    

dbSeqDir = dir([rootDir biwiDir]);
dbSeqDir = dbSeqDir(3:end);

output_dir = cat(2, output_dir, '/');

command = sprintf('%s -inroot "%s" -out_dir "%s" -fx 505 -fy 505 -cx 320 -cy 240 -pose -vis-track ', executable, rootDir, output_dir);      
     
if(verbose)
    command = cat(2, command, [' -tracked ' outputVideo]);
end  

if(any(strcmp('model', varargin)))
    command = cat(2, command, [' -mloc "', varargin{find(strcmp('model', varargin))+1}, '"']);
end
    
for i=1:numel(dbSeqDir)    
    inputFile = [biwiDir dbSeqDir(i).name '/colour.avi'];
    command = sprintf('%s -f "%s" -of "%s" ', command, inputFile, dbSeqDir(i).name);
end

if(isunix)
    unix(command, '-echo')
else
    dos(command);
end