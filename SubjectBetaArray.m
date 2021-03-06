%% Creates SubjectBetaArray
% returns subBetaArray(Region,Task,Subject)
% Set up MIP w/ defaults of whatever
opts_xSPM.mask_mask{4} = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/Sphere_MASK_combined_roi2.nii'
opts_xSPM.mask_which_mask_ind = 4;
opts_xSPM.k_extent = 0;
set_up_xSPM
%load('/Volumes/Aidas_HDD/MRI_data/master_coords.mat')
% i = find(xSPM.XYZmm(1,:) == c_cor(1) & xSPM.XYZmm(2,:) == c_cor(2) & xSPM.XYZmm(3,:) == c_cor(3));
%% Get Clusters
n_subs = 20;
n_tasks = 24;
A = spm_clusters(xSPM.XYZ); 
num_clusters = unique(A);
for c = num_clusters;
c_ind = find(A==c);
%data = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,[i i+1])); % get all voxels in ROI
all_y_from_this_clust = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,c_ind));% first dim is beta (156), second is voxels in the clust
beta=reshape(all_y_from_this_clust,n_tasks,n_subs,length(c_ind)); % rows for tasks, columns for subs
%%
mean_roi_beta_allSubs = mean(beta,3);
%figure;,bar(mean(mean(beta,3),2)) %third dimesion is voxels, second dimension are people
subBetaArray(c,1:n_tasks,1:n_subs) = reshape(mean_roi_beta_allSubs,1,n_tasks,n_subs);
end
save('/Volumes/Aidas_HDD/MRI_data/subBetaArray3','subBetaArray')
disp('Done')
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