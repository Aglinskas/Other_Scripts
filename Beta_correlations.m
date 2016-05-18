  %% Beta Correlations;
% subBetaArray(Region,Task,Subject)
load('/Volumes/Aidas_HDD/MRI_data/subBetaArray3.mat')
load('/Volumes/Aidas_HDD/MRI_data/roi12_lbls.mat')
load('/Users/aidas_el_cap/Desktop/Tasks.mat')
%%
subvect = [7 8 9 10 11 14 15 17 18 19 20 21 22];
array_size = size(subBetaArray)
%%
%for subID = 1:13;
array_dim = 2;%Region,Task,Subject)
cor_mat = repmat(9,array_size(array_dim),array_size(array_dim));
for r = 1:array_size(array_dim)
for c = 1:array_size(array_dim)
if array_dim == 2
cor_mat(r,c) = corr(mean(subBetaArray(:,r,:),3),mean(subBetaArray(:,c,:),3));
elseif array_dim == 1
cor_mat(r,c) = corr(mean(subBetaArray(r,:,:),3)',mean(subBetaArray(c,:,:),3)');end;
%cor_mat2(r,c) = corr(reshape(reshape(subBetaArray(:,r,:),12,[]),1,[])',reshape(reshape(subBetaArray(:,c,:),12,[]),1,[])');
end
end
%figure;imagesc(cor_mat)
%%
% %% plot Correlation Mats
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/'
if array_dim == 2; 
    mlbls = {t{:,1}}' 
ttl = ['Average Task Correlation (All subs averaged)'] %num2str(subvect(subID)) 
elseif array_dim == 1; 
    mlbls = {master_coords_legend.label} %roi12_lbls %{cor_labels.short_name}' %labels_proper2;%;
ttl = ['Average ROI Correlation (All subs averaged)'] %num2str(subvect(subID)) 
end; %{t{:,1}}' %roi12_lbls; 
m = figure(3);imagesc(cor_mat)
m.CurrentAxes.XTick = [1:array_size(array_dim)];
m.CurrentAxes.YTick = [1:array_size(array_dim)];
m.CurrentAxes.XTickLabel = mlbls;
m.CurrentAxes.YTickLabel = mlbls;
m.Position = [-1279 -223 1280 928]
colorbar
title(ttl)
%%
saveas(m,[ofn ttl '16_rois'],'jpg') %[ofn num2str(subvect(subID))]
% %end
%% Dendograms
%ttl = ['Subject ' num2str(subvect(subID)) ' Task Dendogram']
ttl = ['Average' ' Task Dendogram Across Rois 16']
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/TaskDendogram/'
% mlbls = roi12_lbls; % region labels
%mlbls = {t{:,1}}'; % Task labels
Z = linkage(cor_mat);
m = figure(4);dendrogram(Z);
a = str2num(m.CurrentAxes.XTickLabel);
m.CurrentAxes.XTickLabel = {mlbls{a}}';
title(ttl)
%%
saveas(m,[ofn 'Average Task Dend new'],'jpg') %[ofn num2str(subvect(subID)) 'dend']
%saveas(m,[ofn num2str(subvect(subID)) 'Taskdend'],'jpg') %
%end
%% Plotting beta's
%subBetaArray(Region,Task,Subject)
for subID = 1:13
bar(mean(mean(subBetaArray(1:12,12,subID),3),2))
m.CurrentAxes.XTick = [1:12];
m.CurrentAxes.XTickLabel = mlbls;
title(num2str(subID))
drawnow
WaitSecs(0.5)
KbWait(-1)
WaitSecs(0.5)
end

