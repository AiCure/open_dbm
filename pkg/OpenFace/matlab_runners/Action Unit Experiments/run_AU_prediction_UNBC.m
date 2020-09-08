clear

unbc_loc = 'D:/Datasets/UNBC/Images/';

out_loc = './AU_predictions/out_unbc/';

if(~exist(out_loc, 'dir'))
    mkdir(out_loc);
end

%%
executable = '"../../x64/Release/FeatureExtraction.exe"';

unbc_dirs = {'042-ll042', '043-jh043', '047-jl047', '048-aa048', '049-bm049',...
            '052-dr052', '059-fn059', '064-ak064', '066-mg066', '080-bn080',...
            '092-ch092', '095-tv095', '096-bg096', '097-gf097', '101-mg101',...
            '103-jk103', '106-nm106', '107-hs107', '108-th108', '109-ib109',...
            '115-jy115', '120-kz120', '121-vw121', '123-jh123', '124-dn124'};
        
for f1=1:numel(unbc_dirs)

    if(isdir([unbc_loc, unbc_dirs{f1}]))
        
        unbc_2_dirs = dir([unbc_loc, unbc_dirs{f1}]);
        unbc_2_dirs = unbc_2_dirs(3:end);
        
        f1_dir = unbc_dirs{f1};

        command = [executable ' -asvid -q -no2Dfp -no3Dfp -noMparams -noPose -noGaze '];

        for f2=1:numel(unbc_2_dirs)
            f2_dir = unbc_2_dirs(f2).name;
            if(isdir([unbc_loc, unbc_dirs{f1}]))
                
                curr_vid = [unbc_loc, f1_dir, '/', f2_dir, '/'];

                name = [f1_dir '_' f2_dir];
                output_file = [out_loc name '.au.txt'];
                
                command = cat(2, command, [' -fdir "' curr_vid '" -of "' output_file '"']);
            end
        end
        
        dos(command);
    end
end

%%
addpath('./helpers/');

find_UNBC;

aus_UNBC = [6, 7, 10, 12, 25, 26];

[ labels_gt, valid_ids, filenames] = extract_UNBC_labels(UNBC_dir, unbc_dirs, aus_UNBC);
labels_gt = cat(1, labels_gt{:});

%% Identifying which column IDs correspond to which AU
tab = readtable([out_loc, '042-ll042_ll042t1aaaff.au.txt']);
column_names = tab.Properties.VariableNames;

% As there are both classes and intensities list and evaluate both of them
aus_pred_int = [];

inds_int_in_file = [];

for c=1:numel(column_names)
    if(strfind(column_names{c}, '_r') > 0)
        aus_pred_int = cat(1, aus_pred_int, int32(str2num(column_names{c}(3:end-2))));
        inds_int_in_file = cat(1, inds_int_in_file, c);
    end
end

%%
inds_au_int = zeros(size(aus_UNBC));

for ind=1:numel(aus_UNBC)  
    if(~isempty(find(aus_pred_int==aus_UNBC(ind), 1)))
        inds_au_int(ind) = find(aus_pred_int==aus_UNBC(ind));
    end
end


preds_all_int = [];

for i=1:numel(filenames)
   
    fname = dir([out_loc, '/*', filenames{i}, '.au.txt']);
    fname = fname(1).name;
    
    preds = dlmread([out_loc '/' fname], ',', 1, 0);
    
    % Read all of the intensity AUs
    preds_int = preds(:, inds_int_in_file);
    
    preds_all_int = cat(1, preds_all_int, preds_int);
end

%%
f = fopen('results/UNBC_valid_res_int.txt', 'w');
ints_cccs = zeros(1, numel(aus_UNBC));
for au = 1:numel(aus_UNBC)
    
    [ accuracies, F1s, corrs, ccc, rms, classes ] = evaluate_au_prediction_results( preds_all_int(:, inds_au_int(au)), labels_gt(:,au));
    fprintf(f, 'AU%d results - rms %.3f, corr %.3f, ccc - %.3f\n', aus_UNBC(au), rms, corrs, ccc);  
    ints_cccs(au) = ccc;
end
fclose(f);