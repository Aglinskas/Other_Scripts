clear all;loadMR;matlabbatch = {};
anal_dir = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/BothExpsAnalysis3/'
spm('Defaults','FMRI')
spm_jobman('initcfg')
Subs_to_run = {subvect.face subvect.word}

con_img = 6:17; % which con images to take
%conds = 1:12;
conds = {1:12 13:24}
subAnalFLDR = {'/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/'
    '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/Analysis/'}
con_temp = 'con_00%s.nii,1';
% Self Sufficient code below
if exist(anal_dir) > 0
    delete(fullfile(anal_dir,'*'))    
end
clear matlabbatch
matlabbatch{1}.spm.stats.factorial_design.dir = {anal_dir};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0; %default = 0
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0; % 1 unequal; 0 equal
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'Task';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1; %default = 1
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0; % equal variances?
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;

l = 0;
for exp_ind = 1:2;
for i = 1:length(Subs_to_run{exp_ind});
subID = Subs_to_run{exp_ind}(i); l = l+1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(l).scans = arrayfun(@(x) [sprintf(subAnalFLDR{exp_ind},subID) sprintf(con_temp,num2str(x,'%0.2u'))],con_img,'UniformOutput',0)';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(l).conds = conds{exp_ind};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(l).scans;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(l).conds;
end % ends sub loop
end %ends exp loop

matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2; % main effects and interactions
%matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 1;

%matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 2;
%matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [1 2];                                                                          
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
save('/Users/aidasaglinskas/Desktop/w.mat','matlabbatch');
%% Estimate
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'All Face > Monuments';
%matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [ones(1,11) -11];
%matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

% Slice in a an f Con
% matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'F_contrast_ALL';
% matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = eye(max(conds));
% matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';

%matlabbatch{3}.spm.stats.con.consess{2}.fcon.name = 'Cog vs FaceCC';
%matlabbatch{3}.spm.stats.con.consess{2}.fcon.weights = [ones(1,10) -10];
%matlabbatch{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
%spm_jobman('initcfg')


spm_jobman('run',matlabbatch)