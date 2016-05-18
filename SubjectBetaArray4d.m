%% Creates SubjectBetaArray
Does Not Work YEt
% Set up MIP w/ defaults of whatever
set_up_xSPM
%%
% data = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,i));
% Get Current Coords and Ind 
% [xyzmm,i] =
% spm_XYZreg('NearestXYZ',spm_results_ui('GetCoords'),xSPM.XYZmm) %
% ^ acurate i
% c_cor = spm_results_ui('GetCoords');
% i = find(xSPM.XYZmm(1,:) == c_cor(1) & xSPM.XYZmm(2,:) == c_cor(2) & xSPM.XYZmm(3,:) == c_cor(3));
%% Get Clusters
A = spm_clusters(xSPM.XYZ); 
num_clusters = unique(A);
for c = num_clusters;
c_ind = find(A==c);
%%
%% Real
%data = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,[i i+1])); % get all voxels in ROI
all_y_from_this_clust = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,c_ind));
beta=reshape(all_y_from_this_clust,12,13,length(c_ind)) % rows for tasks, columns for subs
%%
mean_roi_beta_allSubs = mean(beta,3)
%figure;,bar(mean(mean(beta,3),2)) %third dimesion is voxels, second dimension are people
subBetaArray(c,1:12,1:13) = reshape(mean_roi_beta_allSubs,1,12,13);
end
%%
% extract_from_adjusted_cluster3