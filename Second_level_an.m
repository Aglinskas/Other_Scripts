close all 
clear all
%%
%opts_xSPM.spm_path = '/Volumes/Aidas_HDD/MRI_data/Group_anal_m-3_s8n44/SPM.mat'
opts_xSPM.useContrast = 1
opts_xSPM.p_tresh = 0.9999
opts_xSPM.k_extent = 0
opts_xSPM.MC_correction = 'none'
%opts_xSPM.maske_mask = {'/Volumes/Aidas_HDD/MRI_data/Group_anal_m-3_s8n44/conj_a1.nii'}
set_up_xSPM
%
%% Cycle        thruclust
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/'
A = spm_clusters(xSPM.XYZ);
clust = unique(spm_clusters(xSPM.XYZ));
for c = clust
    c
go_to_clust = ceil(median(find(A==c)));
spm_results_ui('SetCoords',xSPM.XYZmm(:,go_to_clust))
KbWait(-1)
% extract_betas
% bb(c,:) = cbeta'
end
%%