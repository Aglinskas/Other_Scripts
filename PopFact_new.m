%cd /Users/aidasaglinskas/Desktop/MRI_data/
anal_dir = '/Users/aidasaglinskas/Desktop/MRI_data/Test_GROUP'
Subs_to_run = subvect
con_img = 4:15; % which con images to take
conds = [1:12]
%% Templates
subAnalFLDR = '/Users/aidasaglinskas/Desktop/MRI_data/S%d/Analysis_mask02/' % TEMPLATE: '/Users/aidasaglinskas/Desktop/MRI_data/S%d/Analysis_mask02/'
con_temp = 'con_00%s.nii,1'; % num2str(10,'%0.2u') %TEMPLATE: 'con_00%s.nii,1'
%% Self Sufficient code below
clear matlabbatch
matlabbatch{1}.spm.stats.factorial_design.dir = {anal_dir};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 1; %default = 0
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'Task';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1; %default = 1
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'Task';
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
for i = 1:length(Subs_to_run);
subID = Subs_to_run(i);
%line = [sprintf(subAnalFLDR,subID) sprintf(con_temp,num2str(con_img,'%0.2u'))]
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).scans = arrayfun(@(x) [sprintf(subAnalFLDR,subID) sprintf(con_temp,num2str(x,'%0.2u'))],con_img,'UniformOutput',0)';                                                                             
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).conds = conds;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).scans;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(i).conds;
end
%%
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 1;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [1
%                                                                                   2];
% matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
% matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
% matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% Estimate
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('initcfg')
spm_jobman('run',matlabbatch)