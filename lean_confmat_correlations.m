fl = '/Users/aidas_el_cap/Desktop/RSA_ana/all_conf24-May-2016 19:07:00.mat';
load(fl)
subvect = [ 8     9    10    11    14    15    17    18    19    20    21]
%% Without control task
which_ind_temp = ismember(pairs,[11 12]);
which_ind = sum(which_ind_temp,2);
new_pairs = pairs(find(which_ind == 0),:);
new_pair_ind = find(which_ind == 0);
new_pair_ind = new_pair_ind';
%% override?
new_pair_ind = 1:length(pairs);
mat_size = length(unique(pairs(new_pair_ind,:)))
%%
% %% Make confusion matrix array
% confmats = repmat(0,length(roi_name),max(subvect),mat_size,mat_size);
% for roi_ind = 1:length(roi_name) % for all the rois
% for subID = subvect
% for pair_ind = new_pair_ind
% confmats(roi_ind,subID,pairs(pair_ind,1),pairs(pair_ind,2)) = mean(rawall_corResult{roi_ind,subID,pair_ind}.samples);
% confmats(roi_ind,subID,pairs(pair_ind,2),pairs(pair_ind,1)) = mean(rawall_corResult{roi_ind,subID,pair_ind}.samples);
% end
% end
% end
%% Mean accuracy across tasks
% clear all_cor_mats
% clear r_cormat
% mat_size = 10;
% all_cor_mats = repmat(666,length(rois),mat_size,mat_size);
% for roi_ind = 1:length(rois);
% for pair_ind = new_pair_ind%1:length(pairs);
%     %roi_name{roi_ind};
%     %lbls(pairs(pair_ind,:))';
% r_cormat(pairs(pair_ind,1),pairs(pair_ind,2)) = mean([meanall_corResult{roi_ind,subvect,pair_ind}]);
% r_cormat(pairs(pair_ind,2),pairs(pair_ind,1)) = mean([meanall_corResult{roi_ind,subvect,pair_ind}]);
% end
% all_cor_mats(roi_ind,1:mat_size,1:mat_size) = r_cormat;
% end
%% Let's do it raw bb
%reshape(all_cor_mats(length(rois),:,:),12,12)
%      7     8     9    10    11    14    15    17    18    19    20    21    22
%   mean(rawall_corResult{roi,subID,pair}.samples)
clear submat
clear submats
submats = repmat(nan,length(roi_name),length(subvect),mat_size,mat_size);
size(submats)
for roi_ind = 1:length(roi_name);
for subID = subvect;
for pair_ind = new_pair_ind%1:length(pairs)
    submat(pairs(pair_ind,1),pairs(pair_ind,2)) = mean(rawall_corResult{roi_ind,subID,pair_ind}.samples);
    submat(pairs(pair_ind,2),pairs(pair_ind,1)) = mean(rawall_corResult{roi_ind,subID,pair_ind}.samples);
end
submats(roi_ind,subID,:,:) = submat;
end
end
%submats(roi,subID,task,task)
%% Plot Decoding Accuracies Across ROIs
which_rois_to_cor = 1:32;

mean(mean(submats(which_rois_to_cor,subvect,:,:),4),3)


singmat = nan

ofn  = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion8/';
ttl_both = {'Region Correlation %s' 'Across all the old ROIs' 'with controls'};
%singmat(find(isnan(singmat))) = 1;
this_mat_lbls = {roi_name{which_rois_to_cor}}

%this_mat_lbls = {this_mat_lbls{12:-1:1}}'
% more or less self sufficient code
if exist(ofn) == 0; mkdir(ofn);end
m = figure(4);
m.Position =[-1279 -123 1280 928];
imagesc(singmat);
colorbar
textStrings = num2str(singmat(:),'%0.2f');
textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:length(singmat));
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = max(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(singmat(:) > midValue,1,3);  %# Choose white or black for the
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
m.CurrentAxes.XAxis.TickValues = [1:length(singmat)];
m.CurrentAxes.YAxis.TickValues = [1:length(singmat)];
m.CurrentAxes.XTickLabel = this_mat_lbls;
m.CurrentAxes.YTickLabel = this_mat_lbls;
ttl_m = cellfun(@(x) sprintf(x,'Matrix'),ttl_both,'UniformOutput',false)';
m.CurrentAxes.XTickLabelRotation = 45;
title(ttl_m);
%colorbar
%export_fig([ofn [ttl{:}]],'-jpg')
saveas(m,[ofn ['m_' ttl_m{:}]],'jpg')
d = figure(5);
d.Position =[-1279 -123 1280 928];
%Z = linkage(singmat);
Z = linkage(singmat,'ward');
%dendrogram(Z,'ColorThreshold','default')
dendrogram(Z,'Orientation','left','ColorThreshold','default');
ttl_d = cellfun(@(x) sprintf(x,'Dendogram'),ttl_both,'UniformOutput',false)';
title(ttl_d);
d.CurrentAxes.YAxis.TickLabels = {this_mat_lbls{str2num(d.CurrentAxes.YAxis.TickLabels)}};
saveas(d,[ofn ['d_' ttl_d{:}]],'jpg')
%%
% %% Wanna plot accuracy dends and mats? 
% ofn  = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion6/';
% set(m, 'visible','off')
% if exist(ofn) == 0; mkdir(ofn);end
% for roi_ind = 1:length(roi_name2)
% %singmat = reshape(mean(confmats(roi_ind,subvect,:),2),mat_size,mat_size);
% singmat = squeeze(mean(submats(roi_ind,subvect,:,:),2));
% m = figure(4);
% %m.Position =[ -1279        -123        1280         928]
% imagesc(singmat);
% colorbar
% textStrings = num2str(singmat(:),'%0.2f');
% textStrings = strtrim(cellstr(textStrings));
% [x,y] = meshgrid(1:mat_size);
% hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
% midValue = max(get(gca,'CLim'));  %# Get the middle value of the color range
% textColors = repmat(singmat(:) > midValue,1,3);  %# Choose white or black for the
%                                              %#   text color of the strings so
%                                              %#   they can be easily seen over
%                                              %#   the background color
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
% m.CurrentAxes.XAxis.TickValues = [1:mat_size];
% m.CurrentAxes.YAxis.TickValues = [1:mat_size];
% m.CurrentAxes.XTickLabel = {lbls{1:12}};
% m.CurrentAxes.YTickLabel = {lbls{1:12}};
% ttl = {roi_name2{roi_ind} 'Decoding Accuracy Matrix' ['All Subs Averaged, nvoxels ' num2str(length(rawall_corResult{roi_ind,7,1,1}.samples))]};
% title(ttl);
% %colorbar
% %export_fig([ofn [ttl{:}]],'-jpg')
% saveas(m,[ofn ['m_' ttl{:}]],'jpg')
% d = figure(5);
% %d.Position =[ -1279        -123        1280         928]
% Z = linkage(singmat,'ward');
% %dendrogram(Z,'ColorThreshold','default')
% dendrogram(Z);
% ttl = {roi_name2{roi_ind} 'Decoding Accuracy Dendogram' ['All Subs Averaged, nvoxels ' num2str(length(rawall_corResult{roi_ind,7,1,1}.samples))]};
% title(ttl);
% d.CurrentAxes.XAxis.TickLabels = {lbls{str2num(d.CurrentAxes.XAxis.TickLabels)}};
% %export_fig([ofn [ttl{:}]],'-jpg')
% saveas(d,[ofn ['d_' ttl{:}]],'jpg')
% end
%%
% Z = linkage(A,'ward')
% dendrogram(Z)
%% REGION CORRELATIONS
% Pay attention to oi pair inds
clear all_roicormats
clear roicormat
which_rois_to_cor = 21:32;%[1:length(roi_name)];
% roi_pairs = nchoosek(1:length(roi_name),2);
roi_pairs = nchoosek(which_rois_to_cor,2);
n_rois = length(which_rois_to_cor);
roicormat = nan(n_rois,n_rois);
for subID = subvect;
for pair_ind = 1:length(roi_pairs);%1:length(pairs) %Roi pairs
    % grabs a roi pair, (pair_inds), flattens the conf_mat into 1xn
    % venctor, corrleates 'em, puts them into a matrix, easy peasy
c = corrcoef(reshape(submats(roi_pairs(pair_ind,1),subID,:,:),1,[])',reshape(submats(roi_pairs(pair_ind,2),subID,:,:),1,[])');
roicormat(roi_pairs(pair_ind,1),roi_pairs(pair_ind,2)) = c(1,2);
roicormat(roi_pairs(pair_ind,2),roi_pairs(pair_ind,1)) = roicormat(roi_pairs(pair_ind,1),roi_pairs(pair_ind,2));
end
all_roicormats(subID,:,:) = roicormat;
end
%imagesc(squeeze(mean(all_roicormats,1)))
%% PLOT ROI CORRELATION MATRIX
ofn  = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion9/';
ttl_both = {'Region Correlation %s' 'Across all the old ROIs' '1-newVec'};
singmat = squeeze(mean(all_roicormats(subvect,which_rois_to_cor,which_rois_to_cor),1));
singmat = singmat
%singmat(find(isnan(singmat))) = 1;
this_mat_lbls = {roi_name{which_rois_to_cor}}
%this_mat_lbls = {this_mat_lbls{12:-1:1}}'
% more or less self sufficient code
if exist(ofn) == 0; mkdir(ofn);end
m = figure(4);
m.Position =[-1279 -123 1280 928];
imagesc(singmat);
colorbar
textStrings = num2str(singmat(:),'%0.2f');
textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:length(singmat));
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = max(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(singmat(:) > midValue,1,3);  %# Choose white or black for the
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
m.CurrentAxes.XAxis.TickValues = [1:length(singmat)];
m.CurrentAxes.YAxis.TickValues = [1:length(singmat)];
m.CurrentAxes.XTickLabel = this_mat_lbls;
m.CurrentAxes.YTickLabel = this_mat_lbls;
ttl_m = cellfun(@(x) sprintf(x,'Matrix'),ttl_both,'UniformOutput',false)';
m.CurrentAxes.XTickLabelRotation = 45;
title(ttl_m);
%colorbar
%export_fig([ofn [ttl{:}]],'-jpg')
saveas(m,[ofn ['m_' ttl_m{:}]],'jpg')
d = figure(5);
d.Position =[-1279 -123 1280 928];
%Z = linkage(singmat);
% Z = linkage(singmat,'ward');
Z = linkage(1-newVec,'ward');
%dendrogram(Z,'ColorThreshold','default')
dendrogram(Z,'Orientation','left','ColorThreshold','default');
ttl_d = cellfun(@(x) sprintf(x,'Dendogram'),ttl_both,'UniformOutput',false)';
title(ttl_d);
d.CurrentAxes.YAxis.TickLabels = {this_mat_lbls{str2num(d.CurrentAxes.YAxis.TickLabels)}};
saveas(d,[ofn ['d_' ttl_d{:}]],'jpg')
%%

%reshape(submats(1,7,:,:),1,12*12)'
% %% REGION CORRELATIONS
% % Pay attention to oi pair inds
% clear all_roicormats
% clear roicormat
% 
% which_rois_to_cor = [2:22];
% % roi_pairs = nchoosek(1:length(roi_name),2);
% roi_pairs = nchoosek(which_rois_to_cor,2);
% n_rois = length(roi_name);
% roicormat = nan(n_rois,n_rois);
% for subID = subvect;
% for pair_ind = 1:length(roi_pairs);%1:length(pairs) %Roi pairs
%     % grabs a roi pair, (pair_inds), flattens the conf_mat into 1xn
%     % venctor, corrleates 'em, puts them into a matrix, easy peasy
% c = corrcoef(reshape(submats(roi_pairs(pair_ind,1),subID,:,:),1,[])',reshape(submats(roi_pairs(pair_ind,2),subID,:,:),1,[])');
% roicormat(roi_pairs(pair_ind,1),roi_pairs(pair_ind,2)) = c(1,2);
% roicormat(roi_pairs(pair_ind,2),roi_pairs(pair_ind,1)) = roicormat(roi_pairs(pair_ind,1),roi_pairs(pair_ind,2));
% end
% all_roicormats(subID,:,:) = roicormat;
% end
% %imagesc(squeeze(mean(all_roicormats,1)))
% %%
% %% PLOT ROI CORRELATION MATRIX
% 
% ofn  = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion7/';
% ttl_both = {'Region Correlation %s' 'Across all 32 ROIs'};
% singmat = squeeze(mean(all_roicormats,1))
% singmat(find(isnan(singmat))) = 1;
% 
% this_mat_lbls = roi_name;
% % more or less self sufficient code
% if exist(ofn) == 0; mkdir(ofn);end
% m = figure(4);
% m.Position =[-1279 -123 1280 928];
% imagesc(singmat);
% colorbar
% textStrings = num2str(singmat(:),'%0.2f');
% textStrings = strtrim(cellstr(textStrings));
% [x,y] = meshgrid(1:length(singmat));
% hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
% midValue = max(get(gca,'CLim'));  %# Get the middle value of the color range
% textColors = repmat(singmat(:) > midValue,1,3);  %# Choose white or black for the
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
% m.CurrentAxes.XAxis.TickValues = [1:length(singmat)];
% m.CurrentAxes.YAxis.TickValues = [1:length(singmat)];
% m.CurrentAxes.XTickLabel = this_mat_lbls;
% m.CurrentAxes.YTickLabel = this_mat_lbls;
% ttl_m = cellfun(@(x) sprintf(x,'Matrix'),ttl_both,'UniformOutput',false)';
% m.CurrentAxes.XTickLabelRotation = 45;
% title(ttl_m);
% %colorbar
% %export_fig([ofn [ttl{:}]],'-jpg')
% saveas(m,[ofn ['m_' ttl{:}]],'jpg')
% d = figure(5);
% d.Position =[-1279 -123 1280 928];
% Z = linkage(singmat,'ward');
% %dendrogram(Z,'ColorThreshold','default')
% dendrogram(Z,'Orientation','left','ColorThreshold','default');
% ttl_d = cellfun(@(x) sprintf(x,'Dendogram'),ttl_both,'UniformOutput',false)';
% title(ttl_d);
% d.CurrentAxes.YAxis.TickLabels = {this_mat_lbls{str2num(d.CurrentAxes.YAxis.TickLabels)}};
% saveas(d,[ofn ['d_' ttl{:}]],'jpg')







%%
% %%
% %size(all_roicormats)
% reshape(all_roicormats(subvect(1),:,:),32,32)
% ofn  = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion5/';
% avg_roicormat = reshape(mean(all_roicormats(subvect,:,:),1),n_rois,n_rois);
% m = figure(4)
% imagesc(avg_roicormat)
% m.CurrentAxes.XAxis.TickValues = [1:12];
% m.CurrentAxes.YAxis.TickValues = [1:12];
% m.CurrentAxes.XTickLabel = {roi_name{1:12}};
% m.CurrentAxes.YTickLabel = {roi_name{1:12}};
% ttl = {'Decoding Accuracy Correlations Across Regions' 'All Subs Averaged Controls Dropped'}
% title(ttl)
% colorbar
% saveas(m,[ofn [ttl{:}]],'jpg')
% d = figure(5)
% Z = linkage(avg_roicormat,'ward')
% dendrogram(Z)
% ttl = {'Decoding Accuracy Correlations Across Regions' 'All Subs Averaged Controls Dropped'}
% title(ttl)
% d.CurrentAxes.XAxis.TickLabels = {roi_name{str2num(d.CurrentAxes.XAxis.TickLabels)}};
% saveas(d,[ofn [ttl{:}]],'jpg')
% %%
% for s = subvect;
% for r = 1:10
% for c = 1:10
%     if submats(s,r,c) == submat(r,c)
%     else error(['yo shiet don''match check   ' sprintf('s ==%d,r == %d,c == %d',s,r,c)])
%     end
% end
% end
% end
% disp('all is good in da hood')
% %%    