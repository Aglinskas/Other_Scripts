tic
clear all
loadMR
fn = '/Users/aidasaglinskas/Google Drive/Data/S%d/Functional/Sess%d/swdata.nii'
subs_to_run = 7 %subvect;
%% Params
nsess = 5;
TR = 2.5;
analysis_ext = 'all_faces'; % if blank, i.e= '', the folder is Analysis
multi_cond_name = 'sub%drun%d_multicond_all_faces' %'sub%drun%d_multicond'; %sub7run1_multicond
%% Run forest run
write_the_spms = 1;
estimate_right_away = 1;
%%
%figure_out_nsess.opt = 0; % new thing: if myTrials is in the subject directory, script can figure out how many runs there are;
%figure_out_nsess.myTrials_fn = '%s_Results.mat'; %filename for myTrials
% movement_params.manual = 1;
%           movement_params.fln = 'rp_data.txt';
%% get the file strcuture
a = strsplit(fn,'%d');
root = a{1};
root_m = root; %for multicond
if strcmp(root(length(root)),'/');
else root = root(1:length(root)-1);
end
disp(['Root:   ' root])
%% Multi cond dir
%% Creates the batch file
clear matlabbatch % clear matlabbatch if one exists
for s = 1:length(subs_to_run)
    %clear matlabbatch % may work, may not
    % Sesssions
%     if figure_out_nsess.opt == 1
%         subID = subs_to_run(s)
%      load(sprintf('/Volumes/Aidas_HDD/MRI_data/S%d/S%d_Results.mat',subID,subID));
%     nsess = myTrials(length([myTrials.time_presented])).fmriRun;
%     end
           
    for sess = 1:5%nsess
        subID = subs_to_run(s);
disp(['Creating batch file for sub ' num2str(subID) ' sess ' num2str(sess)])
matlabbatch{s}.spm.stats.fmri_spec.dir = {[root 'S' num2str(subID) '/Analysis' analysis_ext]};
disp(['Analysis for Sub ' num2str(subID) ' Will be placed in ' matlabbatch{s}.spm.stats.fmri_spec.dir{1}]);
matlabbatch{s}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{s}.spm.stats.fmri_spec.timing.RT = TR;
matlabbatch{s}.spm.stats.fmri_spec.timing.fmri_t = 34;
matlabbatch{s}.spm.stats.fmri_spec.timing.fmri_t0 = 17;
%Loop through subjects and sessions nicely;
%% Add the scans (replace the HUGE cell thing)
for i = 1:length(spm_vol(sprintf(fn,subID,sess)))
    matlabbatch{s}.spm.stats.fmri_spec.sess(sess).scans{i,1} = [sprintf(fn,subID,sess) ',' num2str(i)];
end
disp(['Sub ' num2str(subID) ' Session ' num2str(sess)])
disp(['First Scan ' matlabbatch{s}.spm.stats.fmri_spec.sess(sess).scans{1,1}])
disp(['Last Scan ' matlabbatch{s}.spm.stats.fmri_spec.sess(sess).scans{length(matlabbatch{s}.spm.stats.fmri_spec.sess(sess).scans)}])
%%
matlabbatch{s}.spm.stats.fmri_spec.sess(sess).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{s}.spm.stats.fmri_spec.sess(sess).multi = {[root_m num2str(subID) '/' sprintf(multi_cond_name,subID,sess) '.mat']};
disp(['Sub ' num2str(subID) ' Sess ' num2str(sess) ' multicond: ' matlabbatch{s}.spm.stats.fmri_spec.sess(sess).multi{1}])
matlabbatch{s}.spm.stats.fmri_spec.sess(sess).regress = struct('name', {}, 'val', {});
% if movement_params.manual == 1;
%     only_regressor = [root_m num2str(subID) a{2} num2str(sess) '/' movement_params.fln] %addd
%     matlabbatch{s}.spm.stats.fmri_spec.sess(sess).multi_reg = {[root_m num2str(subID) a{2} num2str(sess) '/' only_regressor]};
if length(dir([root_m num2str(subID) a{2} num2str(sess) '/rp*.txt'])) == 1
 only_regressor = dir([root_m num2str(subID) a{2} num2str(sess) '/rp*.txt']);
 only_regressor = only_regressor.name;
matlabbatch{s}.spm.stats.fmri_spec.sess(sess).multi_reg = {[root_m num2str(subID) a{2} num2str(sess) '/' only_regressor]};
disp(['S' num2str(subID) ' Sess ' num2str(sess) ' Regressors: ' [root_m num2str(subID) a{2} num2str(sess) '/' only_regressor]])
elseif length(dir([root_m num2str(subID) a{2} num2str(sess) '/*.txt'])) == 0
    error(['No regressors found, Check yo shiet! Dir:  ' [root_m num2str(subID) a{2} num2str(sess)]])
elseif length(dir([root_m num2str(subID) a{2} num2str(sess) '/*.txt'])) > 1
    error(['Multiple Multiconds found:' ls([root_m num2str(subID) a{2} num2str(sess) '/*.txt'])])
end
%%
%%
matlabbatch{s}.spm.stats.fmri_spec.sess(sess).hpf = 128;
%% other
matlabbatch{s}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{s}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{s}.spm.stats.fmri_spec.volt = 1;
matlabbatch{s}.spm.stats.fmri_spec.global = 'None';
matlabbatch{s}.spm.stats.fmri_spec.mthresh = 0.2;
matlabbatch{s}.spm.stats.fmri_spec.mask = {''};
matlabbatch{s}.spm.stats.fmri_spec.cvi = 'AR(1)';
    end
    disp(['Created batch for sub ' num2str(subID)])
end
%%
if write_the_spms == 1
        disp('Created the batch, running it')
        disp('initcfg')
    spm_jobman('initcfg');
        disp('writing')
    spm_jobman('run',matlabbatch)
else
disp('ALL DONE, when ready run: spm_jobman(''initcfg'');spm_jobman(''run'',matlabbatch)')
end

% spm_jobman('initcfg');
%     spm_jobman('run',matlabbatch)
%     disp('DONE: fMRI model specification for all subs')
%%   
    if estimate_right_away == 1
        disp('Estimating')
        clear matlabbatch
for s = 1:length(subs_to_run)
    %l = (length(matlabbatch))
    subID = subs_to_run(s)
matlabbatch{s}.spm.stats.fmri_est.spmmat = {[root 'S' num2str(subID) '/Analysis' analysis_ext '/SPM.mat']};
matlabbatch{s}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{s}.spm.stats.fmri_est.method.Classical = 1;
end
    end
    spm_jobman('initcfg');
spm_jobman('run',matlabbatch)
toc