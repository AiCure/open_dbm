Scripts for evaluating CE-CLM, CLNF, and CLM methods on the 300VW challenge dataset - https://ibug.doc.ic.ac.uk/resources/300-VW/

To run the models on the data using models trained on 300W + MultiPIE:
- Script_CECLM_300VW_general.m
- Script_CLNF_300VW_general.m

To run CE-CLM model trained on 300W + MultiPIE + Menpo:
- Script_CECLM_300VW_menpo.m

To visualize the results of the models against baselines (using inner face markup - 49, and full face markup - 66):
Display_300VW_results_49.m
Display_300VW_results_66.m

To construct the error table:
Construct_error_table.m

For result computation:
- Generate_baseline_results.m
- Generate_ceclm_results.m

For a fair comparison all the models and baselines are initialized using the bounding boxes from an MTCNN detector every 30 frames. Other frames use the previous detection to initialize.

The best performing model is CE-CLM on 300W + MultiPIE + Menpo.
