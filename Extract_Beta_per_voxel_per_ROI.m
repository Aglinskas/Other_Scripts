clear all
loadMR
for s_ind = 1:length(subBeta.subvect);
subID = subBeta.subvect(s_ind);
for m_ind = 1:length(masks.nii_files)
disp(sprintf('Running Subject %d/%d Mask %d/%d',s_ind,length(subBeta.subvect),m_ind,length(masks.nii_files)))
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
disp(masks.lbls_nii{m_ind})
%%
all_scans = [];
single_scan = [];
wh_betas = find(repmat([ones(1,12) zeros(1,6)],1,5));
beta_fn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/beta_00%s.nii';
disp('Collecting Betas')
for beta = wh_betas

this_beta_path = sprintf(beta_fn_temp,subID,num2str(beta,'%02i'));
if isempty(all_scans)
all_scans = cosmo_fmri_dataset(this_beta_path,'mask',m_fn);
else
single_scan = cosmo_fmri_dataset(this_beta_path,'mask',m_fn);
all_scans = cosmo_stack({all_scans,single_scan});
end
%%
end
disp('Collected')
%% Average across runs
clear m;
clear t;
clear run_avg
for i = 1:12
t = i:12:60;
m = mean(all_scans.samples(t,:),1);
run_avg(:,i) = m';
end
disp('done')

all_run_avg{s_ind,m_ind} = run_avg;
all_run{s_ind,m_ind} = all_scans.samples;
end
end

save('/Users/aidasaglinskas/Google Drive/Mat_files/RoisxVoxel_extracted_wrkspc')
save('/Users/aidasaglinskas/Google Drive/Mat_files/RoisxVoxel_extracted','all_run_avg','all_run')


voxel_data.run_raw = all_run
voxel_data.run_averaged = all_run_avg
voxel_data.r_labels = masks.nii_files
save('~/Google Drive/Mat_files/Workspace/voxel_data.mat','voxel_data')
%%% SANITY CHECK CODE BELOW



% disp(sprintf('Running Subject %d/%d Mask %d/%d',s_ind,length(subBeta.subvect),m_ind,length(masks.nii_files)))
% 
% disp(masks.lbls_nii{m_ind})
% %
% for subID = subBeta.subvect
% for m_ind = 1:18
% m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
% wh_betas = 1;%find(repmat([ones(1,12) zeros(1,6)],1,5));
% beta_fn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/beta_00%s.nii';
% beta = 1;
% this_beta_path = sprintf(beta_fn_temp,subID,num2str(beta,'%02i'));
% 
% all_scans = cosmo_fmri_dataset(this_beta_path,'mask',m_fn);
% 
% tt = sprintf('Sub %d Mask: '' %s '' has %d voxels',subID,masks.lbls_nii{m_ind},size(all_scans.samples,2));
% disp(tt)
% clear all_scans
% end
% end
% % if isempty(all_scans)
% % isempty(all_scans)
% % all_scans = cosmo_fmri_dataset(this_beta_path,'mask',m_fn);
% % else
% % single_scan = cosmo_fmri_dataset(this_beta_path,'mask',m_fn);
% % all_scans = cosmo_stack({all_scans,single_scan});
% % end
% % end
% %%
% 
% 
% 
% 
% 
% 
% 
% 
% 




