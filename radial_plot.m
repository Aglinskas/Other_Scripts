clear all
loadMR

use_mat = ttrim.mat;
use_t_lbls = ttrim.tlbls;
use_r_lbls = ttrim.rlbls;

    r_ind = (1); % Prep
    rho = use_mat(:,r_ind);
    sep = .35;
    angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;

plt_list = [1	0	0
.5	0	0
0	.3	0
0	.5	0
0	.7	0
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
g = polarplot(angle,rho,'Color',plt_list(i,:),'LineWidth',3);
hold on
end

f.CurrentAxes.RLim = [min(use_mat(:)) max(use_mat(:))];
f.CurrentAxes.ThetaTick = rad2deg(angle);
f.CurrentAxes.ThetaTickLabel = use_r_lbls;
f.CurrentAxes.ThetaGrid = 'on';
f.CurrentAxes.FontSize = 15;
f.CurrentAxes.FontWeight = 'bold';
legend(use_t_lbls(wh_plot),'location','Northeast');


