load('/Users/aidasaglinskas/Google Drive/MRI_data/tasks.mat')



analysis_name = 'old_sub_beta_array'

fig_ofn = '/Users/aidasaglinskas/Desktop/2nd_Fig/Clustering_Different_ROIS/'
for method = [1 2 3]; % 1-Fixed Effects, 2-Random Effecs
method_str = {'Fixed Effects (Average then Correlate)' 'Random Effects (Correlate then Average)' 'Correlate sub with Average of other subs'}
for roi_or_task = [1 2]; %1-ROI,2-Task
roi_or_task_str = {'ROI Clustering' 'Task Clustering'}

all_lbls = {master_coords_labels,{tasks{1:10}}'};
switch method
    case 1
        disp('Average THEN correlate')
avg_keep = mean(subBetaArray(:,1:10,:),3);
if roi_or_task == 1;
matrix = corr(avg_keep');
elseif roi_or_task == 2;
    matrix = corr(avg_keep);
end
    case 2
        disp('Correlate THEN Average')
        clear keep
for ss = 1:size(subBetaArray,3)
if roi_or_task == 1;
keep(:,:,ss) = corr(subBetaArray(:,1:10,ss)');
elseif roi_or_task == 2;
keep(:,:,ss) = corr(subBetaArray(:,1:10,ss));
end
avg_keep = mean(keep,3);
matrix = avg_keep;
end

    case 3 
disp('Hasson')

        clear keep
for ss = 1:size(subBetaArray,3)
allsubs = [1:size(subBetaArray,3)];    
this_sub = ss;
other_subs = allsubs(ismember(allsubs,this_sub) == 0);
    for r1 = 1:size(subBetaArray,1);
        keep(r1,ss) = corr(subBetaArray(r1,[1:10],this_sub)',mean(subBetaArray(r1,[1:10],other_subs),3)') ;
    end
end
avg_keep = mean(keep,3);
matrix = avg_keep;

end % ends switch







end

labels = all_lbls{find(cellfun(@(x) isequal(length(x),length(matrix)),all_lbls) == 1)};
[size(matrix) size(labels)]

newVec = get_triu(matrix);
Z = linkage(1-newVec,'ward');
dend = figure(7);
clf
[h x] = dendrogram(Z,length(matrix),'orientation','left');
ord = str2num(dend.CurrentAxes.YTickLabel);
ord_r = ord(end:-1:1);
dend.CurrentAxes.YTickLabel = {labels{ord}}';
dend.CurrentAxes.FontSize = 16;
[h(1:end).LineWidth] = deal(3)
% TITLE
ttl = {analysis_name method_str{method} roi_or_task_str{roi_or_task}}
title(ttl)
mat = figure(8)
add_numbers_to_mat(matrix(ord_r,ord_r),{labels{ord_r}})
mat.CurrentAxes.FontSize = 16;
title(ttl)
mat.Position = [-1919         447        1920        1030]
dend.Position = [-1919         447        1920        1030]
saveas(mat,[fig_ofn 'matrix' [ttl{:}]  '.jpg'],'jpg')
saveas(dend,[fig_ofn 'Dend' [ttl{:}]  '.jpg'],'jpg')
end
end
disp('Done, exported')
close all