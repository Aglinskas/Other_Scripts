loadMR
%%
roi_ind = [18 17 16 15 1 2];
clust1 = [10 9 8 7 18 17];
clust2 = [4 3 14 13 6 5 12 11];

clust1_betas = reshape(keep(:,roi_ind,clust1),20,[]);
clust2_betas = reshape(keep(:,roi_ind,clust2),20,[]);
clust1_betas_mn =  mean(reshape(keep(:,roi_ind,clust1),20,[]),2);
disp({masks_name{[roi_ind clust1]}})
disp(mean(reshape(keep(:,roi_ind,clust1),20,[]),1))
clust2_betas_mn =  mean(reshape(keep(:,roi_ind,clust2),20,[]),2);
disp({masks_name{[roi_ind clust2]}})
disp(mean(reshape(keep(:,roi_ind,clust2),20,[]),1))

[H,P,CI,STATS] = ttest(clust1_betas_mn,clust2_betas_mn);
disp(['T = ' num2str(STATS.tstat)])
disp(['P = ' num2str(P)])