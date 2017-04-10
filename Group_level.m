loadMR

analysis_dir = '~/Google Drive/Data//Group_anal'
files = '~/Google Drive/Data/S%d/Analysis/ess_0001.nii'
subjects = subvect %[10 11 12 13 14 15 17]
%%
matlabbatch{1}.spm.stats.factorial_design.dir = {analysis_dir};
%% Add the scans
% .t1.scans | 
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {};
for s = subjects
  matlabbatch{1}.spm.stats.factorial_design.des.t1.scans{length(matlabbatch{1}.spm.stats.factorial_design.des.t1.scans)+1,1} = [sprintf(files,s) ',1'];
if exist(sprintf(files,s)) == 0
    error(['Not Found ' sprintf(files,s)])
end
end
disp(matlabbatch{1}.spm.stats.factorial_design.des.t1.scans)
% Scans added
%% Other params
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
%% run
%spm_jobman('initcfg')
%spm_jobman('run',matlabbatch)

%% 
%%
% for i = 1:length(spm_vol(sprintf(fn,subID,sess)))
%     matlabbatch{s}.spm.stats.fmri_spec.sess(sess).scans{i,1} = [sprintf(fn,subID,sess) ',' num2str(i)];
% end

% matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
%                                                           '/Volumes/Aidas_HDD/MRI_data/S17/Analysis/ess_0001.nii,1'
%                                                           '/Volumes/Aidas_HDD/MRI_data/S15/Analysis/ess_0001.nii,1'
%                                                           }
