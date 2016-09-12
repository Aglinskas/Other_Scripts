loadMR
%%
sortedKeep = keep(:,ord(end:-1:1),ord(end:-1:1));
avgSortedKeep = squeeze(mean(sortedKeep,1));
add_numbers_to_mat(avgSortedKeep,masks_name(ord(end:-1:1)));
%save('/Volumes/Aidas_HDD/MRI_data/sortedKeep.mat','avgSortedKeep','sortedKeep')
%% Manual
%warning('make sure to be working on sorted keep')
clust1 = get_triu2(sortedKeep(:,[1:8],[1:8]));
clust2 = get_triu2(sortedKeep(:,[9:14],[9:14]));
clust3 = get_triu2(sortedKeep(:,[15:18],[15:18]));
% ^ done checked values are good
cross_clust1_2 = sortedKeep(:,[1:8],[9:14]);
cross_clust1_3 = sortedKeep(:,[1:8],[15:18]);
cross_clust2_3 = sortedKeep(:,[15:18],[9:18]);
% Means
mn_clust1 = mean(clust1,2);
mn_clust2 = mean(clust2,2);
mn_clust3 = mean(clust3,2);
mn_cross_clust1_2 = squeeze(mean(mean(cross_clust1_2,2),3));
mn_cross_clust1_3 = squeeze(mean(mean(cross_clust1_3,2),3));
mn_cross_clust2_3 = squeeze(mean(mean(cross_clust2_3,2),3));
%
vec1 = [mn_clust1];
vec2 = [mn_cross_clust1_2 ];

[H,P,CI,STATS] = ttest(mean(vec1,2),mean(vec2,2));
disp(['T val ' num2str(STATS.tstat)])
disp(['P val ' num2str(P)])
if P<.05 
    disp('Yes');
else 
    error('No');
end
%% Semi Manual
%warning('make sure to be working on sorted keep')
clust1_inds = [1:8];
clust2_inds = [9:14];
clust3_inds = [15:18];
%%
clust1 = get_triu2(sortedKeep(:,clust1_inds,clust1_inds));
clust2 = get_triu2(sortedKeep(:,clust2_inds,clust2_inds));
clust3 = get_triu2(sortedKeep(:,clust3_inds,clust3_inds));
% ^ done checked values are good
cross_clust1_2 = sortedKeep(:,clust1_inds,clust2_inds);
cross_clust1_3 = sortedKeep(:,clust1_inds,clust3_inds);
cross_clust2_3 = sortedKeep(:,clust2_inds,clust3_inds);
% Means
mn_clust1 = mean(clust1,2);
mn_clust2 = mean(clust2,2);
mn_clust3 = mean(clust3,2);
mn_cross_clust1_2 = squeeze(mean(mean(cross_clust1_2,2),3));
mn_cross_clust1_3 = squeeze(mean(mean(cross_clust1_3,2),3));
mn_cross_clust2_3 = squeeze(mean(mean(cross_clust2_3,2),3));
% % CALCULATE
vec1 = [mn_clust2];
vec2 = [mn_cross_clust2_3];

[H,P,CI,STATS] = ttest(mean(vec1,2),mean(vec2,2));
disp(['T val ' num2str(STATS.tstat)])
disp(['P val ' num2str(P)])
if P<.05 
    disp('Yes');
else 
    error('No');
end
