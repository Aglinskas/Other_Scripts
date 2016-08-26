%%
load('/Volumes/Aidas_HDD/MRI_data/subBetaArray_32.mat')
load('/Users/aidas_el_cap/Desktop/master_rois.mat')
%%
clear Roi_cor_w_mean
% 2:20 21:32
rois = 2:32;
% preallocate Roi_cor_w_mean
Roi_cor_w_mean(1:max(rois)) = nan;
chosen_rois = this %21:32; %2:20   21:32
for which_roi = chosen_rois %max(rois);
n_mean = squeeze(mean(subBetaArray(which_roi,1:10,:),3))';
n_minusone_mean = squeeze(mean(mean(subBetaArray(chosen_rois(chosen_rois ~= which_roi),1:10,:),1),3))';
% rois(rois ~= 2)
%master_rois{:,5}
% subBetaArray(roi,task,sub)
Roi_cor_w_mean(which_roi) = corr(n_mean,n_minusone_mean);
end
Roi_cor_w_mean = Roi_cor_w_mean';
Roi_cor_w_mean(chosen_rois);
{masks_name{chosen_rois}}';
%
clear r
to_deal = num2cell(Roi_cor_w_mean(chosen_rois));
to_deal_nm = {masks_name{chosen_rois}}';
[r(1:length(Roi_cor_w_mean(chosen_rois))).cor] = deal(to_deal{:});
[r(1:length(Roi_cor_w_mean(chosen_rois))).name] = deal(to_deal_nm{:})
[~,index] = sortrows([r.cor].'); r = r(index(end:-1:1)); clear index;
[r.cor]'
{r.name}'




%%
r(1:length(chosen_rois)).cor = Roi_cor_w_mean
%%
%%
Roi_cor_w_mean = sort(Roi_cor_w_mean)
p = figure
bar(Roi_cor_w_mean(rois))
ttl = {'Roi Correlation with n-1 Roi' 'New Rois'}
title(ttl)
p.CurrentAxes.XTick = rois
p.CurrentAxes.XTickLabel = {masks_name{rois}}
p.CurrentAxes.XTickLabelRotation = 45;
%% Dends?
Z = linkage(-Roi_cor_w_mean,'ward')
d = figure
dendrogram(Z)
d.CurrentAxes.XTickLabel = masks_name;
d.CurrentAxes.XTickLabelRotation = 45;



