clear all
loadMR

use_mat = ttrim.mat;
use_t_lbls = ttrim.tlbls;
ttrim.tlbls{5} = 'Factual';
use_r_lbls = ttrim.rlbls;
use_r_lbls = {'OFA'    'FFA'    'IFG'    'Orb G.'    'ATL'    'Precuneus'    'pSTS'    'mPFC'    'Amygdala'    'atFP'}

    r_ind = (1); % Prep
    rho = use_mat(:,r_ind);
    sep = .60;
    angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;

% plt_list = [.5	0	0
% 1 0  0 
% 0	.3	0
% 0	.5	0
% 0	.7	0
% 0	0	.3
% 0	0	.5
% 0	0	.5
% 0	.5	.5
% 0	.5	.5];

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