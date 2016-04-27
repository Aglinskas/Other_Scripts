%% Set Up SPM
addpath('/Users/aidas_el_cap/Desktop/Other_Scripts/SPM_mip_analysis/')
Setup_SPM_results_init

 %% Local Maximum
    XYZmm= spm_mip_ui('Jump',hMIPax,'nrmax');%glmax/nrmax/nrvox
    
    
%% VOXEL: Plot Contrast estimates from 
Plot_contrast_estimates_for_voxel



%% CLUSTER: Plot Contrast estimates from 
Plot_contrast_estimates_for_Cluster





