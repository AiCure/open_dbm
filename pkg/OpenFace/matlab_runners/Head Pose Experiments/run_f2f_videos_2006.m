executable = '"../../x64/Release/FeatureExtraction.exe"';

outputDir = 'D:\Datasets\face2face\2006_processed/';

% First collect the filenames of the data to be used
input_label_dir = 'D:\Datasets\face2face\rapport-oct-2006-all-transcriptions/';

folds = dir([input_label_dir, '*SES*']);

listener_file_labels = {};
speaker_file_labels = {};

listener_vid_files = {};
speaker_vid_files = {};

speaker_vid_dir = 'D:\Datasets\face2face\rapport-oct-2006-all-movie-speaker/';
listener_vid_dir = 'D:\Datasets\face2face\rapport-oct-2006-all-movie-listener/';
verbose = true;
for i=1:numel(folds)
    
    listener_file = dir([input_label_dir, folds(i).name, '/*.L.nod.eaf']);
    speaker_file = dir([input_label_dir, folds(i).name, '/*.S.nod.eaf']);
            
    if(~isempty(listener_file))
        % Need to find the appropriate video file if it exists
        num = listener_file.name(end-13:end-10);
        vid_file_dir = dir([listener_vid_dir, '/*', num, '*']);
        vid_file = dir([listener_vid_dir, '/', vid_file_dir.name, '/*.mp4']);
        if(~isempty(vid_file))
            listener_vid_files = cat(1, listener_vid_files, [listener_vid_dir, '/', vid_file_dir.name, '/', vid_file.name]);
            listener_file_labels = cat(1, listener_file_labels, [input_label_dir, '/' folds(i).name, '/' listener_file.name]);
        end
    end
    
    if(~isempty(speaker_file))
        num = speaker_file.name(end-13:end-10);
        vid_file_dir = dir([speaker_vid_dir, '/*', num, '*']);
        vid_file = dir([speaker_vid_dir, '/', vid_file_dir.name, '/*.mp4']);
        if(~isempty(vid_file))
            speaker_vid_files = cat(1, speaker_vid_files, [speaker_vid_dir, '/', vid_file_dir.name, '/', vid_file.name]);
            speaker_file_labels = cat(1, speaker_file_labels, [input_label_dir, '/' folds(i).name, '/' speaker_file.name]);
        end
    end
    
end

% file_labels = cat(1, listener_file_labels, speaker_file_labels);
% video_files = cat(1, listener_vid_files, speaker_vid_files);

file_labels = listener_file_labels;
video_files = listener_vid_files;

parfor i=1:numel(file_labels)
    
    [~,short_name,vid_ext] = fileparts(video_files{i});
    
    command = executable;
           
    inputFile = video_files{i};
    outputFile = [outputDir short_name '.txt'];

    outputEaf = [outputDir short_name '.eaf'];
    
    command = cat(2, command, [' -f "' inputFile '" -of "' outputFile  '"']);

    if(verbose)
        outputVideo = [outputDir short_name '.track.avi'];
        command = cat(2, command, [' -ov "' outputVideo '"']);    
    end

    command = cat(2, command, [' -no2Dfp -no3Dfp -noMparams -noAUs -noGaze']);
            
    dos(command);
    
    copyfile(file_labels{i}, outputEaf);
    copyfile(video_files{i}, [outputDir '/' short_name, '.mp4']);
    
end