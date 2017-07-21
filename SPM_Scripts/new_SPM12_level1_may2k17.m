clear 
temp.root = '/Users/aidasaglinskas/Google Drive/Data_faces/';
temp.functional_scans = '/Users/aidasaglinskas/Google Drive/Data_faces/S%d/Functional/Sess%d/swdata.nii';
temp.analysis_fldr = '/Users/aidasaglinskas/Google Drive/Data_faces/S%d/AnalysisFAM/';
temp.multicond_file = '/Users/aidasaglinskas/Google Drive/Data_faces/S%d/sub%drun%d_multicondFAM.mat';
temp.RP_file = '/Users/aidasaglinskas/Google Drive/Data_faces/S%d/Functional/Sess%d/rp_data.txt';

opts.overwrite = 1;
%spm_jobman('initcfg')
loadMR
for subID = subvect
nsess = 4;
clear matlabbatch
fn.analysis_fldr = sprintf(temp.analysis_fldr,subID);
    if opts.overwrite == 1 & exist(fn.analysis_fldr)>0;
        delete(fullfile(fn.analysis_fldr,'*'));
        rmdir(fn.analysis_fldr)
    end
        matlabbatch{1}.spm.stats.fmri_spec.dir = {fn.analysis_fldr};
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
for sess_ind = 1:nsess
    fn.RP_file = sprintf(temp.RP_file,subID,sess_ind);
    fn.multicond_file = sprintf(temp.multicond_file,subID,subID,sess_ind);
    fn.functional_scans = sprintf(temp.functional_scans,subID,sess_ind);
    fn.numScans = length(spm_vol(fn.functional_scans));
matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).scans = arrayfun(@(x) [fn.functional_scans ',' num2str(x)],1:fn.numScans,'UniformOutput',0)';
matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).multi = {fn.multicond_file};
matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).multi_reg = {fn.RP_file};
matlabbatch{1}.spm.stats.fmri_spec.sess(sess_ind).hpf = 128;
end
%%
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.2;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch)
end% ends subject loop