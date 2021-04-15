% Run this in order to construct the results table
file_out = fopen('results/300VW_66.txt', 'w');

load('results/300VW_OpenFace.mat');
load('../../matlab_version/experiments_300VW/results/cfss_errors.mat');
load('../../matlab_version/experiments_300VW/results/cfan_errors.mat');
load('../../matlab_version/experiments_300VW/results/drmf_errors.mat');
load('../../matlab_version/experiments_300VW/results/iccr_errors.mat');
load('../../matlab_version/experiments_300VW/results/pocr_errors.mat');

fprintf(file_out, 'Errors with outline (66 points)\n');
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'Method\tcat 1\tcat 2\tcat3\n');
fprintf(file_out, 'CFSS\t%.2f\t%.2f\t%.2f\n', median(cfss_error_66_cat_1)*100, median(cfss_error_66_cat_2)*100, median(cfss_error_66_cat_3)*100);
fprintf(file_out, 'ICCR\t%.2f\t%.2f\t%.2f\n', median(iccr_error_66_cat_1)*100, median(iccr_error_66_cat_2)*100, median(iccr_error_66_cat_3)*100);
fprintf(file_out, 'CFAN\t%.2f\t%.2f\t%.2f\n', median(cfan_error_66_cat_1)*100, median(cfan_error_66_cat_2)*100, median(cfan_error_66_cat_3)*100);
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'OpenFace CLNF\t%.2f\t%.2f\t%.2f\n', median(clnf_error_66_cat_1)*100, median(clnf_error_66_cat_2)*100, median(clnf_error_66_cat_3)*100);
fprintf(file_out, 'OpenFace CE-CLM\t%.2f\t%.2f\t%.2f\n', median(ceclm_error_66_cat_1)*100, median(ceclm_error_66_cat_2)*100, median(ceclm_error_66_cat_3)*100);
fclose(file_out);

file_out = fopen('results/300VW_49.txt', 'w');

fprintf(file_out, 'Errors without outline (49 points)\n');
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'Method\tcat 1\tcat 2\tcat3\n');
fprintf(file_out, 'CFSS\t%.2f\t%.2f\t%.2f\n', median(cfss_error_49_cat_1)*100, median(cfss_error_49_cat_2)*100, median(cfss_error_49_cat_3)*100);
fprintf(file_out, 'ICCR\t%.2f\t%.2f\t%.2f\n', median(iccr_error_49_cat_1)*100, median(iccr_error_49_cat_2)*100, median(iccr_error_49_cat_3)*100);
fprintf(file_out, 'DRMF\t%.2f\t%.2f\t%.2f\n', median(drmf_error_49_cat_1)*100, median(drmf_error_49_cat_2)*100, median(drmf_error_49_cat_3)*100);
fprintf(file_out, 'PO-CR\t%.2f\t%.2f\t%.2f\n', median(pocr_error_49_cat_1)*100, median(pocr_error_49_cat_2)*100, median(pocr_error_49_cat_3)*100);
fprintf(file_out, 'CFAN\t%.2f\t%.2f\t%.2f\n', median(cfan_error_49_cat_1)*100, median(cfan_error_49_cat_2)*100, median(cfan_error_49_cat_3)*100);
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'OpenFace CLNF\t%.2f\t%.2f\t%.2f\n', median(clnf_error_49_cat_1)*100, median(clnf_error_49_cat_2)*100, median(clnf_error_49_cat_3)*100);
fprintf(file_out, 'OpenFace CE-CLM\t%.2f\t%.2f\t%.2f\n', median(ceclm_error_49_cat_1)*100, median(ceclm_error_49_cat_2)*100, median(ceclm_error_49_cat_3)*100);
fclose(file_out);