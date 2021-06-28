# superagers
Code for superagers paper:
1. Data is prepared with vallecas_superagers_v4.m (does also other things, which, by now, may be irrelevant) 
2. Random forests are trained in parallel with
vallecas_superagers_v3_rf_pvalues_7500trees
vallecas_superagers_v3_rf_pvalues_7500trees2
vallecas_superagers_v3_rf_pvalues_7500trees3

each of these scripts does 500 permutations (by default) of RF of 7500 trees. 

The forest from vallecas_superagers_v3_rf_pvalues_7500trees.m
is the one we are evaluating (the non-permuted trees from the other two scripts are discarded)

The data is imputed with median imputation as implemented with knn_imputation_median

The workhorse is treebagger_variable_importance function which computed the permutation based p-values for variable importances. Note that if this is run for 500 permutations with 7500 tress (the defaults), it will take up to 48 to 72 hours to run. 


3. vallecas_superagers_collect_rf_results_imputed.m collects the results of the 3 training scripts and prints some results


