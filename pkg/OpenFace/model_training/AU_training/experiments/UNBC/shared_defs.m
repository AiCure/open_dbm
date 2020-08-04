% this is data defined across the experiments (to make sure all of them have same user conventions)

% Defining which AU's we are extracting (all corrs above 0.5)
all_aus = [6, 7, 9, 10, 12, 25, 26];
aus = [6, 7, 9, 10, 12, 25, 26];

addpath('../../data extraction/');

find_UNBC;

features_dir = 'E:\datasets\face_datasets_processed\unbc';