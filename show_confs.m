singmat = reshape(mean(confmats(roi_ind,subvect,:),2),mat_size,mat_size);
%%
m = figure(4)
%m.Position =[ -1279        -123        1280         928]
imagesc(singmat)
colorbar
%
textStrings = num2str(singmat(:),'%0.2f');
textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:mat_size)
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = max(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(singmat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
m.CurrentAxes.XAxis.TickValues = [1:mat_size];
m.CurrentAxes.YAxis.TickValues = [1:mat_size];
m.CurrentAxes.XTickLabel = {lbls{1:12}};
m.CurrentAxes.YTickLabel = {lbls{1:12}};
ttl = {'Decoding Accuracy Correlations Across Tasks Mat' 'All Subs Averaged Controls Dropped' roi_name{roi_ind}}
title(ttl)
%colorbar
export_fig([ofn [ttl{:}]],'-jpg')
d = figure(5)
%d.Position =[ -1279        -123        1280         928]
Z = linkage(singmat,'ward')
dendrogram(Z,'ColorThreshold','default')
ttl = {'Decoding Accuracy Correlations Across Tasks Dend'  'All Subs Averaged Controls Dropped' roi_name{roi_ind}}
title(ttl)
d.CurrentAxes.XAxis.TickLabels = {lbls{str2num(d.CurrentAxes.XAxis.TickLabels)}};
%export_fig([ofn [ttl{:}]],'-jpg')
saveas(m,[ofn [ttl{:}]],'jpg')
saveas(d,[ofn [ttl{:}]],'jpg')
%%




% saveas(m,[ofn [ttl{:}]],'jpg')
% saveas(d,[ofn [ttl{:}]],'jpg')
% %all_conf(roi,subid,r,c)
% % all_conf()
% %roi_name
% %lbls
% %imagesc(reshape(all_conf(which_roi,subID,:,:),6,6))
% %% Plots and sanity checks
% %size(all_conf)
% load('/Users/aidas_el_cap/Desktop/Other_Scripts/wrkspc.mat')
% %% Mean Decoding accuracy of subjects
% all_conf(all_conf == 2) = 1;
% [subvect' nanmean(nanmean(all_conf(1,subvect,:,:),3),4)']
% %% Matrices and Dendograms
% roi_ind = 2
% % all_conf(roi,subcject,row,col)
% %[ 7     8     9    10    11    14    15    17    18    19    20    21    22]
% cmat = reshape(mean(all_conf(roi_ind,subvect,:,:),2),12,12);
% 
% cm = figure(4);
% imagesc(cmat,[0 max(cmat(cmat<1))]);
% colorbar
% title(roi_name(roi_ind));
% cm.CurrentAxes.XTick = [1:12]
% cm.CurrentAxes.XTickLabel = lbls;
% cm.CurrentAxes.YTick = [1:12];
% cm.CurrentAxes.YTickLabel = lbls;
% %
% %%
% cc=0;
% cVec=[];
% for ii=1:length(cmat)
%     for jj=ii+1:length(cmat)
%         cc=cc+1;
% cVec(cc)=cmat(ii,jj);
%     end
% end
% 
% %%
% Z = linkage(cVec,'ward');
% dend = figure(5)
% dendrogram(Z)
% dend.CurrentAxes.XTick = [1:12]
% dend.CurrentAxes.XTickLabel = lbls;
% title(roi_name(roi_ind))
% %%
% % a = mean(all_conf(:,subvect,:,:),2);
% % a(1,1,1,1)
% % %all_conf(1,1,4,4)