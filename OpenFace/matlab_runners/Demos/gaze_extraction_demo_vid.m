clear

if(isunix)
    executable = '"../../build/bin/FeatureExtraction"';
else
    executable = '"../../x64/Release/FeatureExtraction.exe"';
end

output = './processed_features/';
    
in_file = '../../samples/2015-10-15-15-14.avi';

command = sprintf('%s -f "%s" -out_dir "%s" -gaze -verbose', executable, in_file, output);
    
if(isunix)
    unix(command);
else
    dos(command);
end

%% Demonstrating reading the output files
[~, out_filename,~] = fileparts(in_file);
out_filename = sprintf('%s/%s.csv', output, out_filename);

% First read in the column names
tab = readtable(out_filename);
column_names = tab.Properties.VariableNames;

all_params  = dlmread(out_filename, ',', 1, 0);

gaze_angle_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'gaze_angle_'));

gaze = all_params(:,gaze_angle_ids);

plot(gaze(:,1), 'DisplayName', 'Left - right');
hold on;
plot(gaze(:,2), 'DisplayName', 'Up - down');
xlabel('Frame') % x-axis label
ylabel('Angle in radians') % y-axis label
legend('show');
hold off;