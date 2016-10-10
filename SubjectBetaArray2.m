
%% Creates SubjectBetaArray
% returns subBetaArray(Region,Task,Subject)
% Set up MIP w/ defaults of whatever
%% Get the masks to extract betas from:
%load('/Volumes/Aidas_HDD/MRI_data/subvect_full20.mat');
clear all
subvect = [7	8	9	10	11	14	15	17	18	19	20	21	22	24	25	27	28	29	30	31]
nsubs = length(subvect);
masks_dir = '/Users/aidasaglinskas/Google Drive/ROI_masks/Revisited/'%'/Users/aidasaglinskas/Google Drive/MRI_data/Group3_Analysis_mask02/new_masks/';
which_SPM = '/Users/aidasaglinskas/Google Drive/MRI_data/GroupAnalysis_31_6th_Oct/SPM.mat'
masks = dir([masks_dir '*.nii']); masks = {masks([masks.isdir] == 0).name}';
masks_name = masks;
masks_ext = {'may24_' '.nii'};
where_to_save = '/Users/aidasaglinskas/Google Drive/MRI_data/SubBetaArrayTemp.mat' % SubBetaArray and Masks Name
% preallocate subbetarray with nans
n_subs = nsubs;
n_tasks = 12;
%subBetaArray(1:length(masks),1:n_tasks,1:n_subs) = nan;
for i = 1:length(masks_ext);masks_name = cellfun(@(x) strrep(x,masks_ext{i},''),masks_name,'UniformOutput', false);end
masks_name
%%
for which_roi = 1:length(masks);
opts_xSPM.spm_path = which_SPM;
opts_xSPM.mask_mask{4} = fullfile(masks_dir,masks{which_roi});
opts_xSPM.mask_which_mask_ind = 4;
opts_xSPM.k_extent = 0;
set_up_xSPM
%load('/Volumes/Aidas_HDD/MRI_data/master_coords.mat')
% i = find(xSPM.XYZmm(1,:) == c_cor(1) & xSPM.XYZmm(2,:) == c_cor(2) & xSPM.XYZmm(3,:) == c_cor(3));
%% Get Clusters
A = spm_clusters(xSPM.XYZ); 
num_clusters = unique(A);
if num_clusters > 1; warning('split roiz man');which_roi;end
for c = 1;%num_clusters;
c_ind = find(A==c);
% expressive
disp([masks_name{which_roi} ' : ' num2str(length(c_ind)) ' voxels'])
how_many_voxels{which_roi,1} = masks_name{which_roi};
how_many_voxels{which_roi,2} = [num2str(length(c_ind)) ' voxels'];
%
%data = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,[i i+1])); % get all voxels in ROI
all_y_from_this_clust = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,c_ind));% first dim is beta (156), second is voxels in the clust
beta=reshape(all_y_from_this_clust,n_tasks,n_subs,length(c_ind)); % rows for tasks, columns for subs
%%
mean_roi_beta_allSubs = mean(beta,3);
%figure;,bar(mean(mean(beta,3),2)) %third dimesion is voxels, second dimension are people
subBetaArray(which_roi,1:n_tasks,1:n_subs) = reshape(mean_roi_beta_allSubs,1,n_tasks,n_subs);
end
save(where_to_save,'subBetaArray','masks_name')
%save('/Volumes/Aidas_HDD/MRI_data/subBetaArray_22_labels','subBetaArray')
disp('Done')
how_many_voxels
end
% %% get labels
% for c_which = 1:length(master_coords);
% A = spm_clusters(xSPM.XYZ);
% get_mip
% spm_mip_ui('SetCoords',[master_coords{c_which,2:4}],mip);
% [xyzmm,i] = spm_XYZreg('NearestXYZ',...
% spm_results_ui('GetCoords'),xSPM.XYZmm);
% spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
% master_coords_legend(c_which).label = master_coords{c_which};
% master_coords_legend(c_which).spmCluster = A(i)
% master_coords_legend(c_which).putativeClust = c_which;
% master_coords_legend(c_which).myCoords = [master_coords{c_which,2:4}];
% master_coords_legend(c_which).nearestCoords = xyzmm;
% master_coords_legend(c_which).coordIndex = i;
% [~,index] = sortrows([master_coords_legend.spmCluster].'); master_coords_legend = master_coords_legend(index); clear index
% %disp(['Cluster ' num2str(A(i)) ' ' master_coords{c_which}]);
% end
% save('/Volumes/Aidas_HDD/MRI_data/master_coords_legend3','master_coords_legend')
% % extract_from_adjusted_cluster3