clear all
loadMR
size(subBetaArray)
% Random effects
clear keep
w_t = 1:10;
w_rois = [1 2 3 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20]
tr_subBetaArray = subBetaArray(w_rois,w_t,:);
% Zscoring
for ss = 1:size(tr_subBetaArray,3)
for t = 1:size(tr_subBetaArray,2)
 %z_subBetaArray.Roi(:,t,ss) = zscore(tr_subBetaArray(:,t,ss));
 z_subBetaArray.Roi(:,t,ss) = tr_subBetaArray(:,t,ss);
end
end

for ss = 1:size(tr_subBetaArray,3)
for r = 1:size(tr_subBetaArray,1)
 %z_subBetaArray.task(r,:,ss) = zscore(tr_subBetaArray(r,:,ss));
 z_subBetaArray.task(r,:,ss) = tr_subBetaArray(r,:,ss);
end
end

for ss = 1:size(tr_subBetaArray,3)
   keep.roi(:,:,ss) = corr(z_subBetaArray.Roi(:,:,ss)');
   keep.task(:,:,ss) = corr(z_subBetaArray.task(:,:,ss));
end
%%
clf
this_mat = mean(keep.task,3);
task_ord = [  2     9     3     4     5     1     8     7     6    10]
%this_mat = this_mat(task_ord,task_ord)
%t_ten = {tasks{1:10}};
all_labels = {{master_coords_labels{w_rois}} {tasks{1:10}}};
%this_lbls = all_labels{cellfun(@(x) length(x)==length(this_mat),all_labels)};
this_lbls = all_labels{2}


f = figure(1)
im = subplot(1,2,1)
add_numbers_to_mat(this_mat,this_lbls);
im.FontSize = 15
im.FontWeight = 'bold' 
newVec = get_triu(this_mat);
Z = linkage(1-newVec,'ward');
d = subplot(1,2,2)
[h x] = dendrogram(Z,'labels',this_lbls,'orientation','left');
[h(1:end).LineWidth] = deal(5)
d.FontSize = 16
d.FontWeight = 'bold'
%title(roi_lbl)
%ofn.folder_name = 'MVPA_per_ROI_paired'
%ofn.fullpath = fullfile(ofn.root,ofn.folder_name);
%if exist(ofn.fullpath) == 0
%mkdir(ofn.fullpath);end
%saveas(f,fullfile(ofn.fullpath,num2str(i)),'jpg')




