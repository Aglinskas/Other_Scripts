clear all
loadMR

w_t = [1:10];
for s = 1:20
    
    b_roi = zscore(subBeta.array(:,[1:10],s),[],2);
    keep.roi(:,:,s) = corr(b_roi');
    b_task = zscore(subBeta.array(:,1:10,s),[],1);
    keep.task(:,:,s) = corr(b_task);
end

keep.roi = mean(keep.roi,3)
keep.task = mean(keep.task,3)

roi_or_task = 2;
    all.mats = {keep.roi keep.task};
    all.labels = {r_labels t_labels(1:10)};
    t.mat = all.mats{roi_or_task};
    t.labels = all.labels{roi_or_task};

f = figure(1)
dend = subplot(1,2,2)
%dend = figure(7)
newVec = get_triu(t.mat);
Z = linkage(1-newVec,'ward');
[H,T,OUTPERM] = dendrogram(Z,'labels',t.labels,'orientation','left')

[H(1:end).LineWidth] = deal(5)

nm = subplot(1,2,1)
add_numbers_to_mat(t.mat(OUTPERM,OUTPERM),t.labels(OUTPERM))