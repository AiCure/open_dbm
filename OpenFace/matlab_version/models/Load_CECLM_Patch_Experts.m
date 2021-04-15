function [patches] = Load_CECLM_Patch_Experts( col_patch_dir, col_patch_file)
%LOAD_PATCH_EXPERTS Summary of this function goes here
%   Detailed explanation goes here
   
    colourPatchFiles = dir([col_patch_dir col_patch_file]);
    patches = [];

    % load all of the pathes
    for i=1:numel(colourPatchFiles)
        
        load([col_patch_dir, colourPatchFiles(i).name]);

        patch = struct;
        patch.centers = centers;
        patch.trainingScale = trainingScale;
        patch.visibilities = visiIndex; 
        patch.patch_experts = patch_experts.patch_experts;
        patch.correlations = patch_experts.correlations;
        patch.rms_errors = patch_experts.rms_errors;
        patch.modalities = patch_experts.types;
        patch.multi_modal_types = patch_experts.types;

        patch.type = 'CEN';

        % Knowing what normalisation was performed during training is
        % important for fitting
        patch.normalisationOptionsCol = normalisationOptions;

        if(i==1)
            patches = patch;
        else
            patches = [patches; patch];
        end
                     
    end
    
    if(isempty(patches))
       fprintf("Could not find CEN patch experts, for instructions of how to download them, please visit - https://github.com/TadasBaltrusaitis/OpenFace/wiki/Model-download\n"); 
       ME = MException('cenExperts:modelError', 'Could not find CEN model at location %s, see - https://github.com/TadasBaltrusaitis/OpenFace/wiki/Model-download',[col_patch_dir col_patch_file]);       
       throw(ME);
    end
    
end

