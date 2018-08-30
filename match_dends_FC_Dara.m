clear
loadMR;
load('/Users/aidasaglinskas/Desktop/fcRes.mat')

%% Aligning the mats
mask.lbls{17} = 'dmPFC';
mask.lbls{18} = 'vmPFC';
[mY mI] = sort(mask.lbls);
[bY bI] = sort(aBeta.r_lbls);

aBeta.r_lbls = aBeta.r_lbls(bI);
mask.lbls = mask.lbls(mI);

fcRes = fcRes(mI,mI);
aBeta.fmat = aBeta.fmat(bI,:,:);
%%
tcmat = [];rcmat = [];
for s_ind = 1:size(aBeta.fmat,3)
tcmat(:,:,s_ind) = corr(aBeta.fmat(:,:,s_ind));
rcmat(:,:,s_ind) = corr(aBeta.fmat(:,:,s_ind)');    
end
mtcmat = mean(tcmat,3);
mrcmat = mean(rcmat,3);
%%

mats = {mrcmat fcRes};
%lbls = {aBeta.r_lbls mask.lbls};
lbls = {mask.lbls mask.lbls};
ttl = {'Faces Experiment FC' 'Neurosynth FC'};
ord = {};
%ord{1} = [13    14     9    10    19    20    11    12    15    16     1     2     5 6     3     4    18    17    21     7     8]; % Face Data 
%ord{2} = [13    14     9    10    19    20    11    12    15    16     1     2     5 6   7    17     3    18     4    21     8]  ; % neurosynth data

ord{1} = [13    14     9    10    19    20    11    12    15    16     1     2     5     6     8     7    17     3     4    18    21]
ord{2} = ord{1};
mat_ind = 2;

%2 1.4697
mat = mats{mat_ind};
lbl = lbls{mat_ind}
vec = 1-get_triu(mat');
Z = linkage(vec,'ward');

%Z(:,3) = Z(:,3) ./ max(Z(:,3))
%if mat_ind == 2; Z(:,3) = Z(:,3) - .2;end


d = figure(1);


%[h x perm] = dendrogram(Z,'labels',lbls);
[h x perm] = dendrogram(Z,'Reorder',ord{mat_ind},'labels',lbl);
%[h x perm] = dendrogram(Z,'labels',lbl);
d.CurrentAxes.FontSize = 14
d.CurrentAxes.FontWeight = 'bold'
d.CurrentAxes.XTickLabelRotation = 45
[h(1:end).LineWidth] = deal(3)
title(ttl{mat_ind},'fontsize',20)
d.Color = [1 1 1]
%ylim([0 1.1])

m = figure(2)
ord = perm
rmat = mat(ord,ord);
rlbls = lbl(ord);
add_numbers_to_mat(rmat,rlbls)
title(ttl{mat_ind},'fontsize',20)
m.Color = [1 1 1];
m.CurrentAxes.FontSize = 12
m.CurrentAxes.XTickLabelRotation = 45
m.CurrentAxes.FontWeight = 'bold'


ofn = ['/Users/aidasaglinskas/Desktop/' num2str(mat_ind) '.png'];
saveas(d,ofn)