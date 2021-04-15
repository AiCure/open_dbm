addpath('../../matlab_runners/Demos');

root1 = "C:\Users\Tadas Baltrusaitis\Documents\OpenFace-CECLM_clean\exe\FeatureExtraction\processed";
root2 = "C:\Users\Tadas Baltrusaitis\Documents\OpenFace-CECLM_clean\x64\Release\processed";

gui_files = dir(sprintf('%s/*.csv', root1));

for i = 1:numel(gui_files)

    table_gui = readtable(sprintf('%s/%s', root1, gui_files(i).name));
    table_console = readtable(sprintf('%s/%s', root2, gui_files(i).name));

    var_names = table_console.Properties.VariableNames;

    for v =1:numel(var_names)
       
        feat_gui = table_gui{:,var_names(v)};
        feat_console = table_console{:,var_names(v)};
        feat_diff = norm(abs(feat_gui - feat_console));
        if(feat_diff > 0.0001)
            fprintf('%s error - %.3f\n', var_names{v}, feat_diff);
        end    
    end

    % Compare the HOG file
    [~,name,~] = fileparts(gui_files(i).name);
    [hog_gui, valid_gui] = Read_HOG_file(sprintf('%s/%s.hog', root1, name));
    [hog_console, valid_console] = Read_HOG_file(sprintf('%s/%s.hog', root2, name));

    feat_diff = norm(abs(hog_gui(:) - hog_console(:)));
    if(feat_diff > 0.0001)
        fprintf('HOG error - %.3f\n', feat_diff);
    end
    
    feat_diff = norm(abs(valid_gui - valid_console));
    if(feat_diff > 0.0001)
        fprintf('Valid error - %.3f\n', feat_diff);
    end   
    
    % Compare the simalign ones
    gui_aligns = dir(sprintf('%s/%s_aligned/*.bmp', root1, name));
    console_aligns = dir(sprintf('%s/%s_aligned/*.bmp', root2, name));
    
    for j=1:numel(gui_aligns)
        gui_align = imread(sprintf('%s/%s_aligned/%s', root1, name, gui_aligns(j).name));
        console_align = imread(sprintf('%s/%s_aligned/%s', root2, name, console_aligns(j).name));
        feat_diff = norm(abs(double(gui_align(:)) - double(console_align(:))));
        if(feat_diff > 0.1)
            fprintf('Aligned error - %.3f\n', feat_diff);
        end   
    
    end
    
end
