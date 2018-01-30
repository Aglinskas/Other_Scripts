loadMR
addpath('/Users/aidasaglinskas/Downloads/pierremegevand-errorbar_groups-0e167a1/')
%mats = {aBeta.fmat_raw aBeta.wmat_raw}
mats = {aBeta.fmat aBeta.wmat}
mats{3} = cat(3,mats{1},mats{2})

exp_ttls = {'Face Data' 'Word Data' 'Combined Word+Face Data'}
exp_ind = 3
mat = mats{exp_ind}

    %t_inds = {[1     5]   [7     8]     [3     4]   [  2     9]    [ 6    10]   [ 11]    [12]};
    %t_lbls = {'Episodic','Factual','Social','Physical','Nominal','FaceCC','MonCC'};
    t_inds = {[1     5]   [7     8]     [3     4]   [  2     9]    [ 6    10]};
    t_lbls = {'Episodic','Factual','Social','Physical','Nominal'};
    r_inds = {[13;14]	[9;10]	[19;20]	[11] [12]	[15;16]	[1;2]	[5;6]	[3;4]	[7;8]	17	18	21};
    r_lbls = {'OFA'	'FFA'	'pSTS'	'IFG-L' 'IFG-R'	'OFC'	'ATFP'	'Amygdala'	'ATL'	'Angular'	'Precuneus'	'dmPFC'	'vmPFC'};
    %r_inds = {[13;14]	[9;10]	[19;20]	[11;12]	[15;16]	[1;2]	[5;6]	[3;4]	[7;8]	17	18	21};
    %r_lbls = {'OFA'	'FFA'	'pSTS'	'IFG'	'OFC'	'ATFP'	'Amygdala'	'ATL'	'Angular'	'Precuneus'	'dmPFC'	'vmPFC'};
    drop = [1 2 3 7 8];
    drop = find(~ismember(r_lbls,{'OFC' 'Angular'}))
    r_inds(drop) = []
    r_lbls(drop) = []

redmat = [];
for r = 1:length(r_inds)
for t = 1:length(t_inds)
redmat(r,t,:) = mean(mean(mat(r_inds{r},t_inds{t},:),1),2);
end
end


m =  mean(redmat,3);
stdev = std(redmat,[],3);
se = stdev ./ sqrt(size(redmat,3));
[H,P,CI,STATS] = ttest(permute(redmat,[3 1 2]));


bar_input = m'
%bar_input = squeeze(STATS.tstat)'
errorbar_input = se'

errorbar_groups(bar_input,errorbar_input)
%errorbar_groups(bar_input,squeeze(CI(1,:,:))',squeeze(CI(2,:,:))')

f = gcf;
f.CurrentAxes.XTickLabel = r_lbls
f.CurrentAxes.FontSize = 14
f.CurrentAxes.FontWeight = 'bold'
f.CurrentAxes.YLim = [0 max(max(bar_input))+ max(max(errorbar_input))]
f.Color = [1 1 1]
legend(t_lbls);
title(exp_ttls{exp_ind},'FontSize',20)