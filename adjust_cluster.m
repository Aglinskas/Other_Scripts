%% 
% Adjust cluster gives back two variables 
% adj_cluster_XYZ and adj_cluster_XYZmm
% It needs a results UI open and a cursor positioned on one of the clusters
%
cluster_k = 50; % how many top voxels to restrict to;
cur_coords = spm_results_ui('GetCoords');
[xyz,i,d] = spm_XYZreg('NearestXYZ',cur_coords,xSPM.XYZmm);
cur_coords = spm_results_ui('SetCoords',xyz);
ind = find(xSPM.XYZmm(1,:) == cur_coords(1) & xSPM.XYZmm(2,:) == cur_coords(2) & xSPM.XYZmm(3,:) == cur_coords(3));
% goes by coordinates
%spm_results_ui('GetCoords'),xSPM.XYZmm(:,i));
%spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
all_clust = spm_clusters(xSPM.XYZ);
n_clust = max(all_clust);
j = find(all_clust == all_clust(ind));
clust_c = xSPM.XYZmm(:,j);
clust_z = xSPM.Z(j)';
clust_z(:,2) = j;
clust_z(:,3) = 1:length(clust_z);
top = sortrows(clust_z,1);
top_ind = top(length(top):-1:length(top)-cluster_k,2);
%adj_cluster_XYZmm = clust_c(:,top_ind) % adjusted cluster coordinates;
adj_cluster_XYZ = xSPM.XYZ(:,top_ind);
adj_cluster_XYZmm = xSPM.XYZmm(:,top_ind);
%%
[adj_cluster_XYZmm' xSPM.Z(:,top_ind)']
% disp('Z vals are floored')
% floor([adj_cluster_XYZmm' xSPM.Z(:,top_ind)'])
% Numbers have to be the same precision, so either the coords will have zeroes or  
%% for sanity checking 
% [xSPM.XYZmm(:,top_ind)' xSPM.Z(:,top_ind)']
%% Most responsive voxels;

















