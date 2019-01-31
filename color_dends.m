f = figure(3);clf


mat = tcmats;
dlbls = lbls{1};
Z = linkage(1-get_triu(mean(mat,3)),'ward');
[Za dm] = get_Z_atlas(Z);
[h x perm] = dendrogram(Z,'labels',dlbls);
[h(1:end).LineWidth] = deal(3);
f.CurrentAxes.XTickLabelRotation = 45;
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
f.Color = [1 1 1];
%% Task Dend
[h(1:end).Color] = deal([0 0 0] )
[h(1:end).LineWidth] = deal(4)

task_atlas = {'physical' ,[238 120 28] ./ 255 * .9
'social' ,[48 80 153] ./ 255
'episodic' ,[207 73 143] ./ 255
'semantic' ,[98 57 135] ./ 255
'nominal' ,[9 133 51] ./ 255};

t = {{'Attractiveness' 'Distinctiveness'} {'Friendliness' 'Trustworthiness'} {'First memory' 'Familiarity'} {'How many facts' 'Occupation'} {'Common name' 'Full name'}};

xt = xticklabels;
for d = 1:5
for tt = 1:2
    ind = strcmp(xt,t{d}{tt})
    c = strjoin(arrayfun(@(x) num2str(task_atlas{d,2}(x)),1:3,'UniformOutput',0),',');
   xt{ind} = ['\color[rgb]{' c '}' xt{ind}];
end
end
xticklabels(xt);


ofn = '/Users/aidasaglinskas/Desktop/paper_figs/Task_clust.pdf';
print(ofn,'-dpdf','-bestfit');
%%

% i = i+1;
% h(i).Color = [1 0 0];
% clc;
% disp(i)
[h(1:end).Color] = deal([0 0 1]);
link_inds{1} = [1 4 5 9 10 12 14 17 18]; % Red
link_inds{2} = [2 3 6 11 7 16]; % green
link_inds{3} = [8  13 15]; % purple

link_colors{1} = [1 0 0];
link_colors{2} = [0 1 0];
link_colors{3} = [.5 0 .8];

for i = 1:3
    [h(link_inds{i}).Color] = deal(link_colors{i});
end

ofn = '/Users/aidasaglinskas/Desktop/paper_figs/ROI_clust.pdf';
print(ofn,'-dpdf','-bestfit');

