loadMR
aBeta.fmat
%%
ord = [ 1     5     7     8     6    10     2     9     3     4];
r_ind = 11;
a = squeeze(mean(aBeta.fmat(r_ind,ord,:),3));
f = figure(6)
imagesc(a)
aBeta.t_lbls(ord)

f.Color = [1 1 1];
f.CurrentAxes.XColor = [1 1 1];
f.CurrentAxes.YColor = [1 1 1];
f.CurrentAxes.TickDir = 'out';
title({aBeta.r_lbls{r_ind} ' '},'fontsize',16)
%%
a  = mean(acmat{1},3)
a = a(perm,perm)
imagesc(a.^2)
f.CurrentAxes.CLim = [.05 .5]