function [output_dir] = run_ict_experiment(rootDir, ictDir, verbose, varargin)
%EVALUATEICTDATABASE Summary of this function goes here
%   Detailed explanation goes here

if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

output_dir = 'experiments/ict_out';    

dbSeqDir = dir([rootDir ictDir]);
dbSeqDir = dbSeqDir(3:end);

output_dir = cat(2, output_dir, '/');

command = sprintf('%s -inroot "%s" -out_dir "%s" -fx 535 -fy 536 -cx 327 -cy 241 -pose -vis-track ', executable, rootDir, output_dir);      
     
if(verbose)
    command = cat(2, command, [' -tracked ' outputVideo]);
end  

if(any(strcmp('model', varargin)))
    command = cat(2, command, [' -mloc "', varargin{find(strcmp('model', varargin))+1}, '"']);
end

for i=1:numel(dbSeqDir)
    inputFile = [ictDir dbSeqDir(i).name '/colour undist.avi'];
    command = cat(2, command,  [' -f "' inputFile '" -of "' dbSeqDir(i).name  '" ']);
end
         
if(isunix)
    unix(command, '-echo')
else
    dos(command);
end


end

