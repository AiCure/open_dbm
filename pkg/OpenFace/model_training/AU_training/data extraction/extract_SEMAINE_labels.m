function [ labels, valid_ids, vid_ids  ] = extract_SEMAINE_labels( SEMAINE_dir, recs, aus )
%EXTRACT_SEMAINE_LABELS Summary of this function goes here
%   Detailed explanation goes here

    % Get the right eaf file

    aus_SEMAINE = [2 12 17 25 28 45];

    inds_to_use = [];
    
    for i=1:numel(aus)
    
        inds_to_use = cat(1, inds_to_use, find(aus_SEMAINE == aus(i)));
        
    end
    
    labels = cell(numel(recs), 1);
    valid_ids = cell(numel(recs), 1);
    vid_ids = zeros(numel(recs), 2);
    
    for i=1:numel(recs)
       
        file = dir([SEMAINE_dir, '/', recs{i}, '/*.eaf']);
        
        vid_ids(i,:) = dlmread([SEMAINE_dir, '/', recs{i}, '.txt'], ' ');
        
        xml_file = [SEMAINE_dir, recs{i}, '\' file.name];
        [root_xml, name_xml, ~] = fileparts(xml_file);
        m_file = [root_xml, name_xml, '.mat'];
            
        if(~exist(m_file, 'file'))            
            activations = ParseSEMAINEAnnotations([SEMAINE_dir, recs{i}, '\' file.name]);
            save(m_file, 'activations');
        else
            load(m_file);
        end
        if(size(activations,1) < vid_ids(i,2))
            vid_ids(i,2) = size(activations,1);
            if(vid_ids(i,2) > 2999)
                vid_ids(i,1) = vid_ids(i,2) - 2999;
            end
        end
        
        labels{i} = activations(vid_ids(i,1)+1:vid_ids(i,2), 1 + inds_to_use);
        
        % all indices in SEMAINE are valid
        valid_ids{i} = ones(size(labels{i},1),1);
        
    end
    
end

