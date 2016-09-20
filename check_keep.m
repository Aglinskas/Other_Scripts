clear all
loadMR
%load('~/Google Drive/MRI_data/subBetaArraySPLIT_alt.mat')
load('/Users/aidasaglinskas/Desktop/tasks2.mat')
%%
%mfilename
task_inds = [1:12]
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
matrix = subBetaArray(roi_inds,task_inds,:);  %(ROI,Task,SUB)
lbls = tasks      %asks_name  masks_name
% % % % %
clear keep
for i = 1:size(matrix,3)
a = squeeze(matrix(:,:,i));
keep(:,:,i) = corr(a);
end
mat = figure(8)
avgKeep = squeeze(mean(keep,3));
add_numbers_to_mat(avgKeep,lbls)
mat.Position = [ -1279        -223        1280         928]
mat.CurrentAxes.FontSize = 20
newVec = get_triu(avgKeep);

Z = linkage(1-newVec,'ward');
dend = figure(9)
[h x] = dendrogram(Z,3,'labels',lbls,'orientation','left')

dend.CurrentAxes.FontSize = 20;
[h(1:end).LineWidth] = deal(3)
dend.Position = [ -1279        -223        1280         928]
%mfilename('fullpath')