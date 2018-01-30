loadMR;
%%
figure(2)
r_inds = {[13;14]	[9;10]	[19;20]	[11;12]	[15;16]	[3;4]	18	21	17	[7;8]	[5;6]	[1;2]};
r_lbls = {'OFA'	'FFA'	'pSTS'	'IFG' 'OFC'	'ATL'	'dmPFC'	'vmPFC'	'Precuneus'	'Angular'	'Amygdala'	'ATFP'};
mat = [];
for r = 1:length(r_inds)
for i = 1:5
mat(r,i,:) = mean(mean(aBeta.fmat(r_inds{r},aBeta.trim.t_inds{i},:),2),1);
end
end

perc_mat = [];
for r_ind = 1:size(mat,1);
vals = mean(mat(r_ind,:,:),3);
%vals = vals - min(vals);
perc = vals ./ sum(vals);
perc_mat(r_ind,:) = perc;
end

clf;bar(perc_mat,'stacked')
legend(aBeta.trim.t_lbls)
xticklabels(r_lbls)