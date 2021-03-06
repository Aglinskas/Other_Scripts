%% ROIs
clear;loadMR;clc;
r_drop = [1 2 5 6 9    10    13    14    19    20]
aBeta.fmat(r_drop,:,:) = [];
aBeta.wmat(r_drop,:,:) = [];
aBeta.r_lbls(r_drop,:,:) = [];
combmat = [mean(aBeta.fmat,3);mean(aBeta.wmat,3)];
elbls = [strrep(aBeta.r_lbls,'.mat','-face');strrep(aBeta.r_lbls,'.mat','-word')];
Z  = linkage(1-get_triu(corr(combmat')),'ward')
[h x perm] = dendrogram(Z,0,'orientation','left','labels',elbls);
make_pretty_dend(h)
%%
clear;loadMR;clc;
r_drop = [];
r_drop = [1 2 5 6 9  10  13 14 19 20]
aBeta.fmat(r_drop,:,:) = []; aBeta.wmat(r_drop,:,:) = []; aBeta.r_lbls(r_drop,:,:) = [];
combmat = [mean(aBeta.fmat,3) mean(aBeta.wmat,3)];
wht = 1:10
elbls = [cellfun(@(x) [x '-Face'],aBeta.t_lbls(wht),'UniformOutput',0);cellfun(@(x) [x '-Word'],aBeta.t_lbls(wht),'UniformOutput',0)];
Z = linkage(get_triu(1-corr(combmat)),'ward');
[h x perm] = dendrogram(Z,'labels',elbls,'orientation','left');
make_pretty_dend(h)
%%