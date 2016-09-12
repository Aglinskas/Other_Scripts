%% master clustering
lbls = masks_name
newVec = get_triu(squeeze(mean(keep,1)));
Z = linkage(1-newVec,'ward');
dend_labeled = figure(6);
dendrogram(Z,'labels',lbls) %,'Orientation','left')
dend_labeled.CurrentAxes.XTickLabelRotation = 45
