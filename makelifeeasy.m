load('/Volumes/Aidas_HDD/MRI_data/subBetaArray_32.mat')
load('/Users/aidas_el_cap/Desktop/Tasks.mat')
which_rois = 2:20;
conds = 10; % how many pics
tasks = 10; % how mnay analyzed
avgB = squeeze(mean(subBetaArray,3));
makeLifeEasy = avgB(which_rois,:);% (Roi,task)
% masks_name
masks_dir = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/new_masks/';
masks = dir(masks_dir); masks = {masks([masks.isdir] == 0).name}';
masks_name = masks;
masks_ext = {'may24_' '.nii'};
% preallocate subbetarray with nans
n_subs = 13;
n_tasks = 12;
subBetaArray(1:length(masks),1:n_tasks,1:n_subs) = nan;
for i = 1:length(masks_ext);masks_name = cellfun(@(x) strrep(x,masks_ext{i},''),masks_name,'UniformOutput', false);end
%% Plot 'em!
clf
%makeLifeEasy=squeeze(mean(myData,1)); % (rois,tasks)average across subjects at least for now
for ii=9%1:conds
    plot_lim = [0 6]
    xlim(plot_lim);
    ylim([-2 6]);
   p = figure(1);
   %subplot(4,3,ii);
   plot(mean(makeLifeEasy(:,[1:tasks]~=ii),2),makeLifeEasy(:,[1:conds]==ii),'x');
   hold on 

   %%
   hold off
 %title(['CONDS: ' num2str(ii)])
 xlim(plot_lim);
ylim([-2 6]);
title(t{ii});
text(mean(makeLifeEasy(:,[1:tasks]~=ii),2),makeLifeEasy(:,[1:tasks]==ii),{masks_name{which_rois}}');
%saveas(p, ['/Users/aidas_el_cap/Desktop/fucks num2str(ii)],'bmp')
end
%%
%% Get them in a table
tbl = {}
for ii = 1:10
[smtg stats] = robustfit(mean(makeLifeEasy(:,[1:tasks]~=ii),2),makeLifeEasy(:,[1:conds]==ii));
rrs = [stats.resid which_rois'];
rrs = sortrows(abs(rrs),-1);
rrs = num2cell(rrs); to_deal = cellfun(@(x) masks_name{x},rrs(:,2),'UniformOutput',false);
disp(t(ii))
rrs(:,2) = deal(to_deal);
disp(rrs)
%make table
s = size(tbl)
wh = s(2) + 1%length(tbl) + 1;
tbl{1,wh} = t(ii);
tbl(2:length(rrs)+1,wh) = deal({rrs{:,1}}')
s = size(tbl)
wh = s(2) + 1%length(tbl) + 1;
tbl{1,wh} = t(ii);
tbl(2:length(rrs)+1,wh) = deal({rrs{:,2}}')
end
%rrs{:,2} = deal(to_deal)
%%

%subBetaArray(ROI,Task,SUB)
% text(x,y,strcat('(',num2str(x),',',num2str(y,2),')'),...
%      'horiz','center','vert','bottom')
%%
% for i = 1:12
% avgB = squeeze(mean(subBetaArray,3))
% subplot(4,3,i)
% plot
% end
%% 
cols = 1:2:20
for i = cols
a = zscore([tbl{2:end,i}]')
a = num2cell(a)
[tbl{2:end,i}] = deal(a{:})
end