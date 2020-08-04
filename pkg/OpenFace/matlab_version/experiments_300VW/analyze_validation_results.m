clear
valid_ids = dir('CECLM_res_validation/*.mat');

regs = zeros(numel(valid_ids),1);
sigmas = zeros(numel(valid_ids),1);
tikhs = zeros(numel(valid_ids),1);
aucs = zeros(numel(valid_ids),1);
for i = 1:numel(valid_ids)
   
    [~, name, ~] = fileparts(valid_ids(i).name);
    
    splits = strsplit(name, '_');
    regs(i) = str2double(splits{2});
    sigmas(i) = str2double(splits{4});
    tikhs(i) =  str2double(splits{6});
    
    load(['CECLM_res_validation/',valid_ids(i).name]);
    aucs(i) = auc(ceclm_error);
end