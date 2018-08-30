t_group = { {'Distinctiveness'    'Attractiveness' } {'First memory' 'Familiarity'} {'How many facts'    'Occupation'} {'Common name'    'Full name' } {'Friendliness'    'Trustworthiness'  }};
t_group_lbls = {'physical' 'episodic' 'semantic' 'nominal' 'social' };

r_group = {{'OFA-L'    'OFA-R'} {'FFA-L'    'FFA-R' } {'pSTS-L'    'pSTS-R' } {'IFG-L' 'IFG-R'} {'OFC-L'    'OFC-R'} {'ATFP-L'    'ATFP-R'} {'Amygdala-L' 'Amygdala-R'} {'ATL-L'    'ATL-R' } {'Angular-L'    'Angular-R'}  {'Precuneus'} {'vmPFC' } {'dmPFC'}};
r_group_lbls = arrayfun(@(x) strrep(r_group{x}{1},'-L',''),1:length(r_group),'UniformOutput',0);

data_mat = aBeta.fmat;
data_mat12x5 = [];

rlbls = aBeta.r_lbls;
tlbls = aBeta.t_lbls;
red = [];

data_mat = aBeta.fmat;
red = []
for r = 1:length(r_group)
for t = 1:length(t_group)
    red(r,t,:) = mean(mean(data_mat(ismember(rlbls,r_group{r}),ismember(tlbls,t_group{t}),:),1),2);
end
end
data_mat_9_5 = red;

data_mat = squeeze(mean(aBeta.fmat,2));
for r = 1:length(r_group)
    red(r,:) = mean(data_mat(ismember(rlbls,r_group{r}),:),1);
end
%% Acess to person knowledge
data_mat = squeeze(mean(aBeta.fmat,2));
[H,P,CI,STATS] = ttest(data_mat');

lbls = aBeta.r_lbls;
mats = {STATS.tstat P}
th = {[1.95 1.96] [.048 .05]}
figure(1);clf;
for i = 1:2
title('Acess to person knowledge','Fontsize',20)
sp = subplot(2,1,i);
add_numbers_to_mat(mats{i});
xticks(1:21)
xticklabels(lbls);
xtickangle(45);
sp.CLim = th{i}
end
%% Face > Monument
data_mat = squeeze(aBeta.fmat_raw(:,11,:) - aBeta.fmat_raw(:,12,:));
[H,P,CI,STATS] = ttest(data_mat');
lbls = aBeta.r_lbls;
mats = {STATS.tstat P}
th = {[1.95 1.96] [.048 .05]}
figure(2);clf;
for i = 1:2
title('FaceCC > Monuments','Fontsize',20)
sp = subplot(2,1,i);
add_numbers_to_mat(mats{i});
xticks(1:21)
xticklabels(lbls);
xtickangle(45);
sp.CLim = th{i}
end
%% Physical Knowledge > Mon
data_mat = squeeze(mean(aBeta.fmat_raw(:,[7 8],:),2) - aBeta.fmat_raw(:,12,:));
[H,P,CI,STATS] = ttest(data_mat');
lbls = aBeta.r_lbls;
mats = {STATS.tstat P}
th = {[1.95 1.96] [.048 .05]}
figure(2);clf;
for i = 1:2
title('FaceCC > Monuments','Fontsize',20)
sp = subplot(2,1,i);
add_numbers_to_mat(mats{i});
xticks(1:21)
xticklabels(lbls);
xtickangle(45);
sp.CLim = th{i}
end
%% Tiny Task > CC
data_mat = squeeze(mean(aBeta.fmat,2));
for r = 1:length(r_group)
    red(r,:) = mean(data_mat(ismember(rlbls,r_group{r}),:),1);
end

data_mat = red;
lbls = r_group_lbls;
[H,P,CI,STATS] = ttest(data_mat');
mats = {STATS.tstat P}
th = {[1.95 1.96] [.048 .05]}
figure(2);clf;
for i = 1:2
title('Task > FaceCC','Fontsize',20)
sp = subplot(2,1,i);
add_numbers_to_mat(mats{i});
xticks(1:21)
xticklabels(lbls);
xtickangle(45);
sp.CLim = th{i}
end
%% Tiny Face > Mon
data_mat = aBeta.fmat_raw(:,11,:) - aBeta.fmat_raw(:,12,:);
for r = 1:length(r_group)
    red(r,:) = mean(data_mat(ismember(rlbls,r_group{r}),:),1);
end

data_mat = red;
lbls = r_group_lbls;
[H,P,CI,STATS] = ttest(data_mat');
mats = {STATS.tstat P}
th = {[1.95 1.96] [.048 .05]}
figure(2);clf;
for i = 1:2
title('Face > Mon','Fontsize',20)
sp = subplot(2,1,i);
add_numbers_to_mat(mats{i});
xticks(1:21)
xticklabels(lbls);
xtickangle(45);
sp.CLim = th{i}
end
%% Tiny Task > Mon
data_mat = mean(aBeta.fmat_raw(:,1:10,:),2) - aBeta.fmat_raw(:,12,:);
for r = 1:length(r_group)
    red(r,:) = mean(data_mat(ismember(rlbls,r_group{r}),:),1);
end

data_mat = red;
lbls = r_group_lbls;
[H,P,CI,STATS] = ttest(data_mat');
mats = {STATS.tstat P}
th = {[1.95 1.96] [.048 .05]}
figure(2);clf;
for i = 1:2
title('Task > Mon','Fontsize',20)
sp = subplot(2,1,i);
add_numbers_to_mat(mats{i});
xticks(1:21)
xticklabels(lbls);
xtickangle(45);
sp.CLim = th{i}
end
%%
rlbls = r_group_lbls;
tlbls = t_group_lbls;
%data_mat_9_5


for t1 = 5
for t2 = 4
    v1 = squeeze(data_mat_9_5(4,t1,:));
    v2 = squeeze(data_mat_9_5(4,t2,:));
    [H,P,CI,STATS] = ttest(v1,v2);
    tmat(t1,t2) = (STATS.tstat);
    pmat(t1,t2) = (P);
end
end

figure(1);clf
[H,P,CI,STATS] = ttest(squeeze(data_mat_9_5(8,4,:)));t_statement(STATS,P)
add_numbers_to_mat(tmat,tlbls)




