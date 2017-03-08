%tmat
%rho = repmat(3,1,10);
clear all
loadMR
t_lbls = ttrim.tlbls%t_labels(subBeta.ord_t);
r_lbls = ttrim.rlbls%r_labels(subBeta.ord_r);
r_lbls = {'OFA'    'FFA'    'IFG'    'Orb'    'ATL'    'Precuneus'    'pSTS'    'mPFC'  'Amygdala'    'atFP'}
%rho = abs(rho)
%ttrim.mat = abs(ttrim.mat)
r_ind = (1)
rho = ttrim.mat(:,r_ind);
sep = .5
angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;
% Plt options
a = { 'm'       'r'     'b'   'k'} % 'y' 'w' 'c'  'g'  
b = { '-'    '--'      '-.'} %':' 
bb = { 'o'    '+'    '*'    '.'    'x'    's'    'd'    '^'    'v'    '>'    '<'    'p'    'h'}
c = CombVec(a,b,bb)';
plt = arrayfun(@(x) [c{x,1} c{x,3} c{x,2}],1:length(c),'UniformOutput',0)';
plt = Shuffle(plt); %end of plot options
plt = { 'kp-.'   'bs-'    'm*-.'     'gd--'  'r^-'    'r^-'}
plc = {[0 .5 0] [0 0 1] [.4 0 0] [.7 0 0] [1 0 0]}
% figure plotting
f = figure(1)
clf
wh_plot_pool = {[1 2],[3 4 5],[1:5]}
for s = 1:length(wh_plot_pool)
subplot(1,length(wh_plot_pool),s)
    
wh_plot = wh_plot_pool{s}
% start loop
%'Nominal'    'Physical'    'Social'    'Episodic'    'Facts'

for i = 1;wh_plot
set(gca,'color','none')
%r_ind = randi(10)
r_ind = (i)
rho = ttrim.mat(:,r_ind);
%rho(rho<0) = 0;
%rho = abs(rho);
disp('Cleared')
%g = polarplot(angle,rho,plt{r_ind},'LineWidth',3)
g = polarplot(angle,rho,'-*','Color',plc{r_ind},'LineWidth',3)

paxis = get(g,'Parent');
paxchild = allchild(paxis);
ppatch = paxchild(end);
disp('Plotted')
hold on 
end
%rad2deg(angle)
f.CurrentAxes.RLim = [min(ttrim.mat(:)) max(ttrim.mat(:))]
f.CurrentAxes.ThetaTick = rad2deg(angle)
f.CurrentAxes.ThetaTickLabel = r_lbls;
legend(t_lbls{wh_plot},'location','Northeast')
f.CurrentAxes.Legend.FontSize = 14
f.CurrentAxes.FontWeight = 'Bold'
f.CurrentAxes.FontSize = 16
f.CurrentAxes.Legend.Color = 'none'
end
%saveas(f,'/Users/aidasaglinskas/Desktop/b.png','png')
%%
export_fig(['/Users/aidasaglinskas/Desktop/2nd_Fig/Radial_plots/' datestr(datetime) '.png'],'-transparent')
%export_fig('/Users/aidasaglinskas/Desktop/b.png','-transparent')
disp('done')
