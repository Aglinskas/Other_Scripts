%% Set up 2 % same as beta array
clear all
close all
loadMR
%load('/Volumes/Aidas_HDD/MRI_data/subvect_full20.mat');
p.subDir = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/'
p.ofn_dir = '/Users/aidasaglinskas/Desktop/MVPA_mats/'
masks.dirfn = '/Users/aidasaglinskas/Google Drive/ROI_masks/Revisited/Independent_ROIs_test5/';
nsubs = length(subvect);

masks.dir = dir([masks.dirfn '*.nii']); 
masks.files = {masks.dir.name}'
masks.labels = masks.files;
masks_trimwhat = {'Trim_Sph_Independent_ROIs_test5 ' '_roi.nii'};
% Make labels
for i = 1:length(masks_trimwhat);
masks.labels = cellfun(@(x) strrep(x,masks_trimwhat{i},''),masks.labels,'UniformOutput',0);
end
% preallocate subbetarray with nans
n_subs = nsubs;
n_tasks = 12;
masks_name = masks;

%% prepare
rois_to_run = 3:length(masks.dir)  %[21 8 9 12]
all_conf(1:length(masks.files),1:max(subvect),1:12,1:12) = 2; 
pairs = nchoosek(1:12,2);
MVPA_output = [];
for which_roi = rois_to_run %1:length(masks.files);
parfor subID = subvect;
single_sub_conf_mat = repmat(2,12,12);
subbetas = dir(sprintf([p.subDir 'beta_*'],subID));
target_betas =  {subbetas(find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)).name}';

for paircomp = 1:length(pairs);
disp(sprintf('Running Roi %d/%d, sub %d, paircomp %d/%d',which_roi,length(rois_to_run),subID,paircomp,length(pairs)))

mask = fullfile(masks.dirfn,masks.files{which_roi});
all_scans = struct;
single_scan  = struct;
which_tasks = pairs(paircomp,:);
%disp(['Pair ' num2str(which_tasks)])
for run = 1:5
for task = which_tasks
single_scan = cosmo_fmri_dataset(fullfile(sprintf(p.subDir,subID),target_betas{task + run*12 - 12}),'mask',mask,'targets',task,'chunks',run);
if run == 1 & task == which_tasks(1);
all_scans=single_scan;else
all_scans = cosmo_stack({all_scans,single_scan});end
%disp(['stacking' num2str(run) '/' num2str(task) ' out of ' '5/12'])
end
end
all_scans.sa.labels = all_scans.sa.targets;
all_scans.sa.labels = arrayfun(@(x) tasks{x},all_scans.sa.labels,'UniformOutput',false);
clear_all_scans = cosmo_remove_useless_data(all_scans);

all_scans = clear_all_scans;
% ds = all_scans;
%% Decoding
%nbrhood = cosmo_spherical_neighborhood(all_scans, 'radius', 10);
measure=@cosmo_crossvalidation_measure;  % pick to classify
opt=struct();
opt.classifier=@cosmo_classify_lda;
opt.partitions=cosmo_nchoosek_partitioner(all_scans,1);
%ds_sa = cosmo_crossvalidation_measure(ds, varargin)
corr_results=cosmo_crossvalidation_measure(all_scans,opt);% ,'nproc',4
corr_results.samples=corr_results.samples-(1/length(unique(all_scans.sa.targets)));

%meanall_corResult{which_roi,subID,paircomp} = mean(corr_results.samples);
%rawall_corResult{which_roi,subID,paircomp} = corr_results;

MVPA_output(which_roi,subID,paircomp) = corr_results.samples;

% MVPA_output(which_roi,subID,pairs(paircomp,1),pairs(paircomp,2)) = corr_results.samples;
% MVPA_output(which_roi,subID,pairs(paircomp,2),pairs(paircomp,1)) = corr_results.samples;
end
end
save([p.ofn_dir datestr(datetime)])
end
disp('All done')