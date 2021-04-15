Scripts for training continuous conditional neural field (CCNF, or alternatively Local Neural Field - LNF) patch experts.

This requires data preparation first (not included with the source code), to prepare the data go to '../data_preparation/readme.txt'.

To train the patch experts run:
Script_Training_wild.m (using in-the-wild data)
Script_Training_multi_pie (using multi-pie data)
Script_Training_general (using combined data)

To prepare the inner face general patch expert run:
extract_inner.m

The trained patch experts are included in the './trained/' folder, the experts you train might differ slightly based on the version of Matlab used.