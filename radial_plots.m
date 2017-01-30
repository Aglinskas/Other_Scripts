%tmat
%rho = repmat(3,1,10);
% Plt options
a = { 'm'    'c'    'r'    'g'    'b'   'k'} % 'y' 'w'
b = { '-' } %  '--'    ':'    '-.'
bb = { 'o'    '+'    '*'    '.'    'x'    's'    'd'    '^'    'v'    '>'    '<'    'p'    'h'    'none'}
c = CombVec(a,b,bb)';
plt = arrayfun(@(x) [c{x,1} c{x,3} c{x,2}],1:length(c),'UniformOutput',0)';
plt = Shuffle(plt);

t_lbls = t_labels(subBeta.ord_t);
r_lbls = r_labels(subBeta.ord_r);
%r_ind = randi(10)

f = figure(1)
clf
r_inds = [1 2]
for r_ind = r_inds
rho = tmat(:,r_ind)
rho = abs(rho)
angle = 0:(2*pi)/(length(rho)-1):2*pi;
disp('Cleared')
g = polarplot(angle,rho,plt{r_ind})
hold on
disp('Plotted')
%rad2deg(angle)
f.CurrentAxes.ThetaTick = rad2deg(angle)
f.CurrentAxes.ThetaTickLabel = r_lbls;
legend(t_lbls{r_inds},'location','Northeast')
end