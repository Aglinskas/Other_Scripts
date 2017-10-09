loadMR
mat = aBeta.fmat;
to_trim = mat;
%lbls
    r_inds = {[13;14]	[9;10]	[19;20]	[11;12]	[15;16]	[3;4]	18	21	17	[7;8]	[5;6]	[1;2]};
    wh_r_labels = {'OFA'	'FFA'	'pSTS'	'IFG'	'OFC'	'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular'	'Amygdala'	'ATFP'};
    t_inds = aBeta.trim.t_inds
    wh_t_labels = aBeta.trim.t_lbls

trim = [];
for r = 1:length(r_inds)
for t = 1:length(t_inds)
trim(r,t,:) = squeeze(mean(mean(to_trim(r_inds{r},t_inds{t},:),1),2));
end
end
mtrim = mean(trim,3);


tmat = []; tmat2 = [];
for r = 1:length(r_inds)
for t = 1:length(t_inds)
this_vec = squeeze(trim(r,t,:));
other_vec = squeeze(mean(trim(r,find([1:5]~=t),:),2));
%other_vec = squeeze(mean(trim(r,6,:),2));
[H,P,CI,STATS] = ttest(this_vec,other_vec);
tmat2(r,t) = STATS.tstat; % vs other tasks
[H,P,CI,STATS] = ttest(this_vec);
tmat(r,t) = STATS.tstat; % vs face CC
end
end
use_mat = tmat;
use_t_lbls = wh_t_labels;
use_r_lbls = wh_r_labels;
    r_ind = (1); % Prep
    rho = use_mat(:,r_ind);
    sep = .60;
    angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;
plt_list = [0 .9 0 %  nominal green 
.9 1 0 % physical
0 .9 .9 %socal 
1 0 0 % episodic
.5 0 1 %factual
0	0	.3
0	0	.5
0	0	.5
0	.5	.5
0	.5	.5
0	0	.5
0	0	.5
0	.5	.5
0	.5	.5];

f = figure(13);clf;
mats = {tmat tmat2};
sp_list = {[[1 2 5 6 9 10]] 3 7 11 4 8 12};
wh_plot_list = {1:5 5 3:4 1:2 5 3:4 1:2};
sp_ttls = {'Face Data' 'Raw' '' '' 'Region Preference Enchancd' '' ''}

for sp_ind = 1:length(sp_list)
subplot(3,4,sp_list{sp_ind})

if sp_ind < 5; 
    use_mat = mats{1};
else
    use_mat = mats{2};
end

wh_plot = wh_plot_list{sp_ind}
for i = wh_plot
%r_ind = randi(10)
r_ind = (i);
rho = use_mat(:,r_ind);
pp = {'r-.o' 'r-o' 'r-o'  'r-o' 'r-o' 'r-o' 'r-o' 'r-o'};
g = polarplot(angle,rho,pp{sp_ind},'Color',plt_list(i,:),'LineWidth',3);
g.MarkerSize = 30
g.Marker = '.'
hold on
end

f.Color = [1 1 1]
f.CurrentAxes.Layer = 'top'
f.CurrentAxes.LineWidth = 3
f.CurrentAxes.RLim = [min(use_mat(:)) max(use_mat(:))];
f.CurrentAxes.ThetaTick = rad2deg(angle);
f.CurrentAxes.ThetaTickLabel = use_r_lbls;
f.CurrentAxes.ThetaGrid = 'on';
f.CurrentAxes.FontSize = 15;
f.CurrentAxes.FontWeight = 'bold';
if sp_ind == 1;l = legend(use_t_lbls(wh_plot),'location','northeastoutside');end
title(sp_ttls{sp_ind},'Fontsize',20)
end % ends suplot
%%
saveas(f,['/Users/aidasaglinskas/Desktop/Figures/' datestr(datetime) '.png'],'png')