load('/Users/aidasaglinskas/Desktop/voxel_data.mat')
%% Make the Data Set
pairs = nchoosek(1:12,2);
acc_mat = [];
for m_ind = 1:21
for s_ind = 1:20
    clc;disp(sprintf('%d/21 | %d/20',m_ind,s_ind));
for pair_ind = 1:size(pairs,1);
    l = 0;dt = [];
for t_ind = 1:2
  t = pairs(pair_ind,t_ind);
for run_ind = 1:5
    l = l+1;
    dt.samples(l,:) = vx.voxel_data{m_ind,t,s_ind,run_ind};
    dt.sa.m_ind(l,1) = m_ind;
    dt.sa.s_ind(l,1) = s_ind;
    dt.sa.task(l,1) = t;
    dt.sa.run_ind(l,1) = run_ind;
end
end
% Decode
ds = dt; % copy 'cause why not
ds.sa.chunks = ds.sa.run_ind; % add chunks
ds.sa.targets = ds.sa.task; % add targets
opt=struct(); % opts?
opt.normalization='zscore';
partitions=cosmo_nfold_partitioner(ds.sa.chunks);
%classifier = @cosmo_correlation_measure;
classifier = @cosmo_classify_lda;
[pred, accuracy] = cosmo_crossvalidate(ds, classifier, partitions);
acc_mat(m_ind,pairs(pair_ind,1),pairs(pair_ind,2),s_ind) = accuracy;
acc_mat(m_ind,pairs(pair_ind,2),pairs(pair_ind,1),s_ind) = accuracy;
end
end
end
disp('all done')
save('/Users/aidasaglinskas/Desktop/acc_dec.mat')
%% plot all
m_acc_mat = mean(acc_mat,4);

res.acc_mat = acc_mat;
res.m_acc_mat = m_acc_mat;
t_acc_mat = [];
for r_ind = 1:size(acc_mat,1)
for t1 = 1:12
for t2 = 1:12
this_vec = squeeze(acc_mat(r_ind,t1,t2,:));
[H,P,CI,STATS] = ttest(this_vec,.5);
t_acc_mat(r_ind,t1,t2) = STATS.tstat;
end
end
end
res.tmat = t_acc_mat;
%% AVG DEC MAT
res.avg_dec = [];
for s_ind = 1:20
for r_ind = 1:21
mat = squeeze(res.acc_mat(r_ind,:,:,s_ind));
for t = 1:12
res.avg_dec(r_ind,t,s_ind) = mean(mat(t,find([1:12] ~= t),:));
end
end
end
%%
res.m_avg_dec = mean(res.avg_dec,3);
add_numbers_to_mat(res.m_avg_dec(:,1:10)-.5,vx.r_labels,vx.t_labels(1:10))
title({'Average Decoding' 'Chance subtracted'},'fontsize',20)
%% Full T mat
for r = 1:21
for t = 1:10
   [H,P,CI,STATS] = ttest(squeeze(res.avg_dec(r,t,:)),.5);
   res.tmat_full(r,t) = STATS.tstat;
end
end
f = figure(1)
add_numbers_to_mat(res.tmat_full,vx.r_labels,vx.t_labels(1:10))
title({'Decoding t values'},'fontsize',20)
f.CurrentAxes.CLim = [2 3]
%% TRIM 
trim1 = [];
for i = 1:length(aBeta.trim.t_inds)
trim1(:,i,:) = mean(res.avg_dec(:,aBeta.trim.t_inds{i},:),2)
end
res.trim1 = trim1;
tmat = [];
for r = 1:21
for t = 1:5
[H,P,CI,STATS] = ttest(squeeze(res.trim1(r,t,:)),.5);
    tmat(r,t) = STATS.tstat;
end
end
res.tmat = tmat;
f = figure(1);
add_numbers_to_mat(res.tmat,vx.r_labels,aBeta.trim.t_lbls)
title({'t values' 'tasks colapsed'},'fontsize',20)
f.CurrentAxes.CLim = [2 3]
%% Dendrogram;
mat_10 = res.acc_mat(:,1:10,1:10,:);
mat_12 = res.acc_mat(:,1:12,1:12,:);
% RFX
res.rcmat_12 = [];
res.rcmat_10 = [];
disp('computing correlations')
for r1 = 1:size(mat_10,1);
for r2 = 1:size(mat_10,1);
for s = 1:size(mat_10,4)
res.rcmat_10(r1,r2,s) = corr(get_triu(squeeze(mat_10(r1,:,:,s)))',get_triu(squeeze(mat_10(r2,:,:,s)))');
res.rcmat_12(r1,r2,s) = corr(get_triu(squeeze(mat_12(r1,:,:,s)))',get_triu(squeeze(mat_12(r2,:,:,s)))');
end
end
end;disp('done')
%% Plot Dend
mat = mean(res.rcmat_10,3);
figure(2);add_numbers_to_mat(mat,vx.r_labels)
lbls = vx.r_labels
Z = linkage(1-get_triu(mat),'ward')
f = figure(1)
[h x perm] = dendrogram(Z,'labels',lbls,'orientation','left');
%make_pretty_dend(f,h)
%%