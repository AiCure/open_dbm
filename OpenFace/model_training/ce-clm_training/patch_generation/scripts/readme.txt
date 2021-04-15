Scripts for generating random patches to train continuous conditional neural field (CCNF, or alternatively Local Neural Field - LNF) patch experts.

This requires data preparation first (not included with the source code), to prepare the data go to '../data_preparation/readme.txt'.

To generate the patches run:
Generate_Patches_general (using combined data)
Generate_Patches_wild (using in-the-wild data)
Generate_Patches_multi_pie (using multi-pie data)
Generate_Patches_cofw (using cofw data)

By default, the patches will be placed in ./patches/. To change the save location, edit the 'patches_loc' variable in the scripts above.
