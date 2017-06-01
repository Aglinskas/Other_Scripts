clear;clc;close;loadMR
%
ROI_or_Task = 1
arr = subBeta.array;

arr = arr - arr(:,11,:);
arr = arr(:,1:10,:);
arr = zscore(arr,[],2);

cormats = [];
if ROI_or_Task == 1
lbls = r_labels;
lbls = strrep(lbls,'Angular','pSTS')
lbls = strrep(lbls,'Right','-Right')
lbls = strrep(lbls,'Left','-Left')
elseif ROI_or_Task == 2
lbls = t_labels(1:10);   
end
for s_ind = 1:20
    if ROI_or_Task == 1
cormats(:,:,s_ind) = corr(arr(:,:,s_ind)');
    elseif ROI_or_Task == 2
        cormats(:,:,s_ind) = corr(arr(:,:,s_ind));
    end
end

mcormat = mean(cormats,3);
newvec = get_triu(mcormat);
Z = linkage(1-newvec,'ward');

f = figure(1);
[h x perm] = dendrogram(Z,'labels',lbls);



f.CurrentAxes.XTickLabelRotation = 45;
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
f.CurrentAxes.FontName;

%%% Find Lines
%
%OFA = 4, Prec = 1 FP = 17
%ind = [4 5 6 9 16];
%
% Z_atlas = get_Z_atlas(Z,length(Z) + 1)
% ind = [1 4 5 7 8]
% ln_ind = [cellfun(@(x) any(ismember(ind,x)),Z_atlas(:,1)) cellfun(@(x) any(ismember(ind,x)),Z_atlas(:,2))];
% ln_ind = sum(ln_ind,2);
% ln_ind(end) = [];
% %ln_ind(end) = [];
% to_dl = [1 0 0]
% to_dl = {to_dl};
% [h(find(ln_ind)).Color] = deal(to_dl{:})


box off
[h(1:end).LineWidth] = deal(2)
if ROI_or_Task == 1
ln_c{1} = [ 1     5     7     9    12    13    15];
ln_c{2} = [  2     3     4     8    10];
ln_c{3} = [6    11    14];
cls = {[1 0 0] [0 1 0] [1 1 0]}
elseif ROI_or_Task == 2
ln_c{1} = [1     3     5     8];
ln_c{2} = [2     4     6     7];
cls = {[0 1 0] [1 0 0]}
end

for i = 1:numel(ln_c)
[h(ln_c{i}).Color] = deal(cls{i})
end

if ROI_or_Task == 1
[h([length(h) length(h)-1]).LineWidth] = deal(5)
elseif ROI_or_Task == 2
[h([length(h)]).LineWidth] = deal(5)
end


f.Color = 'none' %[0 0 0];
f.CurrentAxes.Color = 'none'%[0 0 0];



f.CurrentAxes.YLabel.String = 'Dissimilarity';
if ROI_or_Task == 1
f.CurrentAxes.XLabel.String = 'ROI';
elseif ROI_or_Task == 2
    f.CurrentAxes.XLabel.String = 'Task';
end
f.CurrentAxes.XLabel.FontSize = 16;
if ROI_or_Task == 1
f.CurrentAxes.Title.String = 'Regional Clustering';
elseif ROI_or_Task == 2  
f.CurrentAxes.Title.String = 'Task Clustering';
end
f.CurrentAxes.Title.FontSize = 20;

f.Color = 'white' %[0 0 0];
f.CurrentAxes.Color = 'white'%[0 0 0];
%%
dend_name = {'ROI' 'TASK'}
ofn = '/Users/aidasaglinskas/Desktop/VSS_Poster/dend_task';
fm = 'pdf';
export_fig([ofn num2str(ROI_or_Task) '.' fm], ['-' fm])
