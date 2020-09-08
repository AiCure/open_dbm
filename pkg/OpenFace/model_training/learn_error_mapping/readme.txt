This function allows to learn a better relationship between landmark 
detection likelihoods and the resulting landmark error.

First run:
Script_CECLM_general_cross_data_multi_hyp.m
Script_CECLM_menpo_multi_hyp.m
Script_CECLM_of.m

Then:
learn_error_pred_general.m
learn_error_pred_menpo.m
learn_error_pred_of.m

To use in C++ also generate the early_term_cen_of.txt file using output_corrections.m, this is already generated so no need to re-run it.