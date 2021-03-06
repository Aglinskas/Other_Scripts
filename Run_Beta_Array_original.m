clear all
loadMR
%load('/Users/aidasaglinskas/Desktop/mat.mat')

load('/Users/aidasaglinskas/Desktop/mats/ROI_data.mat')
% roi_data.mat([7 8],:,:) = [];
% roi_data.lbls([7 8]) = [];
mat = roi_data.mat
lbls = roi_data.lbls;

aBeta.t_labels = aBeta.t_lbls;

% mat = aBeta.fBeta;
% lbls = aBeta.r_labels;



aBeta.r_labels = lbls
r_ord = 1:length(aBeta.r_labels)
t_ord = [6    10     2     3     9     8     1     4     5     7]
mat_original = mat;

% Correlation Matrix and Dendrogram
roi_or_task = 2; % % Do you want ROI or Task Clustering (Enter 1 or 2 and run it)

% Get Array
%w_s = [ 1     2  5     6     7     8     9    10  12    13    14  16    17];


mat = mat - mat(:,11,:); % subtract face repsonse;
mat = mat(:,1:10,:); % drop the control tasks
mat = zscore(mat,[],2);

% ROI By TASK matrix
avg_mat = mean(mat,3) % Mean across subjects; 
avg_mat_fig = figure(10) % plot
clf
add_numbers_to_mat(avg_mat(r_ord,t_ord))
    avg_mat_fig.CurrentAxes.XTick = 1:10;
    avg_mat_fig.CurrentAxes.YTick = 1:length(r_ord);
    avg_mat_fig.CurrentAxes.XTickLabelRotation = 45;
    avg_mat_fig.CurrentAxes.XTickLabel = aBeta.t_labels(t_ord);
    avg_mat_fig.CurrentAxes.YTickLabel = aBeta.r_labels(r_ord);
    avg_mat_fig.CurrentAxes.FontWeight = 'bold'
    avg_mat_fig.CurrentAxes.LineWidth = 0.0000000001
    avg_mat_fig.CurrentAxes.TickDir = 'out';
    avg_mat_fig.CurrentAxes.Box = 'off'
    avg_mat_fig.CurrentAxes.FontSize = 11;
    title({'ROI x Task beta' 'Subject average'},'FontSize',20);
    
    
c_types = {'Pearson' 'Spearman' 'Kendall'};
c_type = c_types{1};
cmat = [];
for sub_ind = 1:size(mat,3) % Loop through subs
    if roi_or_task == 1
    cmat(:,:,sub_ind) = corr(mat(:,:,sub_ind)','type',c_type);  
    else
    cmat(:,:,sub_ind) = corr(mat(:,:,sub_ind),'type',c_type);
    end
end
avg_cmat = mean(cmat,3);

% FFX Hack 
FFX = 0
    if FFX
if roi_or_task == 2
avg_cmat = corr(avg_mat);
else 
avg_cmat = corr(avg_mat');
end
    end

    albls = {aBeta.r_labels aBeta.t_labels(1:10)}; % All labels
    this_lbls = albls{find(cellfun(@length,albls) == length(avg_cmat))};
    warning('off') % Not euclidean, ignore warning;
    
Z = linkage(1-get_triu(avg_cmat),'ward');
    dend = figure(2)
[h x perm] = dendrogram(Z,'labels',this_lbls)
    title('Dendrogram','Fontsize',20)
    [h(1:end).LineWidth] = deal(3) % linewidhth
    dend.CurrentAxes.FontSize = 14
    dend.CurrentAxes.FontWeight = 'bold'
    dend.CurrentAxes.XTickLabelRotation = 45

% Plot Correlation Matrx
ord = perm(end:-1:1);
ord_c = ord; 
cmat_fig = figure(3)
imagesc(cmat(ord,ord))
title('Correlation Matrix','FontSize',20)
    cmat_fig.CurrentAxes.XTick = 1:length(avg_cmat)
    cmat_fig.CurrentAxes.YTick = 1:length(avg_cmat)
    cmat_fig.CurrentAxes.XTickLabel = this_lbls(ord)
    cmat_fig.CurrentAxes.XTickLabelRotation =45;
    cmat_fig.CurrentAxes.YTickLabel = this_lbls(ord)
    
tmat  = [];
for r_ind = 1:size(mat,1)
for t_ind = 1:size(mat,2)
this_vec = squeeze(mat(r_ind,t_ind,:));
other_vec = squeeze(mean(mat(r_ind,find([1:size(mat,2)] ~= t_ind),:),2));
[H,P,CI,STATS] = ttest(this_vec,other_vec);
tmat(r_ind,t_ind) = STATS.tstat;
end
end
    
b = mat(:,:,2);

tmat_fig = figure(8);
add_numbers_to_mat(tmat(r_ord,t_ord),albls{1}(r_ord),albls{2}(t_ord))
title('Tmatrix','fontsize',20)
% Bootsrapping
b = figure(4);
drawnow
    if roi_or_task == 1
        numClust = 3
    else 
        numClust = 3
    end
%% Bootstrapping
nperms = 100; % Bootsrapping permutations; 
fidmat = zeros(length(avg_cmat),length(avg_cmat),nperms); % Preallocate
for perm_ind = 1:nperms;
    if ismember(perm_ind,0:nperms/10:nperms);
        disp([num2str(perm_ind / nperms * 100) ' % done'])
    end
    
    amat = mean(cmat(:,:,randi(size(mat,3),1,10)),3); %
    Z = linkage(1-get_triu(amat),'ward');
    
    [h x perm] = dendrogram(Z,numClust);
    for i = unique(x)'
        fidmat(find(x==i),find(x==i),perm_ind) = fidmat(find(x==i),find(x==i),perm_ind)+1;
    end
end

avg_fidmat = mean(fidmat,3);
[h x perm] = dendrogram(linkage(1-get_triu(avg_fidmat),'ward'));
b.Visible = 'off'
ord = perm(end:-1:1);
    avg_fidmat_fig = figure(5)
    imagesc(avg_fidmat(ord,ord))
    title('Fidelity Matrix')
    avg_fidmat_fig.CurrentAxes.XTick = 1:length(avg_cmat);
    avg_fidmat_fig.CurrentAxes.YTick = 1:length(avg_cmat);
    avg_fidmat_fig.CurrentAxes.XTickLabel = this_lbls(ord)
    avg_fidmat_fig.CurrentAxes.XTickLabelRotation = 45
    avg_fidmat_fig.CurrentAxes.YTickLabel = this_lbls(ord)
    avg_fidmat_fig.CurrentAxes.FontWeight = 'bold'
    avg_fidmat_fig.CurrentAxes.FontSize = 12;

avg_struct.correlations = avg_cmat;
avg_struct.beta = avg_mat;
avg_struct.fidelity = avg_fidmat;
avg_struct.labels = this_lbls;

sch_ball_fig = figure(7);
clf
schemaball_play(this_lbls(ord),avg_fidmat(ord,ord))
sch_ball_fig.CurrentAxes.Title.String = 'Clustering SchemaBall';
%% Radial Plot & Trm
do_trim = 1
if do_trim
mat = mat_original;
mat = mat  - mat(:,11,:);
mat = mat(:,1:10,:);
mat = zscore(mat,[],2)
mat = zscore(mat,[],1)


to_trim = mat;
if size(mat,1) == 18
    disp('old rois')
r_inds =     {[13,14] [7,8] [11,12] [15,16] [1,2]  18 [5,6] 17 [3,4] [9,10]};
wh_r_labels = {'OFA' 'FFA' 'IFG' 'Orb' 'ATL'  'Precuneus' 'pSTS' 'PFCmedial' 'Amygdala' 'Face Patch'};
 
% elseif size(mat,1) == 21
% disp('new rois')
% r_inds = {[13 14] [7 8] [20 21] [11 12] [15 16] [1 2] [19] [17] [18] [5 6] [3 4] [9 10]};
% wh_r_labels = {'OFA' 'FFA' 'pSTS' 'IFG' 'Orb' 'ATL' 'dMPFC' 'PFCmedial' 'Precuneus' 'Angular' 'Amygdala' 'Face Patch'};
elseif size(mat,1) == 21
r_inds = {[13 14] [7 8] [20 21] [11 12] [15 16] [1 2] [19] [17]  [18] [5 6] [3 4] [9 10]};
wh_r_labels = {'OFA' 'FFA' 'pSTS' 'IFG' 'OFC' 'ATL' 'dmPFC' 'vmPFC'  'Precuneus' 'Angular' 'Amygdala' 'Face Patch'};

% r_inds = {[13 14] [7 8] [20 21] [11 12] [15 16] [1 2] [17]  [18] [5 6] [3 4] [9 10]};
% wh_r_labels = {'OFA' 'FFA' 'pSTS' 'IFG' 'Orb' 'ATL' 'PFCmedial'  'Precuneus' 'Angular' 'Amygdala' 'Face Patch'};
else
    error(sprintf('%d ROIs, wat do',size(mat,1)))
end
    t_inds = {[1 5] [7 8] [3 4] [2 9] [6 10]}
    wh_t_labels = {'Episodic' 'Factual' 'Social' 'Physical' 'Nominal' };
    
trim = [];
for r = 1:length(r_inds)
for t = 1:length(t_inds)
trim(r,t,:) = squeeze(mean(mean(to_trim(r_inds{r},t_inds{t},:),1),2));
end
end

%trim = zscore(trim,[],1)
%trim = zscore(trim,[],2)

mtrim = mean(trim,3);
get(0,'children')

mtrim_fig  = figure(6)
add_numbers_to_mat(mtrim,wh_t_labels,wh_r_labels);

mtrim_fig.CurrentAxes.FontSize = 12
mtrim_fig.CurrentAxes.FontWeight = 'bold'
title('Mean Beta AVG', 'fontsize',20)

tmat = [];
for r = 1:length(r_inds)
for t = 1:length(t_inds)
%trim(r,t,:) = squeeze(mean(mean(to_trim(r_inds{r},t_inds{t},:),1),2));
this_vec = squeeze(trim(r,t,:));
other_vec = squeeze(mean(trim(r,find([1:5]~=t),:),2));
[H,P,CI,STATS] = ttest(this_vec,other_vec);
tmat(r,t) = STATS.tstat;
end
end

%tmat = zscore(tmat,[],2);
%tmat = zscore(tmat,[],1);



tmat_fig = figure(9);
add_numbers_to_mat(tmat,wh_t_labels,wh_r_labels)
    tmat_fig.CurrentAxes.FontSize = 12
    tmat_fig.CurrentAxes.FontWeight = 'bold'
    title('Tmatrix Trim', 'fontsize',20)

use_mat = tmat;
%use_mat = tanh(use_mat);
%use_mat = zscore(use_mat,[],2)
%use_mat = zscore(use_mat,[],1)

use_t_lbls = wh_t_labels;
%ttrim.tlbls{5} = 'Factual';
use_r_lbls = wh_r_labels;
%use_r_lbls = {'OFA'    'FFA'    'IFG'    'Orb G.'    'ATL'    'Precuneus'    'pSTS'    'mPFC'    'Amygdala'    'atFP'}

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

f = figure(13);
clf;
subplot(2,2,[1 3])
for sp =  1:3
{[1 3] 2 4};subplot(2,2,ans{sp})
{1:5 1:3 4:5};wh_plot = ans{sp}
for i = wh_plot
%r_ind = randi(10)
r_ind = (i);
rho = use_mat(:,r_ind);
%g = polarplot(angle,rho,plt{r_ind})
g = polarplot(angle,rho,'r-o','Color',plt_list(i,:),'LineWidth',3);
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
l = legend(use_t_lbls(wh_plot),'location','Northeast');
%l.Position = [0.8363    0.8127    0.1110    0.1564];
end % ends suplot
%%
ex = 0;
if ex
l.Color = 'none'
f.Color = 'none'
f.CurrentAxes.Color = 'none'
ofn = '/Users/aidasaglinskas/Desktop/Figures/all/Rad1_wLegend.pdf';
export_fig(ofn,'-pdf','-transparent')
end
end
%% Export all figures
exp = 0
if exp
fn = '/Users/aidasaglinskas/Desktop/Figures/jul6/';
nm_ext = 'words_ROI_GOODSUBS'
a = get(0,'children');
for i = 1:length(a)
    try
    ttl = a(i).CurrentAxes.Title.String;
    catch 
        ttl = ''
    end
if iscell(ttl);ttl = [ttl{:}];end
saveas(a(i),[fn ttl datestr(datetime) '.png'],'png')
end
end
%%
% 
% m = mean(trim,3);
% s = std(trim,[],3);
% se = s ./ sqrt(20);
% f= figure(6)
% clf
% for r_ind = 1:10
%     subplot(5,2,r_ind)
% bar(m(r_ind,:))
% hold on
% errorbar(m(r_ind,:),se(r_ind,:),'r*')
% 
% f.CurrentAxes.XTickLabel = wh_t_labels;
% f.CurrentAxes.XTickLabelRotation  = 45
% f.CurrentAxes.FontSize = 14
% f.CurrentAxes.FontWeight = 'bold'
% %f.CurrentAxes.XLabel.String = 'Task Category'
% f.CurrentAxes.YLabel.String = 'Beta'
% f.CurrentAxes.Title.String = wh_r_labels{r_ind}
% box off
% f.Color = [1 1 1]
% 
% ofn_dir = '/Users/aidasaglinskas/Desktop/Figures/all/';
% ofn_fn = datestr(datetime);
% fn_ext = 'png';
% saveas(f,[fullfile(ofn_dir,ofn_fn) '.' fn_ext],fn_ext)
% end
%export_fig('/Users/aidasaglinskas/Desktop/a.pdf')