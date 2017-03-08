%%
loadMR;
subBeta.ord_t = [6 10 2 9 3 4 1 5 7 8];

mat1 = subBeta.array - subBeta.array(:,11,:);
mat1 = mat1(:,1:10,:);

%mat1 = mat1 - mean(mat1,1);
%mat1 = mat1 - mean(mat1,2);

%mat1 = zscore(mat1,[],1);
%mat1 = zscore(mat1,[],2)

mat1 = mean(mat1,3);
mat1 = mat1(subBeta.ord_r,subBeta.ord_t);
lbls = {r_labels(subBeta.ord_r) t_labels(subBeta.ord_t)};
%
f = figure(6);
clf
for sp = 1:10;
tp = subplot(5,2,sp);
mat2 = mean(mat1(:,find([1:10] ~= sp)),2);
hold on;

plot(mat2,'k'); %plots mean
%plot(mat1(:,sp),'r'); %Plot all Rois
plot([ 1     2     3     4     5     6     7     8],mat1([ 1     2     3     4     5     6     7     8],sp),'r*'); % Core 
plot([ 9    10    11    12    13    14],mat1([ 9    10    11    12    13    14],sp),'g*'); % DMN 
plot([ 15    16    17    18],mat1([ 15    16    17    18],sp),'b*'); % Limbic


%ylim([-1 1.5])
%legend({'Mean','Task'},'location','northwest');
tp.XTick = 1:18;
tp.XTickLabel = lbls{1};
tp.XTickLabelRotation = 45;
title(lbls{2}(sp))
end
saveas(f,['/Users/aidasaglinskas/Desktop/2nd_Fig/all/' datestr(datetime)],'png')
disp('dome')