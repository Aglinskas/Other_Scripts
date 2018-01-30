% Dendrograms
clear
loadMR;
aBeta.r_lbls = strrep(aBeta.r_lbls,'.mat','');
not_semNet = [1 2 5 6 9 10 13 14 19 20];
semNet = find(~ismember(1:21,not_semNet));
aBeta.r_lbls = strrep(aBeta.r_lbls,'_','-');
roi_or_task = 1;
inds = semNet
exp = 2;
mats = {aBeta.fmat(inds,:,:) aBeta.wmat(inds,:,:)}
mat = mats{exp};
albls = {aBeta.r_lbls(inds) aBeta.t_lbls(1:10)};
ttls = {'Face Data' 'Word Data'}
ttl = ttls{exp}
% [19 20 5 6 9 10 13 14] go 
% [19 20 5 6 9 10 13 14 15 16]
% R null
mat_rs = [];
mat_ts = [];
for r = 1:size(mat,1)
for s = 1:size(mat,3)
mat_rs(r,:,s) = mat(r,Shuffle(1:size(mat,2)),s);
end
end
% T null
null_mat = {};
for t = 1:size(mat,2)
for s = 1:size(mat,3)
mat_ts(:,t,s) = mat(Shuffle(1:size(mat,1)),t,s);
end
end
null_mat = {mat_rs mat_ts};
null_mat = null_mat{roi_or_task};
%
cmat = [];
ncmat = [];
for i = 1:size(mat,3)
if roi_or_task == 1
cmat(:,:,i) = corr(mat(:,:,i)');% rois
ncmat(:,:,i) = corr(null_mat(:,:,i)');% rois
elseif roi_or_task == 2
cmat(:,:,i) = corr(mat(:,:,i));% task
ncmat(:,:,i) = corr(null_mat(:,:,i));% rois
end
end
% Dendrogram
acmat = mean(cmat,3);
newVec = get_triu(acmat);
Z = linkage(1-newVec,'ward');
this_lbls = albls{roi_or_task}
d = figure(3)
nclust = [3 5];
[h clust perm] = dendrogram(Z,nclust(roi_or_task),'labels',this_lbls);
[h x perm] = dendrogram(Z,'labels',this_lbls);
ord = perm(end:-1:1);
[h(1:end).LineWidth] = deal(3);
d.CurrentAxes.XTickLabelRotation = 45;
d.CurrentAxes.FontSize = 12;
d.CurrentAxes.FontWeight = 'bold'
box off
{'Regional' 'Task'};title({[ans{roi_or_task} ' Similarity'] ttl},'FontSize',20)
d.CurrentAxes.YAxis.Label.String = 'Dissimilarity'
tr = 1
d.Color = [tr tr tr]
d.CurrentAxes.Color = [tr tr tr];
%saveas(d,['/Users/aidasaglinskas/Desktop/Figures/' datestr(datetime) '.png'],'png')
% MDS scale
cc{1} = { [.5 0 1] [1 0 0] [0 .5 0]}
cc{2} = {[1 0 0] [1 0 1] [0 0 1] [1 .5 0] [0 .8 .8]}
md_fig = figure(4);clf
mdd = mdscale(1-newVec,2);
for i = 1:length(mdd)
    T = text(mdd(i,1),mdd(i,2),this_lbls{i})
    T.Color = cc{roi_or_task}{clust(i)};
    T.FontSize = 12;
    T.FontWeight = 'bold';
    T.FontName = 'ComicSans'
end

xoff = max(mdd(:,1)) * .1;
yoff = max(mdd(:,2)) * .1;
md_fig.CurrentAxes.XLim = [min(mdd(:,1))-xoff max(mdd(:,1))+xoff*2];
md_fig.CurrentAxes.YLim = [min(mdd(:,2))-yoff max(mdd(:,2))+yoff];
md_fig.Color = [1 1 1];
md_fig.CurrentAxes.FontWeight = 'bold';
md_fig.CurrentAxes.FontSize = 12;

% Add colour
figure(3)
if roi_or_task == 1
c_inds = [1 2 2 1 1 2 2 3 1 1 2 1 3 1 3 2 1 1];
c = {[1 0 0] [0 1 0] [.5 0 1]}
thick_inds = [19 20];
h(end).LineWidth = 7

[h(1:length(c_inds)).Color] = deal(c{c_inds})
[h(thick_inds).LineWidth] = deal(h(1).LineWidth*2);
%
elseif roi_or_task == 2
    ticklabels = get(gca,'XTickLabel');
    ticklabels_new = cell(size(ticklabels));
    %ccc = { 'green' 'green' 'red' 'red' 'magenta' 'magenta' 'blue' 'blue' 'cyan' 'cyan'}
    %ccc = { 'green' 'green' 'orange' 'orange' 'magenta' 'magenta' 'red' 'red' 'cyan' 'cyan'}
    all_c{1} = { 'red' 'red' 'magenta' 'magenta' 'blue' 'blue' 'orange' 'orange' 'cyan' 'cyan'}
    
    all_c{2} = { 'red' 'red' 'magenta' 'magenta' 'blue' 'blue' 'orange' 'orange' 'cyan' 'cyan'}
    
    
    ccc = all_c{exp}
    for i = 1:length(ticklabels)
        cc = ccc{i};
    ticklabels_new{i} = ['\' sprintf('color{%s}',num2str(cc))  ticklabels{i}]
    end
    set(gca, 'XTickLabel', ticklabels_new);
    thick_inds = [8 9];
    [h(thick_inds).LineWidth] = deal(h(1).LineWidth*2);
thick_inds = [8 9]
[h(thick_inds).LineWidth] = deal(h(1).LineWidth*2);
[h(1:end).Color] = deal([0 0 0])
end


figure(5)
add_numbers_to_mat(acmat(ord,ord),this_lbls(ord))
%% New Bootstrapp
% albls
% cmat
this_lbls = albls{roi_or_task};
perm_struct = [];
dist = [];
subjpool = [];
perm_struct.params.nclust = [3 3];
perm_struct.params.nperms = 100;
perm_struct.params.nsubs = 10;
perm_struct.permMat = zeros(perm_struct.params.nperms,size(cmat,1),size(cmat,1));
warning('off','stats:linkage:NotEuclideanMatrix') % Expecto Patronum those pesky warnings
for iter_ind = 1:perm_struct.params.nperms
    if ismember(iter_ind,0:perm_struct.params.nperms/10:perm_struct.params.nperms);disp(sprintf('%d/%d',iter_ind/perm_struct.params.nperms * 100,100));end
subjpool = [];
subjpool(1,:) = randi(size(cmat,3),1,perm_struct.params.nsubs);
subjpool(2,:) = randi(size(cmat,3),1,perm_struct.params.nsubs);

%subjpool(1,:) = 1:20;
%subjpool(2,:) = 1:20;

    perm_struct.commonSubs(iter_ind) = sum(ismember(subjpool(1,:),subjpool(2,:)));
    perm_struct.poolCor(iter_ind) = corr(subjpool(1,:)',subjpool(2,:)');
    dist(1,:) = 1-get_triu(mean(cmat(:,:,subjpool(1,:)),3));
    dist(2,:) = 1-get_triu(mean(ncmat(:,:,subjpool(2,:)),3));
    
[h x1 perm1] = dendrogram(linkage(dist(1,:),'ward'),perm_struct.params.nclust(roi_or_task));
[h x2 perm2] = dendrogram(linkage(dist(2,:),'ward'),perm_struct.params.nclust(roi_or_task));

tmat = zeros(size(cmat,1),size(cmat,1));
for i = 1:size(cmat,1)
r = (x1==x1(i)) & (x2==x2(i));
tmat(find(r),find(r)) = tmat(find(r),find(r))+1;
tmat(tmat>0)=1;
end
perm_struct.permMat(iter_ind,:,:) = tmat;

% % Old/ No good
% for x = unique([x1;x2])'
%     perm_struct.permMat(iter_ind,find(x1==x & x2==x),find(x1==x & x2==x)) = perm_struct.permMat(iter_ind,find(x1==x & x2==x),find(x1==x & x2==x))+1;
% end % ends x

end % ends boot_iterations
% Plot
figure(1)
clf
perm_struct.meanMat = squeeze(mean(perm_struct.permMat,1));
[h x perm] = dendrogram(linkage(1-get_triu(perm_struct.meanMat)))
ord = perm(end:-1:1);
add_numbers_to_mat(perm_struct.meanMat(ord,ord),this_lbls(ord))
figure(2)
clf
schemaball(this_lbls(ord),perm_struct.meanMat(ord,ord))
%% Bar PLOT
loadMR;
pickmat = aBeta.fmat
ttl = 'Word Data' 
r_inds = {[13;14]	[9;10]	[19;20]	[11;12]	[15;16] [5;6]	[1;2]	[3;4]	18	21	17	[7;8]	};
r_lbls = {'OFA'	'FFA'	'pSTS'	'IFG' 'OFC'	'Amygdala'	'ATFP' 'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular'};
%r_inds = {[13;14]	[9;10]	[19;20]	[11] [12]	[15;16]	[3;4]	18	21	17	[7] [8]	[5;6]	[1;2]};
%r_lbls = {'OFA'	'FFA'	'pSTS'	'IFG-L' 'IFG-R' 'OFC'	'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular-left' 'Angular-right'	'Amygdala'	'ATFP'};
mat = [];
aBeta.trim.t_inds{end+1} = 11
aBeta.trim.t_lbls{end+1} = 'FaceCC'
aBeta.trim.t_inds{end+1} = 12
aBeta.trim.t_lbls{end+1} = 'MonCC'
for r = 1:length(r_inds)
for t = 1:length(aBeta.trim.t_inds)
mat(r,t,:) = mean(mean(pickmat(r_inds{r},aBeta.trim.t_inds{t},:),2),1);
end
end
%mat = mat - mat(:,6,:);
disp(size(mat))
% Bar Plot
% IFG ATL[4 6]
% pSTS Ang [3 10]
r_ind = [1:length(r_inds)];
mat = mat;
% 11 = IFGLeft
% 12  = IFGRight
tt = [1:5];
m = squeeze(mean(mat(r_ind,:,:),3));
sdc = arrayfun(@(x) std(squeeze(mat(x,:,:))'),r_ind,'UniformOutput',0);
sd = reshape(cell2mat(sdc),size(m));
se = sd / sqrt(20);
m = m(:,tt);
se = se(:,tt);
xlbls = r_lbls(r_ind);
%m = m ./ sd
% Data to be plotted as a bar graph
f = figure(1);
clf;
model_series = m;
%Data to be plotted as the error bars
%model_error = [1 4 8 6; 2 5 9 12; 3 6 10 13];
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
c = distinguishable_colors(7)
for i = 1:length(tt)%5
h(i).FaceColor = c(tt(i),:);
end
ax.YGrid = 'on';
{'-' '--' ':' '-.' 'none'}
ax.GridLineStyle = ans{1};
xticks(ax,[1:length(r_ind)]);
% Naming each of the bar groups
xticklabels(ax,xlbls);
f.CurrentAxes.FontSize = 14;
f.CurrentAxes.FontWeight = 'bold'
% X and Y labels
%xlabel ('Brain Region');
ylabel ('Brain Response');
% Creating a legend and placing it outside the bar plot
%lg = legend('A','B','C','D','AutoUpdate','off','northwest');
lg = legend(aBeta.trim.t_lbls(tt));
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
%f.CurrentAxes.YLim = [-3 7];
title(ttl,'Fontsize',20)
%% regional F test
addpath('/Users/aidasaglinskas/Downloads/anova_rm-1/')
help anova_rm
loadMR;
matt =  [];
for t = 1:length(aBeta.trim.t_inds)
matt(:,t,:) = mean(aBeta.fmat(:,aBeta.trim.t_inds{t},:),2);
matr(:,t,:) = mean(aBeta.fmat_raw(:,aBeta.trim.t_inds{t},:),2);
end
%r_ind = [11 12];
r_ind = aBeta.trim.r_inds{2}
disp(aBeta.r_lbls(r_ind));
matt = matt;
amat = {squeeze(matt(r_ind(1),:,:))' squeeze(matt(r_ind(2),:,:))'};
[p, table] = anova_rm(amat);
%% regional T test
clc
r_ind = 4;
mat_raw = mat;
mat_reduced = squeeze(mat_raw(r_ind,:,:));
pairs = nchoosek(1:5,2);
disp(r_lbls{r_ind})
for i = 1:length(pairs)
[H,P,CI,STATS] = ttest(mat_reduced(pairs(i,1),:)',mat_reduced(pairs(i,2),:)');
if P < .05
str = sprintf('%s-%s: t(%d) = %s, p=%s',aBeta.trim.t_lbls{pairs(i,1)},aBeta.trim.t_lbls{pairs(i,2)},STATS.df,num2str(round(STATS.tstat,4),'%10.4f'),num2str(round(P,4),'%10.4f'));
disp(str)
end
end
%bar(mean(mat,2))
%% Cluster Correlation stats
loadMR
mat = aBeta.fmat;
cmat = []
for i = 1:20
cmat.t(:,:,i) = corr(mat(:,:,i));
cmat.r(:,:,i) = corr(mat(:,:,i)');
end

aBeta.r_list = arrayfun(@(x) [num2str(x) ':' aBeta.r_lbls{x}],1:length(aBeta.r_lbls),'UniformOutput',0)';
aBeta.t_list = arrayfun(@(x) [num2str(x) ':' aBeta.t_lbls{x}],1:length(aBeta.t_lbls),'UniformOutput',0)';
c_inds = {[20 21 7 8 11 12 13 14 15 16] [1 2 5 6 17 18 19] [3 4 9 10]};
t_inds = {[6 10] [1 5 7 8] [2 3 4 9]}
%t_inds = {[6 10 1 5 7 8] [2 3 4 9]}
%% Cluster within-across correlation
cm = cmat;
c_inds = t_inds
for ind = 1:3;
within = cmat.t(c_inds{ind},c_inds{ind},:);
within = arrayfun(@(x) mean(get_triu(within(:,:,x))),1:20)';
w(ind,:) = within;
across = cmat.t(c_inds{ind},find(ismember([1:10],c_inds{ind}) == 0),:)
across = squeeze(mean(mean(across,1),2));
a(ind,:) = across;
end
[H,P,CI,STATS] = ttest(mean(w)',mean(a)');
clc
STATS.P = num2str(P);
disp(STATS);
%%
loadMR
exp_mats = {aBeta.fmat aBeta.wmat};
w_exp = 1; % 1 = Face data 2 = word data
mat = exp_mats{w_exp};
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

%trim = trim - mean(trim,2);
mtrim = mean(trim,3);

tmat = []; tmat2 = [];
for r = 1:length(r_inds)
for t = 1:length(t_inds)
this_vec = squeeze(trim(r,t,:));
other_vec = squeeze(mean(trim(r,find([1:5]~=t),:),2));
%other_vec = squeeze(mean(trim(r,6,:),2));
[H,P,CI,STATS] = ttest(this_vec,other_vec);
tmat2(r,t) = STATS.tstat;
[H,P,CI,STATS] = ttest(this_vec);
tmat(r,t) = STATS.tstat;
end
end

% th = 2;
% tmat(tmat<th) = 0;
% tmat(tmat>th) = th;
% tmat = tmat+rand(size(tmat))*.1;

use_mat = tmat;
use_t_lbls = wh_t_labels;
use_r_lbls = wh_r_labels;
    r_ind = (1); % Prep
    rho = use_mat(:,r_ind);
    sep = .60;
    angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;
plt_list = [1 0.1 .7	 % Episodic
.5 0 1 % Factual
0 0 1 % Social
1 .7 0 % Physical
0 .6 0 % Nominal
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
%subplot(2,2,[1 3])
%
mats = {tmat tmat2};
sp_list = {[[1 2 5 6 9 10]] 3 7 11 4 8 12};
wh_plot_list = {1:5 5 3:4 1:2 5 3:4 [1:2]};
ttls = {'Face Data' 'Word Data'};
sp_ttls = {ttls{w_exp} 'Raw' '' '' 'Region Preference Enchancd' '' ''};

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


%saveas(f,['/Users/aidasaglinskas/Desktop/Figures/' datestr(datetime) '.png'],'png')
%% Radial Plot OLD
% loadMR
% mat = aBeta.fmat;
% to_trim = mat;
% 
% r_inds = {[13;14]	[9;10]	[19;20]	[11;12]	[15;16]	[3;4]	18	21	17	[7;8]	[5;6]	[1;2]};
% wh_r_labels = {'OFA'	'FFA'	'pSTS'	'IFG'	'OFC'	'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular'	'Amygdala'	'ATFP'};
% 
% t_inds = aBeta.trim.t_inds
% wh_t_labels = aBeta.trim.t_lbls
%     
% aBeta.r_lbls
% trim = [];
% for r = 1:length(r_inds)
% for t = 1:length(t_inds)
% trim(r,t,:) = squeeze(mean(mean(to_trim(r_inds{r},t_inds{t},:),1),2));
% end
% end
% mtrim = mean(trim,3);
% tmat = [];
% 
% 
% 
% for r = 1:length(r_inds)
% for t = 1:length(t_inds)
% this_vec = squeeze(trim(r,t,:));
% other_vec = squeeze(mean(trim(r,find([1:5]~=t),:),2));
% %other_vec = squeeze(mean(trim(r,6,:),2));
% [H,P,CI,STATS] = ttest(this_vec,other_vec);
% tmat(r,t) = STATS.tstat;
% end
% end
% use_mat = tmat;
% 
% 
% nm = mean(trim,3)
% sd = std(trim,[],3);
% se = sd ./ sqrt(20);
% f = figure(3);clf
% bar(nm);hold on
% %errorbar(nm(:,:),se(:,4),'r*')
% legend(wh_t_labels)
% f.CurrentAxes.XTickLabel  = wh_r_labels
% f.CurrentAxes.XTickLabelRotation = 45
% 
% 
% 
% 
% %use_mat = zscore(use_mat,[],2)
% %use_mat = zscore(use_mat,[],1)
% 
% use_t_lbls = wh_t_labels;
% use_r_lbls = wh_r_labels;
%     r_ind = (1); % Prep
%     rho = use_mat(:,r_ind);
%     sep = .60;
%     angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;
% plt_list = [0 .9 0 %  nominal green 
% .9 1 0 % physical
% 0 .9 .9 %socal 
% 1 0 0 % episodic
% .5 0 1 %factual
% 0	0	.3
% 0	0	.5
% 0	0	.5
% 0	.5	.5
% 0	.5	.5
% 0	0	.5
% 0	0	.5
% 0	.5	.5
% 0	.5	.5];
% 
% f = figure(13);
% clf;
% subplot(2,2,[1 3])
% for sp =  1:4
% {[1 3 5] 2 4 6};subplot(3,2,ans{sp})
% %{1:5 1:3 4:5};wh_plot = ans{sp}
% {1:5 5 [3 4] 1:2};wh_plot = ans{sp}
% for i = wh_plot
% %r_ind = randi(10)
% r_ind = (i);
% rho = use_mat(:,r_ind);
% %g = polarplot(angle,rho,plt{r_ind})
% pp = {'r-.o' 'r-o' 'r-o'  'r-o' 'r-o' 'r-o' 'r-o' 'r-o'};
% g = polarplot(angle,rho,pp{sp},'Color',plt_list(i,:),'LineWidth',3);
% g.MarkerSize = 30
% g.Marker = '.'
% hold on
% end
% f.Color = [1 1 1]
% f.CurrentAxes.Layer = 'top'
% f.CurrentAxes.LineWidth = 3
% f.CurrentAxes.RLim = [min(use_mat(:)) max(use_mat(:))];
% f.CurrentAxes.ThetaTick = rad2deg(angle);
% f.CurrentAxes.ThetaTickLabel = use_r_lbls;
% f.CurrentAxes.ThetaGrid = 'on';
% f.CurrentAxes.FontSize = 15;
% f.CurrentAxes.FontWeight = 'bold';
% l = legend(use_t_lbls(wh_plot),'location','northeastoutside');
% %l.Position = [0.8363    0.8127    0.1110    0.1564];
% end % ends suplot