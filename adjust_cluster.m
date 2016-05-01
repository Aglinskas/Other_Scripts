%% 
% adjust_cluster
% Adjusts cluster size to n top voxels and gives back two variables with coordinates 
% adj_cluster_XYZ and adj_cluster_XYZmm
% It needs a results UI open and a cursor positioned on one of the clusters
% Z values are taken from active contrast
% if cluster_k is not specified in workspace, defaults to 50voxels
if exist('cluster_k')
    else cluster_k = 50; % how many top voxels to restrict to;
end
%cluster_k
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
if cluster_k > length(clust_c)
    warning('cluster_k (%d) is larger than the cluster (%d)\nWill use the size of the cluster (%d)',cluster_k,length(clust_c),length(clust_c))
    top_ind = top(:,2);
else top_ind = top(length(top):-1:length(top)-cluster_k,2);
end
%adj_cluster_XYZmm = clust_c(:,top_ind) % adjusted cluster coordinates;
adj_cluster_XYZ = xSPM.XYZ(:,top_ind);
adj_cluster_XYZmm = xSPM.XYZmm(:,top_ind);
%%
%[adj_cluster_XYZmm' xSPM.Z(:,top_ind)']
% disp('Z vals are floored')
% floor([adj_cluster_XYZmm' xSPM.Z(:,top_ind)'])
% Numbers have to be the same precision, so either the coords will have zeroes or  
%% for sanity checking 
% [xSPM.XYZmm(:,top_ind)' xSPM.Z(:,top_ind)']
%% Most responsive voxels;









%%
%warning({'cluster_k is larger than the cluster, cluster_k is:' num2str(cluster_k) ' Clust size:' num2str(length(clust_c)) 'Will use cluster_k the size of the cluster: ' num2str(length(clust_c))})
%warning(['cluster_k is larger than the cluster, cluster_k is:' num2str(cluster_k) '\n' ' Clust size:' num2str(length(clust_c)) 'Will use cluster_k the size of the cluster: ' num2str(length(clust_c))])






