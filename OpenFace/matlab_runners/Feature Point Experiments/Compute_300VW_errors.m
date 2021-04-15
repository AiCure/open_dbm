%% Gather predictions and ground truth
if(exist('D:\Datasets\300VW_Dataset_2015_12_14\300VW_Dataset_2015_12_14/', 'file'))
    database_root = 'D:\Datasets\300VW_Dataset_2015_12_14\300VW_Dataset_2015_12_14/';    
elseif(exist('E:\datasets\300VW\300VW_Dataset_2015_12_14', 'file'))
    database_root = 'E:\datasets\300VW\300VW_Dataset_2015_12_14';
elseif(exist('/multicomp/datasets/300VW_Dataset_2015_12_14/', 'file'))
    database_root = '/multicomp/datasets/300VW_Dataset_2015_12_14/';
else
    fprintf('Could not find the dataset');
    return;
end

cat_1 = [ 114, 124, 125, 126, 150, 158, 401, 402, 505, 506, 507, 508, 509, 510, 511, 514, 515, 518, 519, 520, 521, 522, 524, 525, 537, 538, 540, 541, 546, 547, 548];
cat_2 = [203, 208, 211, 212, 213, 214, 218, 224, 403, 404, 405, 406, 407, 408, 409, 412, 550, 551, 553];
cat_3 = [410, 411, 516, 517, 526, 528, 529, 530, 531, 533, 557, 558, 559, 562];
in_dirs = cat(2, cat_1, cat_2, cat_3);

d_loc_ceclm = '300VW_experiment/ceclm/';
d_loc_clnf = '300VW_experiment/clnf/';
extra_dir = '300VW_extra';

files_pred = dir([d_loc_ceclm, '/*.csv']);
preds_all_ceclm = [];
preds_all_clnf = [];
confs_ceclm = [];
confs_clnf = [];
gts_all = [];

cat_1_ids = logical([]);
cat_2_ids = logical([]);
cat_3_ids = logical([]);

for i = 1:numel(files_pred)
    [~, name, ~] = fileparts(files_pred(i).name);
    
    fname = [d_loc_ceclm, files_pred(i).name];
    if(i == 1)
        % First read in the column names
        tab = readtable(fname);
        column_names = tab.Properties.VariableNames;

        confidence_id = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'confidence'));
        x_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'x_'));
        y_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'y_'));
    end

    all_params  = dlmread(fname, ',', 1, 0);
    
    xs = all_params(:, x_ids);
    ys = all_params(:, y_ids);
    conf_ceclm = all_params(:, confidence_id);
    pred_landmarks_ceclm = zeros([size(xs,2), 2, size(xs,1)]);
    pred_landmarks_ceclm(:,1,:) = xs';
    pred_landmarks_ceclm(:,2,:) = ys';
       
    fname = [d_loc_clnf, files_pred(i).name];
    all_params  = dlmread(fname, ',', 1, 0);
    
    xs = all_params(:, x_ids);
    ys = all_params(:, y_ids);
    conf_clnf = all_params(:, confidence_id);
    pred_landmarks_clnf = zeros([size(xs,2), 2, size(xs,1)]);
    pred_landmarks_clnf(:,1,:) = xs';
    pred_landmarks_clnf(:,2,:) = ys';
    
    fps_all = dir([database_root, '/', name, '/annot/*.pts']);
    gt_landmarks = zeros(size(pred_landmarks_ceclm));
    for k = 1:size(fps_all)        
        gt_landmarks_frame = dlmread([database_root, '/', name, '/annot/', fps_all(k).name], ' ', 'A4..B71');
        gt_landmarks(:,:,k) = gt_landmarks_frame;
    end
    
    if(size(pred_landmarks_ceclm,3) ~= size(fps_all) | size(pred_landmarks_clnf,3) ~= size(fps_all))
        fprintf('something wrong at vid %s, fps - %d, ceclm size - %d, clnf size - %d\n', name, size(fps_all,1), size(pred_landmarks_ceclm,3), size(pred_landmarks_clnf,3));
    end
    
    % Remove unreliable frames
    if(exist([extra_dir, '/', name, '.mat'], 'file'))
        load([extra_dir, '/', name, '.mat']);
        gt_landmarks(:,:,int32(error)) = [];
        pred_landmarks_ceclm(:,:,int32(error))=[];
        pred_landmarks_clnf(:,:,int32(error))=[];
        conf_ceclm(int32(error)) = [];
        conf_clnf(int32(error)) = [];
    end

	preds_all_ceclm = cat(3, preds_all_ceclm, pred_landmarks_ceclm);
	preds_all_clnf = cat(3, preds_all_clnf, pred_landmarks_clnf);
    gts_all = cat(3, gts_all, gt_landmarks);
    confs_ceclm = cat(1, confs_ceclm, conf_ceclm);
    confs_clnf = cat(1, confs_clnf, conf_clnf);

    if(find( cat_1 == str2double(name) ))
        cat_1_ids = cat(1, cat_1_ids, true(numel(conf_clnf),1));
        cat_2_ids = cat(1, cat_2_ids, false(numel(conf_clnf),1));
        cat_3_ids = cat(1, cat_3_ids, false(numel(conf_clnf),1));        
    end
    if(find( cat_2 == str2double(name) ))
        cat_1_ids = cat(1, cat_1_ids, false(numel(conf_clnf),1));
        cat_2_ids = cat(1, cat_2_ids, true(numel(conf_clnf),1));
        cat_3_ids = cat(1, cat_3_ids, false(numel(conf_clnf),1));        
    end
    if(find( cat_3 == str2double(name) ))
        cat_1_ids = cat(1, cat_1_ids, false(numel(conf_clnf),1));
        cat_2_ids = cat(1, cat_2_ids, false(numel(conf_clnf),1));
        cat_3_ids = cat(1, cat_3_ids, true(numel(conf_clnf),1));        
    end
    
end
%%

% As ICCR uses only 66 landmarks adapt all the others to the same format
gts_all_66 = gts_all([1:60,62:64,66:end],:,:);
preds_all_ceclm_66 = preds_all_ceclm([1:60,62:64,66:end],:,:);
preds_all_clnf_66 = preds_all_clnf([1:60,62:64,66:end],:,:);

gts_all_49 = gts_all_66(18:end,:,:);
preds_all_ceclm_49 = preds_all_ceclm_66(18:end,:,:);
preds_all_clnf_49 = preds_all_clnf_66(18:end,:,:);

[ceclm_error_66_cat_1, err_pp_clnf] = compute_error( gts_all_66(:,:,cat_1_ids) - 1.0,  preds_all_ceclm_66(:,:,cat_1_ids));
[clnf_error_66_cat_1, err_pp_clnf] = compute_error( gts_all_66(:,:,cat_1_ids) - 1.0,  preds_all_clnf_66(:,:,cat_1_ids));

[ceclm_error_49_cat_1, err_pp_clnf] = compute_error( gts_all_49(:,:,cat_1_ids) - 1.0,  preds_all_ceclm_49(:,:,cat_1_ids));
[clnf_error_49_cat_1, err_pp_clnf] = compute_error( gts_all_49(:,:,cat_1_ids) - 1.0,  preds_all_clnf_49(:,:,cat_1_ids));

[ceclm_error_66_cat_2, err_pp_clnf] = compute_error( gts_all_66(:,:,cat_2_ids) - 1.0,  preds_all_ceclm_66(:,:,cat_2_ids));
[clnf_error_66_cat_2, err_pp_clnf] = compute_error( gts_all_66(:,:,cat_2_ids) - 1.0,  preds_all_clnf_66(:,:,cat_2_ids));

[ceclm_error_49_cat_2, err_pp_clnf] = compute_error( gts_all_49(:,:,cat_2_ids) - 1.0,  preds_all_ceclm_49(:,:,cat_2_ids));
[clnf_error_49_cat_2, err_pp_clnf] = compute_error( gts_all_49(:,:,cat_2_ids) - 1.0,  preds_all_clnf_49(:,:,cat_2_ids));

[ceclm_error_66_cat_3, err_pp_clnf] = compute_error( gts_all_66(:,:,cat_3_ids) - 1.0,  preds_all_ceclm_66(:,:,cat_3_ids));
[clnf_error_66_cat_3, err_pp_clnf] = compute_error( gts_all_66(:,:,cat_3_ids) - 1.0,  preds_all_clnf_66(:,:,cat_3_ids));

[ceclm_error_49_cat_3, err_pp_clnf] = compute_error( gts_all_49(:,:,cat_3_ids) - 1.0,  preds_all_ceclm_49(:,:,cat_3_ids));
[clnf_error_49_cat_3, err_pp_clnf] = compute_error( gts_all_49(:,:,cat_3_ids) - 1.0,  preds_all_clnf_49(:,:,cat_3_ids));

filename = sprintf('results/300VW_OpenFace');
save(filename, 'ceclm_error_66_cat_1', 'ceclm_error_66_cat_2', 'ceclm_error_66_cat_3', 'ceclm_error_49_cat_1', 'ceclm_error_49_cat_2', 'ceclm_error_49_cat_3',...
    'clnf_error_66_cat_1', 'clnf_error_66_cat_2', 'clnf_error_66_cat_3', 'clnf_error_49_cat_1', 'clnf_error_49_cat_2', 'clnf_error_49_cat_3');
