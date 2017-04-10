spm_fn_temp = '/Users/aidasaglinskas/Google Drive/Data/LOSO_data/loso_group_-%d/SPM.mat';
%spm_jobman('initcfg')

sub_ind = 15
spm_fn = sprintf(spm_fn_temp,sub_ind)
subvect(sub_ind)
clear SPM
load(spm_fn)
% for sub_ind = 16
% clear matlabbatch
% spm_fn = sprintf(spm_fn_temp,sub_ind);
% matlabbatch{1}.spm.stats.fmri_est.spmmat = {spm_fn};
% matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
% matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
% spm_jobman('run',matlabbatch);
% end
%%
