%% Bar PLOT
loadMR;
pickmat = aBeta.fmat
r_inds = {[13;14]	[9;10]	[19;20]	[11;12]	[15;16]	[3;4]	18	21	17	[7;8]	[5;6]	[1;2]};
r_lbls = {'OFA'	'FFA'	'pSTS'	'IFG'	'OFC'	'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular'	'Amygdala'	'ATFP'};

mat = [];
for r = 1:length(r_inds)
for t = 1:length(aBeta.trim.t_inds)
mat(r,t,:) = mean(mean(pickmat(r_inds{r},aBeta.trim.t_inds{t},:),2),1);
end
end
% Bar Plot

r_ind = [1:21]; %ATL IFG
mat = mat;

r_inds = 1:21
r_lbls = aBeta.r_lbls
mat = aBeta.fmat

% 11 = IFGLeft
% 12  = IFGRight
m = squeeze(mean(mat(r_ind,:,:),3));
sdc = arrayfun(@(x) std(squeeze(mat(x,:,:))'),r_ind,'UniformOutput',0)
sd = reshape(cell2mat(sdc),size(m))
se = sd / sqrt(20)
xlbls = r_lbls(r_ind);
% Data to be plotted as a bar graph
f = figure(1)
clf
model_series = [10 40 50 60; 20 50 60 70; 30 60 80 90];
model_series = m;
%Data to be plotted as the error bars
model_error = [1 4 8 6; 2 5 9 12; 3 6 10 13];
model_error = se
% Creating axes and the bar graph
c = [ 0         0    1.0000
    1.0000         0         0
         0    1.0000         0
         0         0    0.1724
    1.0000    0.1034    0.7241];
ax = axes;
h = bar(model_series,'BarWidth',1);
% Set color for each bar face
% h(1).FaceColor = 'blue';
% h(2).FaceColor = 'yellow';
% Properties of the bar graph as required
c = distinguishable_colors(5)
for i = 1:5
h(i).FaceColor = c(i,:);
end
ax.YGrid = 'on';
{'-' '--' ':' '-.' 'none'}
ax.GridLineStyle = ans{1};
xticks(ax,[1:length(r_ind)]);
% Naming each of the bar groups
xticklabels(ax,xlbls);
f.CurrentAxes.FontSize = 14;
f.CurrentAxes.FontWeight = 'bold'
f.CurrentAxes.XTickLabelRotation = 45
% X and Y labels
%xlabel ('Brain Region');
ylabel ('Brain Response');
% Creating a legend and placing it outside the bar plot
%lg = legend('A','B','C','D','AutoUpdate','off','northwest');
lg = legend(aBeta.trim.t_lbls);
lg.Location = 'BestOutside';
lg.Orientation = 'Horizontal';
hold on;
lg.FontSize = 14;
lg.FontWeight = 'bold';
% Finding the number of groups and the number of bars in each group
ngroups = size(model_series, 1);
nbars = size(model_series, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end
box off
f.Color = [1 1 1]
f.CurrentAxes.YLim = [-3 7];