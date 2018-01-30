loadMR;
%%
t = [];
r_inds = aBeta.trim.r_inds
r_inds = arrayfun(@(x) {x},1:21);
mat = aBeta.mat_raw
for r = 1:length(r_inds)
v1 = squeeze(mean(mean(mat(r_inds{r},1:10,:),2),1));
v2 = squeeze(mean(mean(mat(r_inds{r},[11 12],:),2),1))
v3 = squeeze(mean(mat(r_inds{r},11,:),1));
v4 = squeeze(mean(mat(r_inds{r},12,:),1));
[H,P,CI,STATS] = ttest(v1,v3);
t(r) = STATS.tstat;
%t(r) = P;
end
f = figure(1)
add_numbers_to_mat(t)
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.XTick = 1:length(t);
f.CurrentAxes.XTickLabel = aBeta.r_lbls
f.CurrentAxes.XTickLabelRotation = 45
f.CurrentAxes.CLim = [1.71 1.72]