% figure
% voxInRoi=250;
% tasks=12;
% data=randn(tasks,voxInRoi);
% corrMat=corr(data');
% imagesc(corrMat)
% figure(gcf)
%% 
subvect = [ 7     8     9    10    11    14    15    17    18    19    20    21    22];
subDir = '/Volumes/Aidas_HDD/MRI_data/S%d/Analysis_mask02/';
rois_fn = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/';
                    rois = dir([rois_fn '*old*.nii']);
rois = {rois.name}';
roi_name = cellfun(@(x) strsplit(x,{'oldnii_' '.nii'}),rois,'UniformOutput',false);
roi_name = cellfun(@(x) x{2},roi_name,'UniformOutput',false)
load('/Users/aidas_el_cap/Desktop/Tasks.mat')
lbls = {t{:,1}}';
%%
for which_roi = 1:length(rois);
for subID = subvect;
subbetas = dir(sprintf([subDir 'beta_*'],subID));
target_betas =  {subbetas(find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)).name}';
%1:12:60
%%
if subID == 7
    disp(['Roi ' num2str(which_roi) '/' num2str(length(roi_name)) ' ' roi_name{which_roi}])
end
disp(['Running Sub ' num2str(subID)])
%which_roi = 1;
mask = fullfile(rois_fn,rois{which_roi});
clear all_scans
clear single_scan
for run = 1:5
for task = 1:12
single_scan = cosmo_fmri_dataset(fullfile(sprintf(subDir,subID),target_betas{task + run*12 - 12}),'mask',mask,'targets',task,'chunks',run);

if run == 1 & task == 1;
all_scans=single_scan;else
all_scans = cosmo_stack({all_scans,single_scan});end
%disp(['stacking' num2str(run) '/' num2str(task) ' out of ' '5/12'])
end
end
all_scans.sa.labels = all_scans.sa.targets;
all_scans.sa.labels = arrayfun(@(x) lbls{x},all_scans.sa.labels,'UniformOutput',false);
clear_all_scans = cosmo_remove_useless_data(all_scans);
ds = all_scans;
%% Confusion Matrix
    args=struct();
    args.partitions=cosmo_nchoosek_partitioner(ds,1);
    args.output='predictions';
    args.classifier=@cosmo_classify_lda;
    pred_ds=cosmo_crossvalidation_measure(ds,args);
    confusion=cosmo_confusion_matrix(pred_ds.sa.targets,pred_ds.samples);
all_conf(:,:,subID) = confusion;
% %% plot individual
% ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion/';
% conf = figure(5);
% conf.Position = [-1214          -1        1120         806]
% imagesc(confusion)
% conf.CurrentAxes.XTick = [1:12];conf.CurrentAxes.YTick = [1:12]
% conf.CurrentAxes.XTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.XTickLabel)}};
% conf.CurrentAxes.YTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.YTickLabel)}};
% colorbar
% ttl_c = ['Confusion Matrix ' 'Subject ' num2str(subID) ' ' roi_name{which_roi}];
% title(ttl_c);
% saveas(conf,[ofn ttl_c],'jpg');
% Z = linkage(confusion);
% dend = figure(4);dendrogram(Z);
% dend.Position = [-1274          -6        1267         811]
% ttl_d = ['Dendogram ' 'Subject ' num2str(subID) ' ' roi_name{which_roi}];
% dend.CurrentAxes.XTickLabel = lbls(str2num(Dend.CurrentAxes.XTickLabel));
% saveas(dend,[ofn ttl_d],'jpg');
end
master_confs{which_roi} = all_conf;
%% Roi Average Plot
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion2/';
if exist(ofn) == 0; mkdir(ofn);end
conf = figure(5);
imagesc(mean(all_conf(:,:,subvect),3));
drawnow
conf.CurrentAxes.XTick = [1:12];conf.CurrentAxes.YTick = [1:12];
conf.CurrentAxes.XTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.XTickLabel)}};
conf.CurrentAxes.YTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.YTickLabel)}};
colorbar
conf.Position = [-1214          -1        1120         806];
ttl_c = ['AVG Confusion Matrix ' 'All sub Average' roi_name{which_roi}];
title(ttl_c);
saveas(conf,[ofn ttl_c],'jpg');
Z = linkage(mean(all_conf(:,:,subvect),3));
dend = figure(4);dendrogram(Z);
drawnow
dend.Position = [-1274          -6        1267         811];
ttl_d = ['AVG Dendogram ' 'All sub Average' roi_name{which_roi}];
title(ttl_d);
dend.CurrentAxes.XTickLabel = lbls(str2num(dend.CurrentAxes.XTickLabel));
saveas(dend,[ofn ttl_d],'jpg');
end
disp('All done')