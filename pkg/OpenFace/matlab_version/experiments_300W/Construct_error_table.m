% Run this in order to construct the results table for the CE-CLM paper
Extract_table_results_68;

file_out = fopen('results/300W_68.txt', 'w');

fprintf(file_out, 'Errors with outline (68 points)\n');
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'Method\tcomm\tdiff\n');
fprintf(file_out, 'CLNF\t%.2f\t%.2f\n', median(clnf_error_comm)*100, median(clnf_error_ibug)*100);
fprintf(file_out, 'CFAN\t--- \t%.2f\n', median(cfan_error_ibug)*100);
fprintf(file_out, 'DRMF\t%.2f\t%.2f\n', median(drmf_error_comm)*100, median(drmf_error_ibug)*100);
fprintf(file_out, 'CFSS\t%.2f\t%.2f\n', median(cfss_error_comm)*100, median(cfss_error_ibug)*100);
fprintf(file_out, 'TCDCN\t%.2f\t%.2f\n', median(tcdcn_error_comm)*100, median(tcdcn_error_ibug)*100);
fprintf(file_out, '3DDFA\t%.2f\t%.2f\n', median(error_3ddfa_comm)*100, median(error_3ddfa_ibug)*100);
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'CE-CLM\t%.2f\t%.2f\n', median(ceclm_error_comm)*100, median(ceclm_error_ibug)*100);
fclose(file_out);

Extract_table_results_49;
file_out = fopen('results/300W_49.txt', 'w');

fprintf(file_out, 'Errors without outline (49 points)\n');
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'Method\tcomm\tdiff\n');
fprintf(file_out, 'CLNF\t%.2f\t%.2f\n', median(clnf_error_comm)*100, median(clnf_error_ibug)*100);
fprintf(file_out, 'SDM \t%.2f\t%.2f\n', median(sdm_error_comm)*100, median(sdm_error_ibug)*100);
fprintf(file_out, 'CFAN\t--- \t%.2f\n', median(cfan_error_ibug)*100);
fprintf(file_out, 'DRMF\t%.2f\t%.2f\n', median(drmf_error_comm)*100, median(drmf_error_ibug)*100);
fprintf(file_out, 'CFSS\t%.2f\t%.2f\n', median(cfss_error_comm)*100, median(cfss_error_ibug)*100);
fprintf(file_out, 'TCDCN\t%.2f\t%.2f\n', median(tcdcn_error_comm)*100, median(tcdcn_error_ibug)*100);
fprintf(file_out, '3DDFA\t%.2f\t%.2f\n', median(error_3ddfa_comm)*100, median(error_3ddfa_ibug)*100);
fprintf(file_out, '------------------------------\n');
fprintf(file_out, 'CE-CLM\t%.2f\t%.2f\n', median(ceclm_error_comm)*100, median(ceclm_error_ibug)*100);

fclose(file_out);