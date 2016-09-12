loadMR
% size(subBetaArray) = subBetaArray(:,:,)
% subBetaArray
%%
%ord = [10 9 8 7 18 17 16 15 2 1 4 3 14 13 6 5 12 11]
roi_ind = [10 9];
clust1 = [8 7];
clust2 = [];
% {masks_name{roi_ind}}'
clust1_betas = reshape(keep(:,roi_ind,clust1),size(keep,1),[]);
clust2_betas = reshape(keep(:,roi_ind,clust2),size(keep,1),[]);
clust1_betas_mn =  mean(reshape(keep(:,roi_ind,clust1),size(keep,1),[]),2);
disp({masks_name{[roi_ind clust1]}})
disp(mean(reshape(keep(:,roi_ind,clust1),size(keep,1),[]),1))
clust2_betas_mn =  mean(reshape(keep(:,roi_ind,clust2),size(keep,1),[]),2);
disp({masks_name{[roi_ind clust2]}})
disp(mean(reshape(keep(:,roi_ind,clust2),size(keep,1),[]),1))

[H,P,CI,STATS] = ttest(clust1_betas_mn,clust2_betas_mn);
disp(['T = ' num2str(STATS.tstat)])
disp(['P = ' num2str(P)])
%% Clust independence
clear c
% c{1} = [ 10     9     8     7];
% c{2} = [8 17 16    15     2     1];
c{3} = [10 9]; 
all_c = [10 9 8 7 18 17 16 15 2 1 4 3 14 13 6 5 12 11];
c{4} = all_c(ismember(all_c,c{3}) == 0);
% Compare clust
c_ind1 = 3;
c_ind2 = 4;
vectc1 = keep(:,c{c_ind1},c{c_ind1});
vect2c1 = get_triu2(vectc1);
mn_vect2c1 = mean(vect2c1,2);

vectc2 = keep(:,c{c_ind2},c{c_ind2});
vect2c2 = get_triu2(vectc2);
mn_vect2c2 = mean(vect2c2,2);

[H,P,CI,STATS] = ttest2(mn_vect2c1,mn_vect2c2);
disp(['T = ' num2str(STATS.tstat)])
disp(['P = ' num2str(P)])
%% ttest clust against 0
c_ind1 = 3;
c_ind2 = 3;
vect = keep(:,c{c_ind1},c{c_ind2});
vect2 = get_triu2(vect);
mn_vect2 = mean(vect2,2);
[H,P,CI,STATS] = ttest(mn_vect2);
disp(['T = ' num2str(STATS.tstat)])
disp(['P = ' num2str(P)])
%% Validity Check - Same thing on sorted keep;
loadMR
sorted_keep = keep(:,ord(end:-1:1),ord(end:-1:1));
%%
clust1 = [2 3]

all_o = [1:18];
others = all_o(ismember(all_o,clust1) == 0);
triu = get_triu2(sorted_keep(:,clust1,clust1));       
%squeeze(mean(sorted_keep(:,clust1,clust1),1)) %debug
vect1 = mean(triu,2);

vect2_prime = sorted_keep(:,clust1,others);
vect2 = squeeze(mean(mean(vect2_prime,2),3));
%squeeze(mean(sorted_keep(:,clust1,others),1)) %debug

[H,P,CI,STATS] = ttest2(vect1,vect2);
disp(['T = ' num2str(STATS.tstat)])
disp(['P = ' num2str(P)])
