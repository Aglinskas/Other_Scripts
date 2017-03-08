clear all
loadMR

use_mat = tmat.sorted.array;
use_mat = use_mat(1:2:end,:);
use_t_lbls = tmat.sorted.lbls_t;
use_r_lbls = tmat.sorted.lbls_r(1:2:end);

    r_ind = (1); % Prep
    rho = use_mat(r_ind,:);
    sep = .35;
    angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;

plt_list = [.3	0	0
.4	0	0
.5	0	0
.6	0	0
.7	0	0
.8	0	0
.9	0	0
1	0	0
0	.3	0
0	.4	0
0	.5	0
0	.6	0
0	.7	0
0	.8	0
0	0	.3
0	0	.4
0	0	.5
0	0	.6];

f = figure(1);
plt_list = plt_list(1:2:end,:);

clf;
wh_plot = 1:size(use_mat,1)% Draws them in similarity order%[1:10]
for i = wh_plot

%r_ind = randi(10)
r_ind = (i);
rho = use_mat(r_ind,:);
%rho(rho<0) = 0;
%rho = abs(rho);

%g = polarplot(angle,rho,plt{r_ind})
g = polarplot(angle,rho,'Color',plt_list(i,:),'LineWidth',3);
hold on
end
f.CurrentAxes.RLim = [min(use_mat(:)) max(use_mat(:))];
f.CurrentAxes.ThetaTick = rad2deg(angle);
f.CurrentAxes.ThetaTickLabel = use_t_lbls;
f.CurrentAxes.ThetaGrid = 'on';
f.CurrentAxes.FontSize = 15;
f.CurrentAxes.FontWeight = 'bold';
legend(use_r_lbls(wh_plot),'location','Northeast');