subID = 18
opts_xSPM.spm_path = sprintf('/Volumes/Aidas_HDD/MRI_data/S%d/Analysis/SPM.mat',subID);
set_up_xSPM
%%
opts_clust.size = 1 % 1 = full, 2 = adjusted
opts_clust.inset = 4
extract_from_adjusted_cluster