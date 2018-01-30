load('/Users/aidasaglinskas/Desktop/voxel_data.mat');
ord = [9	10	1	2	3	4	5	6	7	8	11	12	13	14	15	16	18	19	20	21	17];
voxel_data = voxel_data(ord,:);
%%
exp_ind = 1
r_ind = 8
aBeta.list_R
this_ds = voxel_data{r_ind,exp_ind};
rfx_mat = func_MVPA_decode(this_ds);

f = figure(2);
f.CurrentAxes.Title.String = {f.CurrentAxes.Title.String{:} 'Decoding accuracies'};
% Plot Beta Values
f = figure(3);clf;
expmats = {aBeta.fmat aBeta.wmat};
expmat = expmats{exp_ind};
sd = std(squeeze(expmat(r_ind,:,:))');
se = sd ./ sqrt(size(expmat,3));
bar(mean(expmat(r_ind,:,:),3));
hold on;
errorbar(mean(expmat(r_ind,:,:),3),se,'r*');
f.CurrentAxes.XTickLabel = aBeta.t_lbls(1:10);
f.CurrentAxes.XTickLabelRotation = 45;
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
ttl = {m.exp_lbls{exp_ind} strrep(aBeta.r_lbls{r_ind},'.mat','') 'beta values'}
title(ttl,'fontsize',20)