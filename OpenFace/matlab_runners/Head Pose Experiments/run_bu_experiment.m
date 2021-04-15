function [output_dir] = run_bu_experiment(bu_dir, verbose, varargin)
   
    if(isunix)
        executable = '"../../build/bin/FeatureExtraction"';
    else
        executable = '"../../x64/Release/FeatureExtraction.exe"';
    end

    output_dir = 'experiments/bu_out/';        

    buFiles = dir([bu_dir '*.avi']);
    
    % Only outputing the pose (-pose)
    command = sprintf('%s -inroot "%s" -out_dir "%s" -fx 500 -fy 500 -cx 160 -cy 120 -pose -vis-track ', executable, bu_dir, output_dir);      
        
    for i=1:numel(buFiles)
        inputFile = [buFiles(i).name];            
        command = cat(2, command, sprintf(' -f "%s" ', inputFile));
    end
        
        
    if(verbose)
        command = cat(2, command, [' -tracked ' outputVideo]);
    end
    
    if(any(strcmp('model', varargin)))
        command = cat(2, command, [' -mloc "', varargin{find(strcmp('model', varargin))+1}, '"']);
    end  
        
    if(isunix)
        unix(command, '-echo')
    else
        dos(command);
    end
    
end