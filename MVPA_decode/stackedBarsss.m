load('/Users/aidasaglinskas/Desktop/decoding.mat');
loadMR;
%%

l = [];

rinds = {[1 2] [3 4] [5 6] [7 8] [9 10] [11 12] [13 14] [15 16] [17] [18] [19] [20 21]};
rlbls = {'ATL' 'Amy' 'Ang.' 'FFA' 'ATFP' 'IFG' 'OFA' 'OFC' 'mPFC' 'Prec' 'dmPFC' 'pSTS'};

for m_ind = 1:length(rinds);
for t_ind = 1:length(aBeta.trim.t_inds)    
exp_ind = 2;
this_mat = res{exp_ind}(1:10,1:10,rinds{m_ind},:);
b = nanmean(mean(mean(this_mat,4),3),2)';
b(b<0) = nan
l(m_ind,t_ind) = mean(b(aBeta.trim.t_inds{t_ind}));
end
end

for i = 1:12
   l(i,:) = l(i,:) ./ nansum(l(i,:))
end
%%

f = figure(1)
bar(l,'stacked')
f.CurrentAxes.XTickLabel = rlbls
legend(aBeta.trim.t_lbls)