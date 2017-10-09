

mat = aBeta.fmat;
to_trim = mat;
    r_inds = {[1 2] [3 4] [5 6] [7 8 ] [9 10] [11 12] [13 14] [ 15 16] [17] [18]}
    t_inds = {[1 5] [7 8] [3 4] [2 9] [6 10]}
    wh_t_labels = {'Episodic' 'Factual' 'Social' 'Physical' 'Nominal' };
    wh_r_labels = { 'ATL' 'Amygdala' 'pSTS' 'FFA' 'Face Patch' 'IFG' 'OFA' 'Orb' 'PFCmedial' 'Precuneus'};

for r = 1:length(r_inds)
for t = 1:length(t_inds)
trim(r,t,:) = squeeze(mean(mean(to_trim(r_inds{r},t_inds{t},:),1),2));
end
end
mtrim = mean(trim,3)

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

tmat_fig = figure(9);
add_numbers_to_mat(tmat,wh_t_labels,wh_r_labels)
    tmat_fig.CurrentAxes.FontSize = 12
    tmat_fig.CurrentAxes.FontWeight = 'bold'
    title('Tmatrix Trim', 'fontsize',20)



use_mat = tmat;
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
0	.5	.5];

f = figure(1);
clf;
wh_plot = 1:5% Draws them in similarity order%[1:10]
for i = wh_plot

%r_ind = randi(10)
r_ind = (i);
rho = use_mat(:,r_ind);
%rho(rho<0) = 0;
%rho = abs(rho);

%g = polarplot(angle,rho,plt{r_ind})
g = polarplot(angle,rho,'r-o','Color',plt_list(i,:),'LineWidth',3);
g.MarkerSize = 30
g.Marker = '.'
hold on
end

f.CurrentAxes.RLim = [min(use_mat(:)) max(use_mat(:))];
f.CurrentAxes.ThetaTick = rad2deg(angle);
f.CurrentAxes.ThetaTickLabel = use_r_lbls;
f.CurrentAxes.ThetaGrid = 'on';
f.CurrentAxes.FontSize = 15;
f.CurrentAxes.FontWeight = 'bold';
l = legend(use_t_lbls(wh_plot),'location','Northeast');
%l.Position = [0.8363    0.8127    0.1110    0.1564];
f.CurrentAxes.LineWidth = 1


f.Position = [144   185   695   419];
l.Position = [0.8270    0.7856    0.1388    0.1301];
ex = 0;
if ex
l.Color = 'none'
f.Color = 'none'
f.CurrentAxes.Color = 'none'
ofn = '/Users/aidasaglinskas/Desktop/Figures/all/Rad1_wLegend.pdf';
export_fig(ofn,'-pdf','-transparent')
end