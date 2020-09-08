Scripts for evaluating CE-CLM, CLNF, and CLM methods on the 300W challenge dataset - https://ibug.doc.ic.ac.uk/resources/300-W/

To run the models on the data using models trained on 300W + MultiPIE:
- Script_CECLM_general.m
- Script_CLNF_general.m
- Script_CLM.m

To run CE-CLM model trained on 300W + MultiPIE + Menpo:
- Script CECLM_menpo.m

To visualize the results of the models against baselines (using inner face markup - 49, and full face markup - 68):
Display_ceclm_results_49.m
Display_ceclm_results_68.m

To construct the error table:
Construct_error_table.m

For a fair comparison all the models and baselines are initialized using the bounding boxes provided by the challenge authors.
