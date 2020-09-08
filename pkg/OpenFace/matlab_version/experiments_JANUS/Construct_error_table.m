% Run this in order to construct the results table for the CE-CLM paper
Extract_table_results_68;

file_out = fopen('results/IJB-FL_68.txt', 'w');

fprintf(file_out, 'Errors with outline (68 points)\n');
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'Method\tfrontal\tprofile\n');
fprintf(file_out, 'CLNF\t%.2f\t%.2f\n', median(clnf_error_frontal)*100, median(clnf_error_profile)*100);
fprintf(file_out, 'CFAN\t%.2f\t%.2f\n', median(cfan_error_frontal)*100, median(cfan_error_profile)*100);
fprintf(file_out, 'CFSS\t%.2f\t%.2f\n', median(cfss_error_frontal)*100, median(cfss_error_profile)*100);
fprintf(file_out, 'TCDCN\t%.2f\t%.2f\n', median(tcdcn_error_frontal)*100, median(tcdcn_error_profile)*100);
fprintf(file_out, '3DDFA\t%.2f\t%.2f\n', median(error_3ddfa_frontal)*100, median(error_3ddfa_profile)*100);
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'CE-CLM\t%.2f\t%.2f\n', median(ceclm_error_frontal)*100, median(ceclm_error_profile)*100);
fclose(file_out);

Extract_table_results_49;
file_out = fopen('results/IJB-FL_49.txt', 'w');

fprintf(file_out, 'Errors without outline (49 points)\n');
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'Method\tfrontal\tprofile\n');
fprintf(file_out, 'CLNF\t%.2f\t%.2f\n', median(clnf_error_frontal)*100, median(clnf_error_profile)*100);
fprintf(file_out, 'SDM \t%.2f\t%.2f\n', median(sdm_error_frontal)*100, median(sdm_error_profile)*100);
fprintf(file_out, 'CFAN\t%.2f\t%.2f\n', median(cfan_error_frontal)*100, median(cfan_error_profile)*100);
fprintf(file_out, 'DRMF\t%.2f\t%.2f\n', median(drmf_error_frontal)*100, median(drmf_error_profile)*100);
fprintf(file_out, 'CFSS\t%.2f\t%.2f\n', median(cfss_error_frontal)*100, median(cfss_error_profile)*100);
fprintf(file_out, 'PO-CR\t%.2f\t%.2f\n', median(pocr_error_frontal)*100, median(pocr_error_profile)*100);
fprintf(file_out, 'TCDCN\t%.2f\t%.2f\n', median(tcdcn_error_frontal)*100, median(tcdcn_error_profile)*100);
fprintf(file_out, '3DDFA\t%.2f\t%.2f\n', median(error_3ddfa_frontal)*100, median(error_3ddfa_profile)*100);
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'CE-CLM\t%.2f\t%.2f\n', median(ceclm_error_frontal)*100, median(ceclm_error_profile)*100);

fclose(file_out);