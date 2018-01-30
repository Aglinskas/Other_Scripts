loadMR
%load('/Users/aidasaglinskas/Desktop/Smat.mat')
mat = aBeta.wmat;
%mat = cat(3,aBeta.wmat,aBeta.fmat)
%[min([mats{1}(:);mats{2}(:)]) max([mats{1}(:);mats{2}(:)])]
sp_ttls = {'F Data' 'Raw' '' '' 'Region Preference Enchancd' '' ''}
%mat = rand(size(aBeta.wmat));
to_trim = mat;

%lbls
    r_inds = {[11;12]	[15;16]	[3;4]	18	21	17	[7;8]	[5;6]	[1;2]};
    wh_r_labels = {'IFG'	'OFC'	'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular'	'Amygdala'	'ATFP'};
    
    r_inds = {[11;12]	[15;16]	[3;4]	18	21	17	[7;8]};
    wh_r_labels = {'IFG'	'OFC'	'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular'};
    
    wh_r_labels = strrep(wh_r_labels,'_','-')
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
[H,P,CI,STATS] = ttest(this_vec,0);
tmat(r,t) = STATS.tstat; % vs face CC
%tmat(r,t) = mean(this_vec); % vs face CC
end
end

tm = figure(2);add_numbers_to_mat(tmat2,wh_r_labels,wh_t_labels)
imagesc(tmat2)

%

ff = figure(3);clf;
pcolor([tmat2(end:-1:1,:) zeros(size(tmat2,1),1);zeros(1,size(tmat2,2)+1)])
ff.CurrentAxes.CLim = [2 4]
ff.Color = [1 1 1]
ff.CurrentAxes.XTick = []
ff.CurrentAxes.YTick = []





tm.CurrentAxes.CLim = [2 4];
tm.CurrentAxes.XTick = 1:length(wh_t_labels);
tm.CurrentAxes.XTickLabel = wh_t_labels;
tm.CurrentAxes.YTick = 1:length(wh_r_labels);
tm.CurrentAxes.YTickLabel = wh_r_labels;
tm.CurrentAxes.FontSize = 14;
tm.CurrentAxes.FontName = 'ComicSans';
tm.CurrentAxes.FontWeight = 'bold';
colorbar

{{'Response to task' 'ttest against 0'} {'Cognitive preference' 'task vs mean of other tasks' sp_ttls{1}}}
title(ans{2},'fontsize',20)


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


%plt_list = [1.0000    0.8275         0;0 1 0;0    0.5300    0.1600; 1.0000    0.6100    0.2200;0.0078    0.6900    0.9400; 1.0000    0.3800    0.7800; 0.4300    0.1800    0.6200]
plt_list = [0    0.5300    0.1600; 1.0000    0.6100    0.2200;0.0078    0.6900    0.9400; 1.0000    0.3800    0.7800; 0.4300    0.1800    0.6200]
plt_list = plt_list(end:-1:1,:);
f = figure(13);clf;

%tmat = tmat ./ sum(tmat,2)

mats = {tmat tmat2};
sp_list = {[[1 2 5 6 9 10]] 3 7 11 4 8 12};
wh_plot_list = {1:5 5 3:4 1:2 5 3:4 1:2};
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
pp = {'r-o' 'r-o' 'r-o'  'r-o' 'r-o' 'r-o' 'r-o' 'r-o'};
g = polarplot(angle,rho,pp{sp_ind},'Color',plt_list(i,:),'LineWidth',3);
g.MarkerSize = 30
g.Marker = '.'
hold on
end

f.Color = [1 1 1]
f.CurrentAxes.Layer = 'top'
f.CurrentAxes.LineWidth = 3
%f.CurrentAxes.RLim = [min(use_mat(:)) max(use_mat(:))];
f.CurrentAxes.RLim = [-7.7157    9.3079]
f.CurrentAxes.ThetaTick = rad2deg(angle);
f.CurrentAxes.ThetaTickLabel = use_r_lbls;
f.CurrentAxes.ThetaGrid = 'on';
f.CurrentAxes.FontSize = 15;
f.CurrentAxes.FontWeight = 'bold';
if sp_ind == 1;l = legend(use_t_lbls(wh_plot),'location','northeastoutside');end
title(sp_ttls{sp_ind},'Fontsize',20)
end % ends suplot
%%
%saveas(f,['/Users/aidasaglinskas/Desktop/Figures/' datestr(datetime) '.png'],'png')