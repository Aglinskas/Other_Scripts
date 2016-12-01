clear all
%close all
loadMR
%

a = subBeta.array - subBeta.array(:,11,:);
a = a(:,[1:10],:)
%a = a - mean(a,1)
%a = a - mean(a,2)

a = zscore(a,[],2)
a = zscore(a,[],1)
%a = zscore(a,[],2)

v= [];l = {};
v(end+1,:) = [6 10]; l{end+1} = 'Nominal';
v(end+1,:) = [2,9]; l{end+1} = 'Physical';
v(end+1,:) = [3,4]; l{end+1} = 'Social';
v(end+1,:) = [1,5]; l{end+1} = 'Episodic';
v(end+1,:) = [7,8]; l{end+1} = 'Facts';

r= {};rl = {};
r{1} = [1]; rl{1} = 'Precuneus';
r{2} = [2 3]; rl{2} = 'Angular';
r{3} = [4 5]; rl{3} = 'OFA';
r{4} = [6 7]; rl{4} = 'FFA';
r{5} = [8 9]; rl{5} = 'IFG';
r{6} = [10 11]; rl{6} = 'ATL';
r{7} = [12 13]; rl{7} = 'Amy';
r{8} = [14]; rl{8} = 'mPFC';
r{9} = [15 16]; rl{9} = 'ORb';
r{10} = [17 18]; rl{10} = 'FP';

for r_ind = 1:length(r)
for t_ind = 1:length(v)
ow(r_ind,t_ind,:) = squeeze(mean(mean(a(r{r_ind},v(t_ind,:),:),2),1));
end
end

%m_ow = mean(ow,3);
%figure(5)
%add_numbers_to_mat(m_ow,l,rl)
%
a = ow
% T matrix calc
tmat = []
for r = 1:size(ow,1)
    for c = 1:size(ow,2)
ve = squeeze(mean(a(r,c,:),2));
m = squeeze(mean(a(r,find([1:size(ow,2)] ~= c),:),2));
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
%%
%for s = 1:20
% subBeta.trim.array(:,:,s) = subBeta.trim.array(:,:,s) - repmat(subBeta.trim.array(:,11,s),1,12)
% end

%tbeta = subBeta.array(t_r,[1:10],:);

clear skeep
for ss = 1:20
    skeep(:,:,ss) = corr(subBeta.trim.array(:,[1:10],ss)');
end

skeep = mean(skeep,3);
skeep_labels = subBeta.overview.r_labels;
add_numbers_to_mat(skeep,skeep_labels)


a = get_triu(skeep);
Z = linkage(1-a,'ward')
dendrogram(Z,'labels',skeep_labels)


for s = 1:20
for t = 1:length(v)
ow(:,t,s) = mean(subBeta.trim.array(:,v(t,:),s),2);
end
end
% Plot summary
clf
r_ord = [ 8     4     9     6     2     3     7    10     1     5];
subBeta.overview.r_labels = {subBeta.overview.r_labels{r_ord}}
subBeta.overview.array = subBeta.overview.array(r_ord,:,:)
% Z score 
%size(subBeta.overview.array)
m = mean(subBeta.overview.array,3);
% m = zscore(m,[],2)

% for ii = 1:10
%     m(ii,:) = zscore(m(ii,:));
% end


sm = figure(7)
for r_ind = 1:length(subBeta.overview.r_labels)
sp = subplot(4,3,r_ind)
hold on
plot(1,m(r_ind,1),'r*')
plot(1,m(r_ind,2),'b*')
plot(1,m(r_ind,3),'k*')
plot(1,m(r_ind,4),'m*')
plot(1,m(r_ind,5),'g*')
xlim([.9 1.1])
legend(subBeta.overview.t_labels,'Location','northwest')
title(subBeta.overview.r_labels{r_ind})
end
%
sp = subplot(4,3,r_ind+1)

add_numbers_to_mat(m,subBeta.overview.r_labels,subBeta.overview.t_labels)
sp = subplot(4,3,r_ind+2)

add_numbers_to_mat(mean(subBeta.array(t_r,:,:),3),{subBeta.RoiLabels{t_r}},subBeta.taskLabels)
%%
%%
save('/Users/aidasaglinskas/Desktop/forScott_edges.mat','skeep',)

%%
f = figure(10)
imagesc(m)
f.CurrentAxes.YTick = 1:length(subBeta.overview.r_labels)
f.CurrentAxes.YTickLabel = subBeta.overview.r_labels
f.CurrentAxes.XTick = 1:length(subBeta.overview.t_labels)
f.CurrentAxes.XTickLabel= subBeta.overview.t_labels
f.CurrentAxes.FontSize = 16
f.CurrentAxes.XTickLabelRotation = 0
%%
%dt = datestr(datetime)
saveas(f,fullfile('/Users/aidasaglinskas/Desktop/2nd_Fig/', datestr(datetime)),'bmp')



%%
% t.roi = {[1 2] [3 4] [7 8] [9 10] [11 12] [13 14] [15] [16 17] [18 19] [20]};
% t.lbl = { 'Amygdala'    'Angular'    'ATL'    'FFA'    'FP'    'IFG'    'mPFC'    'OFA'    'Orb'    'Prec'};
% %%
% for s = 1:size(subBeta.array,3)
% for r = 1:length(t.roi)
% trimB(r,:,s) = mean(subBeta.array(t.roi{r},:,s),1);
% end
% end
% %%







