% Working out corrections for head pose and model correlations
clear
%%
% first need to run run_clm_head_pose_tests_clnf
if(exist([getenv('USERPROFILE') '/Dropbox/AAM/test data/'], 'file'))
    database_root = [getenv('USERPROFILE') '/Dropbox/AAM/test data/'];    
else
    database_root = 'F:/Dropbox/Dropbox/AAM/test data/';
end
buDir = [database_root, '/bu/uniform-light/'];
resFolderBUclnf_general = [database_root, '/bu/uniform-light/CLMr3/'];
[~, pred_hp_bu, gt_hp_bu, ~, rels_bu] = calcBUerror(resFolderBUclnf_general, buDir);

biwi_dir = '/biwi pose/';
biwi_results_root = '/biwi pose results/';
res_folder_clnf_general = '/biwi pose results//CLMr4/';
[~, pred_hp_biwi, gt_hp_biwi, ~, ~, rels_biwi] = calcBiwiError([database_root res_folder_clnf_general], [database_root biwi_dir]);

ict_dir = ['ict/'];
ict_results_root = ['ict results/'];
res_folder_ict_clnf_general = 'ict results//CLMr4/';
[~, pred_hp_ict, gt_hp_ict, ~, ~, rel_ict] = calcIctError([database_root res_folder_ict_clnf_general], [database_root ict_dir]);

% Finding matching pairs to make sure they are independently distributed?

% 
%%
all_hps = cat(1, pred_hp_bu, pred_hp_biwi, pred_hp_ict);
all_gts = cat(1, gt_hp_bu, gt_hp_biwi, gt_hp_ict);
all_rels = cat(1, rels_bu, rels_biwi, rel_ict);

rel_frames = all_rels > 0.8;

all_err = mean(abs(all_gts - all_hps), 2);

all_hps = all_hps(rel_frames, :);
all_gts = all_gts(rel_frames, :);

% Variation along pitch when others are close to 0
pitch_bins = [-40:5:40];
for p = pitch_bins
    rel_frames = find(abs(all_gts(:,2))<3 & abs(all_gts(:,3))<3 & abs(all_gts(:,1) - p)<3);
    if ~isempty(rel_frames)
        corr_coeff = corr(all_hps(rel_frames,1), all_gts(rel_frames,1));
        fprintf('%d, %.3f\n', numel(rel_frames), corr_coeff);
    end
end

plot(find(abs(all_gts(:,1))<1 & abs(all_gts(:,3))<1));

plot(find(abs(all_gts(:,1))<1 & abs(all_gts(:,2))<1));