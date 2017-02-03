loadMR
% Build Structure

p.spm_fn = '/Users/aidasaglinskas/Google Drive/Data/Group_analysis12t/SPM.mat'
single_subj_T1_fn = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii';
load(p.spm_fn)
% Set up the SPM;
% params
xSPM = SPM; % lol
xSPM.Ic = 1; % which contrast
xSPM.Im = {fullfile(masks.dir,masks.nii_files{1})} % mask 
xSPM.Ex = 0;
xSPM.thresDesc = 'none' %threshold type
xSPM.u = 1 % %threshold
xSPM.k = 0 % extent
[hReg,xSPM,SPM] = spm_results_ui('Setup',xSPM) % Set up results
spm_sections(xSPM,hReg,single_subj_T1_fn); % Set up sections
%mip = spm_mip(xSPM.Z,xSPM.XYZmm,xSPM.M,xSPM.units);
spm_mip_ui('Jump')
%
b = spm_mip_ui('Extract', 'beta', 'cluster');
w_t = 1:10;
%y=spm_mip_ui('Extract', 'Y', 'cluster')
%y=spm_mip_ui('Extract', 'beta', 'cluster')
%b = zscore(b,[],2)
%b = zscore(b,[],1)
c = corr(b(w_t,:)');
f = figure(5)

newVec = get_triu(c);
Z = linkage(1-newVec,'ward');
subplot(1,2,2)
[H,T,OUTPERM]= dendrogram(Z,'Labels',subBeta.t_labels(w_t),'orientation','left')

subplot(1,2,1)
add_numbers_to_mat(c(OUTPERM(end:-1:1),OUTPERM(end:-1:1)),subBeta.t_labels(OUTPERM(end:-1:1)))
title(strrep(masks.nii_files{1},'Trim_Sph_good_final',''))



