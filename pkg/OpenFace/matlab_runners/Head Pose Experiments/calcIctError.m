function [meanError, all_rot_preds, all_rot_gts, meanErrors, all_errors, rels_all, seq_ids] = calcIctError(resDir, gtDir)
%CALCICTERROR Summary of this function goes here
%   Detailed explanation goes here

    polhemus = 'polhemusNorm.csv';

    sequences = dir([resDir '*.csv']);

    rotMeanErr = zeros(numel(sequences),3);
    rotRMS = zeros(numel(sequences),3);
    rot = cell(1,numel(sequences));
    rotg = cell(1,numel(sequences));

    rels_all = [];

    seq_ids = {};

    for i = 1:numel(sequences)

        [~, name,~] = fileparts(sequences(i).name);

        fname = [resDir '/' sequences(i).name];
        if(i == 1)
            % First read in the column names
            tab = readtable(fname);
            column_names = tab.Properties.VariableNames;

            confidence_id = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'confidence'));
            rot_ids = cellfun(@(x) ~isempty(x) && x==1, strfind(column_names, 'pose_R'));
        end

        all_params  = dlmread(fname, ',', 1, 0);

        rot{i} = all_params(:, rot_ids);    
        rels = all_params(:, confidence_id);
        
        % the reliabilities of head pose
        rels_all = cat(1, rels_all, rels);
        [txg tyg tzg rxg ryg rzg] =  textread([gtDir name '/'  polhemus], '%f,%f,%f,%f,%f,%f');
        
        rotg{i} = [rxg ryg rzg];
        
        % Correct the first frame so it corresponds to (0,0,0), as slightly
        % different pose might be assumed frontal and this corrects for
        % that
                
        % Work out the correction matrix for ground truth
        rot_corr_gt = Euler2Rot(rotg{i}(1,:));        
        for r_e = 1:size(rotg{i},1)
            rot_curr_gt = Euler2Rot(rotg{i}(r_e,:));
            rot_new_gt = rot_corr_gt' * rot_curr_gt;
            rotg{i}(r_e,:) = Rot2Euler(rot_new_gt);
        end
        
        % Work out the correction matrix for estimates
        rot_corr_est = Euler2Rot(rot{i}(1,:));        
        for r_e = 1:size(rot{i},1)
            rot_curr_est = Euler2Rot(rot{i}(r_e,:));
            rot_new_est = rot_corr_est' * rot_curr_est;
            rot{i}(r_e,:) = Rot2Euler(rot_new_est);
        end
        
        % Convert the ground truth and estimates to degrees
        rot{i} = rot{i} * (180/ pi);
        rotg{i} = rotg{i} * (180/ pi);

        % Now compute the errors
        rotMeanErr(i,:) = mean(abs((rot{i}(:,:)-rotg{i}(:,:))));
        rotRMS(i,:) = sqrt(mean(((rot{i}(:,:)-rotg{i}(:,:))).^2)); 
            
        seq_ids = cat(1, seq_ids, repmat({[name 'ict']}, size(rot{i},1), 1));
            
    end
    allRot = cell2mat(rot');
    allRotg = cell2mat(rotg');
    meanErrors = rotMeanErr;
    meanError = mean(abs((allRot(:,:)-allRotg(:,:))));
    all_errors = abs(allRot-allRotg);
    rmsError = sqrt(mean(((allRot(:,:)-allRotg(:,:))).^2)); 
    errorVariance = var(abs((allRot(:,:)-allRotg(:,:))));  

    all_rot_preds = allRot;
    all_rot_gts = allRotg;
end

