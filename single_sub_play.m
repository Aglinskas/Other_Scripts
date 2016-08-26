%%
subvect = [7 8 9 10 11 14 15 17 18 19 20 21 22];
subID = 9;
opts_xSPM.spm_path = sprintf('/Volumes/Aidas_HDD/MRI_data/S%d/Analysis_mask02/SPM.mat',subID)
opts_xSPM.mask_which_mask_ind = 0;
set_up_xSPM
%%
spm_results_ui('SetCoords',[42;-46;-23],hReg);