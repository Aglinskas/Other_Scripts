tic
clear all
loadMR
fn = '/Users/aidasaglinskas/Google Drive/Data/S%d/Functional/Sess%d/swdata.nii'
subs_to_run = subvect;
%% Params
nsess = 5;
TR = 2.5;
analysis_ext = '_check'; % if blank, i.e= '', the folder is Analysis
multi_cond_name = 'sub%drun%d_multicond'; %sub7run1_multicond
%% get the file strcuture
a = strsplit(fn,'%d');
root = a{1};
root_m = root; %for multicond
if strcmp(root(length(root)),'/');
else root = root(1:length(root)-1);
end
disp(['Root:   ' root])
%% Creates the batch file
spm_jobman('initcfg');
clear matlabbatch % clear matlabbatch if one exists
for s = 1:length(subs_to_run)
    clear matlabbatch
    for sess = 1:5%nsess
        subID = subs_to_run(s);
disp(['Creating batch file for sub ' num2str(subID) ' sess ' num2str(sess)])
matlabbatch{1}.spm.stats.fmri_spec.dir = {[root 'S' num2str(subID) '/Analysis' analysis_ext]};
disp(['Analysis for Sub ' num2str(subID) ' Will be placed in ' matlabbatch{1}.spm.stats.fmri_spec.dir{1}]);
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 34;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 17;
for i = 1:length(spm_vol(sprintf(fn,subID,sess)))
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess).scans{i,1} = [sprintf(fn,subID,sess) ',' num2str(i)];
end
disp(['Sub ' num2str(subID) ' Session ' num2str(sess)])
disp(['First Scan ' matlabbatch{1}.spm.stats.fmri_spec.sess(sess).scans{1,1}])
disp(['Last Scan ' matlabbatch{1}.spm.stats.fmri_spec.sess(sess).scans{length(matlabbatch{1}.spm.stats.fmri_spec.sess(sess).scans)}])
%%
matlabbatch{1}.spm.stats.fmri_spec.sess(sess).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(sess).multi = {[root_m num2str(subID) '/' sprintf(multi_cond_name,subID,sess) '.mat']};
disp(['Sub ' num2str(subID) ' Sess ' num2str(sess) ' multicond: ' matlabbatch{1}.spm.stats.fmri_spec.sess(sess).multi{1}])
matlabbatch{1}.spm.stats.fmri_spec.sess(sess).regress = struct('name', {}, 'val', {});
% if movement_params.manual == 1;
%     only_regressor = [root_m num2str(subID) a{2} num2str(sess) '/' movement_params.fln] %addd
%     matlabbatch{1}.spm.stats.fmri_spec.sess(sess).multi_reg = {[root_m num2str(subID) a{2} num2str(sess) '/' only_regressor]};
if length(dir([root_m num2str(subID) a{2} num2str(sess) '/rp*.txt'])) == 1
 only_regressor = dir([root_m num2str(subID) a{2} num2str(sess) '/rp*.txt']);
 only_regressor = only_regressor.name;
matlabbatch{1}.spm.stats.fmri_spec.sess(sess).multi_reg = {[root_m num2str(subID) a{2} num2str(sess) '/' only_regressor]};
disp(['S' num2str(subID) ' Sess ' num2str(sess) ' Regressors: ' [root_m num2str(subID) a{2} num2str(sess) '/' only_regressor]])
elseif length(dir([root_m num2str(subID) a{2} num2str(sess) '/*.txt'])) == 0
    error(['No regressors found, Check yo shiet! Dir:  ' [root_m num2str(subID) a{2} num2str(sess)]])
elseif length(dir([root_m num2str(subID) a{2} num2str(sess) '/*.txt'])) > 1
    error(['Multiple Multiconds found:' ls([root_m num2str(subID) a{2} num2str(sess) '/*.txt'])])
end
%%
%%
matlabbatch{1}.spm.stats.fmri_spec.sess(sess).hpf = 128;
%% other
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.2;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    end
    disp(['Created batch for sub ' num2str(subID)])
    spm_jobman('run',matlabbatch)
end
%%
% 
% 
%     disp('DONE: fMRI model specification for all subs')
% %%   
%     if estimate_right_away == 1
%         disp('Estimating')
%         clear matlabbatch
% for s = 1:length(subs_to_run)
%     %l = (length(matlabbatch))
%     subID = subs_to_run(s)
% matlabbatch{1}.spm.stats.fmri_est.spmmat = {[root 'S' num2str(subID) '/Analysis' analysis_ext '/SPM.mat']};
% matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
% matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
% %spm_jobman('initcfg');
% end
%     end
% spm_jobman('run',matlabbatch)
% toc
%     