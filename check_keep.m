clear all
loadMR
load('~/Google Drive/MRI_data/subBetaArraySPLIT_alt.mat')
load('/Users/aidasaglinskas/Desktop/tasks2.mat')
%%
%remove the network mean
size(subBetaArray)
for sub = 1:size(subBetaArray,3)
    %new_SBA(:,:,sub) = subBetaArray(:,:,sub) - repmat([mean(subBetaArray(:,[1:24],sub))],18,1);
    new_SBA(:,:,sub) = subBetaArray(:,:,sub) - repmat([mean(subBetaArray(:,[1:12],sub)) mean(subBetaArray(:,[13:24],sub))],18,1);
end
clear subBetaArray
subBetaArray = new_SBA
%%
%mfilename
task_inds = 1:12%[1:10;13:22]
task_inds = task_inds(:)
roi_inds = 1:18
%task_inds = Shuffle(task_inds)
%reducedBetaArray = subBetaArray(:,task_inds,:);
% map_runs = [1:12;13:24]'
% clear concatenated_subBetaArray
% for i = 1:length(map_runs)
% concatenated_subBetaArray(:,i,:) = mean(subBetaArray(:,map_runs(i,:),:),2);
% end
% % % %
matrix = subBetaArray(roi_inds,task_inds,:)%subBetaArray(roi_inds,task_inds,:);  %(ROI,Task,SUB)
lbls = tasks(task_inds) %masks_name
% % % % %
%clear keep
% for i = 1:size(matrix,3)
% a = squeeze(matrix(:,:,i));
% keep(:,:,i) = corr(a);
% end
avgKeep = corr(mean(matrix,3))
mat = figure(8)
%avgKeep = squeeze(mean(keep,3));
add_numbers_to_mat(avgKeep,lbls)
mat.Position = [1           1        1230         704]
mat.CurrentAxes.FontSize = 20
newVec = get_triu(avgKeep);

which_method = 7;
dend_methods = {'single' 'complete' 'average' 'weighted' 'centroid' 'median' 'ward'}
Z = linkage(1-newVec,dend_methods{which_method});
dend = figure(9)
dendrogram(Z,'orientation','left','ColorThreshold',.1)
ord = str2num(dend.CurrentAxes.YTickLabel); ord = ord(end:-1:1)
[h x] = dendrogram(Z,'labels',lbls,'orientation','left','ColorThreshold',0.2)
%title({['method ' dend_methods{which_method}]})

dend.CurrentAxes.FontSize = 20;
[h(1:end).LineWidth] = deal(3)
dend.Position = [1           1        1230         704]
%mfilename('fullpath')