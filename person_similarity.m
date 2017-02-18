clear all;clc
loadMR
subvect = subBeta.subvect;
% Run all_trials.m if you want to rebuild, otherwise loaded from loadMR
%% Behavioral Rating
% Add names 
disp('adding names')
for i = 1:length(all_trials)
    a = strsplit(all_trials(i).filepath,'/');
    if strcmp(a{1},'People')
   all_trials(i).name = a{2};
    end
end
disp('done')

not_empty_cells = find(cellfun(@isempty,{all_trials.name}) == 0);
names = unique({all_trials(not_empty_cells).name})';
%%
v = []
for fc = 1:length(names)
for task  = 1:10
r1 = find(cellfun(@(x) strcmp(x,names{fc}),{all_trials.name})');
r2 = find([all_trials(r1).blockNum] == task);%{all_trials(r1).name}'
v(fc,task,:) =  [all_trials(r1(r2)).resp]';
end
end
v_hardcopy = v;
%%
mat = nanmean(v,3);
tlbls = subBeta.t_labels(1:10)
figure(2)

cmat = corr(mat');
newvec = get_triu(cmat);
Z = linkage(1-newvec,'ward');

d = subplot(1,3,2)
[h x perm] = dendrogram(Z,0,'labels',names,'orientation','left');
ord = perm(end:-1:1);
d.YTickLabel = names(perm)
title('Dendogram')
[h(1:end).LineWidth] = deal(2)
d.FontSize = 12;
d.FontWeight = 'bold'


subplot(1,3,3)
add_numbers_to_mat(mat(ord,:),names(ord),tlbls);
title('Raw Scores')

c = subplot(1,3,1)
%cmat = corr(mat');
%add_numbers_to_mat(cmat(ord,ord),names(ord))
imagesc(cmat(ord,ord));
colorbar
c.XTick = 1:1:size(cmat,2);
c.YTick = 1:1:size(cmat,1);
c.YTickLabel = names(ord);
c.XTickLabel = names(ord);
c.XTickLabelRotation = 90;




