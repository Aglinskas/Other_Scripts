%% Set up
%clear all 
loadMR
a = ow
% T matrix calc
tmat = []
for r = 1:size(ow,1)
    for c = 1:size(ow,2)
ve = squeeze(mean(a(r,v(c,:),:),2));
m = squeeze(mean(a(r,v(find([1:size(ow,2)] ~= c),:),:),2));
%m = squeeze(a(r,11,:));
[H,P,CI,STATS] = ttest2(ve,m);
tmat(r,c) = STATS.tstat;
pmat(r,c) = P;
    end
end
% Ordering 
%tmat = tmat(1:,1:5);
%pmat = pmat(subBeta.ord_r,1:5);
% Plotting
lbls = {rl l}
clf
figure(1)
p1 = subplot(1,2,1)
add_numbers_to_mat(tmat,lbls{1},lbls{2})
%p1.FontSize = 16;
ttl = {'T matrix' '2 sample ttest task beta vs Mean of all the other betas'}
title(ttl)
p2 = subplot(1,2,2)
add_numbers_to_mat(pmat,lbls{1},lbls{2})
%p2.FontSize = 16;
title('P matrix')