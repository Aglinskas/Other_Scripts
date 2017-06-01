clear;clc;close;loadMR
%%
subBeta
arr = subBeta.array;
arr = arr - arr(:,11,:);
arr = arr(:,1:10,:);
arr = zscore(arr,[],2);

cormats = [];
lbls = r_labels;
lbls = strrep(lbls,'Right','-Right')
lbls = strrep(lbls,'Left','-Left')
for s_ind = 1:20
cormats(:,:,s_ind) = corr(arr(:,:,s_ind)');
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
%Z_atlas = get_Z_atlas(Z,length(Z) + 1)
%OFA = 4, Prec = 1 FP = 17
%ind = [4 5 6 9 16];
% ind = [17 18 12 13]
% ln_ind = [cellfun(@(x) any(ismember(ind,x)),Z_atlas(:,1)) cellfun(@(x) any(ismember(ind,x)),Z_atlas(:,2))];
% ln_ind = sum(ln_ind,2);
% ln_ind(end) = [];
% ln_ind(end) = [];
% to_dl = [1 0 0]
%to_dl = {to_dl};
% [h(find(ln_ind)).Color] = deal(to_dl)

box off
[h(1:end).LineWidth] = deal(2)
ln_c{1} = [ 1     5     7     9    12    13    15];
ln_c{2} = [  2     3     4     8    10];
ln_c{3} = [6    11    14];

cls = {[0 1 0] [1 0 0] [1 1 0]}
for i = 1:numel(ln_c)
[h(ln_c{i}).Color] = deal(cls{i})
end
[h([16 17]).LineWidth] = deal(4)
f.Color = [1 1 1];
f.CurrentAxes.Color = 'none';



f.CurrentAxes.YLabel.String = 'Dissimilarity';
f.CurrentAxes.XLabel.String = 'ROI';
f.CurrentAxes.XLabel.FontSize = 16;
f.CurrentAxes.Title.String = 'Regional Clustering';
f.CurrentAxes.Title.FontSize = 20;

ofn = '/Users/aidasaglinskas/Desktop/dend_roi';
export_fig([ofn '.pdf'], '-pdf','-transparent')
%%


