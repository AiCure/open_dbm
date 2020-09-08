clear;
load('cen_of_mapping.mat');

fe = fopen('early_term_cen_of.txt', 'w');

for i=1:numel(early_term_params.weights_scale)
    fprintf(fe, '%.3f ', early_term_params.weights_scale(i));
end

for i=1:numel(early_term_params.weights_add)
    fprintf(fe, '%.3f ', early_term_params.weights_add(i));
end

for i=1:numel(early_term_params.cutoffs)
    fprintf(fe, '%.3f ', early_term_params.cutoffs(i));
end

fclose(fe);