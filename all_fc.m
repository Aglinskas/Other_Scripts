clear all
loadMR
SPM_dir_fn = '/Users/aidasaglinskas/Google Drive/Data/S7/Ana_new/';
sessData_fn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Functional/Sess%d/swdata.nii';
sess_multicond_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/sub%drun%d_multicond_all_faces.mat';
subID = 7;
clear matlabbatch

% Overall Parameters
    matlabbatch{1}.spm.stats.fmri_spec.dir = {SPM_dir_fn};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
% Session loop
for sess_ind = 1:5
sess_data = sprintf(sessData_fn_temp,subID,sess_ind);
sz = spm_vol(sess_data);
sess_scans = arrayfun(@(x) [sess_data ',' num2str(x)],1:size(sz,1),'UniformOutput',0)';
sess_multi = sprintf(sess_multicond_temp,subID,subID,sess_ind);
rep = {['Subject: ' num2str(subID)] ['Sess: ' num2str(sess_ind)] ['Data: ' sess_data] ['Nscans: ' num2str(size(sz,1))] ['From ' sess_scans{1}] ['To: ' sess_scans{end}] ['Multi: ' sess_multi]};
disp(rep')

    matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).scans = sess_scans;
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).multi = {sess_multi};
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).hpf = 128;
    end
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
% Specified, Write SPM mat file 
spm_jobman('run',matlabbatch)
% Estimate 
clear matlabbatch
matlabbatch{1}.spm.stats.fmri_est.spmmat = {[SPM_dir_fn '/SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run',matlabbatch)
%%
SPM_dir_fn = '/Users/aidasaglinskas/Google Drive/Data/S7/Ana_new';
load([SPM_dir_fn '/SPM.mat'])
f = figure(2)
mat = SPM.xX.X;
imagesc(mat)
f.CurrentAxes.XTick = 1:size(mat,2)
f.CurrentAxes.YTick = 1:size(mat,1)
%% Extract Person Betas
loadMR
load([SPM_dir_fn '/SPM.mat'])
bt_fn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/beta_%s.nii';
%%
subID = 7
clear bt
for m_ind = 1:18;
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
disp(sprintf('%d/%d',m_ind,18))
for bt_ind = 1:18
b_str = num2str(bt_ind,'%.4i');
b_fn = sprintf(bt_fn_temp,subID,b_str);
%disp(masks.lbls_nii{m_ind})
ds = cosmo_fmri_dataset(b_fn,'mask',m_fn);
mn = nanmean(ds.samples);
bt(m_ind,bt_ind) = mn;
end
end
%%
figure
add_numbers_to_mat(bt)
%%

subBeta = 
  struct with fields:
 array: [18?12?20 double] % Array of beta values, subBeta(ROIs,Tasks,Betas)
    t_labels: {12?1 cell} % Labels for tasks
    r_labels: {18?1 cell} % Labels for ROIs
     subvect: [7 8 9 10 11 14 15 17 18 19 20 21 22 24 25 27 28 29 30 31] % Index of good subjects
    goodinds: [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18] % Don't know, legacy stuff
       ord_r: [4 5 6 7 15 16 8 9 1 14 3 10 11 2 12 13 17 18] % For ordering Rois in plots
       ord_t: [6 10 2 3 9 8 1 4 5 7] % For ordering tasks in plots



