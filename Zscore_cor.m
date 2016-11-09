loadMR
subBeta.array = subBeta.array(subBeta.goodinds,[1:10],:);
subBeta.RoiLabels = {subBeta.RoiLabels{subBeta.goodinds}}';
subBeta.taskLabels = {subBeta.taskLabels{1:10}}';
sb = subBeta.array;
%sb = zscore(sb,[],1)
for s = 1:20
    sb_r = sb;
    sb_t = sb;
    %sb_t = zscore(sb_t,[],2);
   task_keep(:,:,s) = corr(sb_t(:,:,s));
   roi_keep(:,:,s) = corr(sb_r(:,:,s)');
end
task_keep = mean(task_keep,3);
roi_keep = mean(roi_keep,3);
mat = roi_keep;
all_lbls = {subBeta.RoiLabels subBeta.taskLabels};
lbls = all_lbls{find(cellfun(@(x) isequal(length(mat),length(x)),all_lbls))};
%
%f = figure(9);
% m = subplot(1,2,1);
% add_numbers_to_mat(mat,lbls);
% m.FontSize = 16;
% d = subplot(1,2,2);
d = figure(9)
newVec = get_triu(mat);
Z = linkage(1-newVec, 'ward');
[h x] = dendrogram(Z,'labels',lbls,'orientation','left');
d.CurrentAxes.FontSize = 20;
d.CurrentAxes.FontWeight = 'bold'
[h(1:end).LineWidth] = deal(3);

% [h(16:end).LineWidth] = deal(5);
% [h(1:15).LineWidth] = deal(3);

[h(1:end).Color] = deal([0 0 1])
w_c = 1
w_a = 0
d.Color = [w_c w_c w_c]
d.CurrentAxes.Color = [w_c w_c w_c]
d.CurrentAxes.XColor = [w_a w_a w_a]
d.CurrentAxes.YColor = [w_a w_a w_a]
root = '/Users/aidasaglinskas/Desktop/2nd_Fig/';

saveas(d,fullfile(root,datestr(datetime)),'jpg')
