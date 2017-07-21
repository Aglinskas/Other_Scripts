addpath('/Users/aidasaglinskas/Downloads/anova_rm-1/')
%%

trim(:,5,:)
%%
anova_rm(squeeze(trim(:,5,:))')


%%

[h(1:end).Color] = deal([0 0 1])
[h(1:end).LineWidth] = deal(3)
%%

i  = i +1 
h(i).Color = [0 1 0] 

% 1 nominal

%%

    dend = figure(2)
[h x perm] = dendrogram(Z,'labels',this_lbls)
    title('Dendrogram','Fontsize',20)
    [h(1:end).LineWidth] = deal(3) % linewidhth
    dend.CurrentAxes.FontSize = 14
    dend.CurrentAxes.FontWeight = 'bold'
    dend.CurrentAxes.XTickLabelRotation = 45


c = {'\color{green} Common name'
'\color{green} Full name'
'\color{yellow} Attractiveness'
'\color{yellow} Distinctiveness'
'\color{cyan} Friendliness'
'\color{red} First memory'
'\color{magenta} Occupation'
'\color{cyan} Trustworthiness'
'\color{magenta} Familiarity'
'\color{red} How many facts'}

ticklabels = get(gca,'XTickLabel');

% prepend a color for each tick label
ticklabels_new = cell(size(ticklabels));
for i = 1:length(ticklabels)
    ticklabels_new{i} = c{i};
end
% set the tick labels
set(gca, 'XTickLabel', ticklabels_new);


cc = .6
dend.Color = [cc cc cc];
dend.CurrentAxes.Color = [cc cc cc]
box off

%%

h(1)


