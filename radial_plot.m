%tmat
%rho = repmat(3,1,10);
clear all
loadMR
tmat = (tmat)

t_lbls = t_labels(subBeta.ord_t);
r_lbls = r_labels(subBeta.ord_r);
%rho = abs(rho)
r_ind = (1)
rho = tmat(:,r_ind);
sep = .35
angle = 0:(2*pi-sep)/(length(rho)-1):2*pi-sep;
% Plt options
a = { 'm'       'r'     'b'   'k'} % 'y' 'w' 'c'  'g'  
b = { '-'    '--'      '-.'} %':' 
bb = { 'o'    '+'    '*'    '.'    'x'    's'    'd'    '^'    'v'    '>'    '<'    'p'    'h'}
c = CombVec(a,b,bb)';
plt = arrayfun(@(x) [c{x,1} c{x,3} c{x,2}],1:length(c),'UniformOutput',0)';
plt = Shuffle(plt); %end of plot options
plt = { 'kp-.'    'kp-.'    'bs-'    'm*-.'    'bs-'    'gd--'    'gd--'    'm*-.' 'r^-'    'r^-'}
% figure plotting
f = figure(1)
clf
% start loop
wh_plot = [1:10]
for i = wh_plot
%r_ind = randi(10)
r_ind = (i)
rho = tmat(:,r_ind);
%rho(rho<0) = 0;
%rho = abs(rho);
disp('Cleared')
g = polarplot(angle,rho,plt{r_ind})
disp('Plotted')
hold on 
end
%rad2deg(angle)
f.CurrentAxes.RLim = [min(tmat(:)) max(tmat(:))]
f.CurrentAxes.ThetaTick = rad2deg(angle)
f.CurrentAxes.ThetaTickLabel = r_lbls;
legend(t_lbls{wh_plot},'location','Northeast')