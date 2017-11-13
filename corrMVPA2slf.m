clear;loadMR
sc = [];
use_cmat = [];
for r_ind = 1:21
for s_ind = 1:20
    clc;disp(sprintf('%d/%d %d/%d',r_ind,21,s_ind,20));
temp=[];
for run=1:5
    for task=1:10
temp(run,task,:)= [vx.f_voxel_data{r_ind,task,s_ind,run}];
    end
end
for t1 = 1:10
for t2 = 1:10
%ztemp=zscore(temp,[],1);
%deMeanTemp = temp - mean(temp,1);
%%
clear reallyTemp
for run=1:5
reallyTemp(run,:,:)=zscore(squeeze(temp(run,:,:)));% default is 1st dim
end

%%
use_mat = reallyTemp;
sqz = [squeeze(use_mat(:,t1,:)); squeeze(use_mat(:,t2,:))]';
%sqzz = [squeeze(ztemp(:,t1,:)); squeeze(ztemp(:,t2,:))]';
%lol = [squeeze(deMeanTemp(:,t1,:)); squeeze(deMeanTemp(:,t2,:))]'

use_cmat = corr(sqz);
%add_numbers_to_mat(use_cmat)

within1_all = get_triu(use_cmat(1:5,1:5));
within2_all = get_triu(use_cmat(6:10,6:10));
within1 = mean(within1_all);
within2 = mean(within2_all);

across_all = use_cmat(1:5,6:10);
across_all_diag_inds = [1 7 13 19 25];
across_all(across_all_diag_inds) = [];
across = mean(across_all);
c = across - mean([within1 within2]);
sc(t1,t2,r_ind,s_ind) = c;
%sc(t1,t2,r_ind,s_ind) = across;
end
end
end
end
disp('all done')
%% Fixed Effects
% f1 = figure(1)
% rvecmat = [];
% m = mean(sc,4);
% for i = 1:21
%     rvecmat(i,:) = get_triu(m(1:10,1:10,i));
% end
% rcmat = corr(rvecmat');
% Z = linkage(1-get_triu(rcmat),'ward');
% subplot(1,2,2);
% [h x perm] = dendrogram(Z,'labels',vx.r_labels,'orientation','left');
% ord = perm(end:-1:1);
% subplot(1,2,1);
% add_numbers_to_mat(rcmat(ord,ord),vx.r_labels(ord))
%% Random Effects
disp('computing correlations')
t_inds = 1:10;
rcmat = [];
for r1 = 1:size(sc,3)
for r2 = 1:size(sc,3)
for s = 1:size(sc,4)
rcmat(r1,r2,s) = corr(get_triu(sc(t_inds,t_inds,r1,s))',get_triu(sc(t_inds,t_inds,r2,s))');
end
end
end
disp('done')
%%
m = mean(rcmat,3);
Z = linkage(1-get_triu(m),'ward');
sc1 = subplot(1,2,2);
[h x perm] = dendrogram(Z,'labels',vx.r_labels,'orientation','left');
    [h(1:end).LineWidth] = deal(3);
    sc1.FontSize = 12;
    sc1.FontWeight = 'bold';
ord = perm(end:-1:1);
sc2 = subplot(1,2,1);
add_numbers_to_mat(rcmat(ord,ord),vx.r_labels(ord))
    sc2.TickDir = 'out';
    sc2.FontSize = 12;
    sc2.XTickLabelRotation = 45;
    sc2.FontWeight = 'bold';
%% tmatrix
for r_ind = 1:size(sc,3)
for t1 = 1:10
for t2 = 1:10
[H,P,CI,STATS] = ttest(squeeze(sc(t1,t2,r_ind,:)));
tmat(t1,t2,r_ind) = STATS.tstat;
end
end
end
%% Run Tmat
i = 0;
%%
i = i+1
r_ind = i;
f = figure(1);clf;
add_numbers_to_mat(-tmat(:,:,r_ind),vx.t_labels(1:10))
f.CurrentAxes.CLim = [max(max(-tmat(:,:,r_ind)))-.2 max(max(-tmat(:,:,r_ind)))]
title(vx.r_labels{r_ind},'fontsize',20)
%% 
m = squeeze(mean(mean(sc,1),4));
%m = zscore(m,[],1)
f = figure(1)
add_numbers_to_mat(-m',vx.r_labels,vx.t_labels(1:10))
f.CurrentAxes.CLim = [0.01 .1]