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
roi_name = cellfun(@(x) x{2},roi_name,'UniformOutput',false);
load('/Users/aidas_el_cap/Desktop/Tasks.mat')
lbls = {t{:,1}}';
%% prepare
all_conf(1:length(rois),1:max(subvect),1:12,1:12) = 2; 
pairs = nchoosek(1:12,2);
for which_roi = 1:5%length(rois);
for subID = subvect;
single_sub_conf_mat = repmat(2,12,12);
for paircomp = 1:length(pairs);
subbetas = dir(sprintf([subDir 'beta_*'],subID));
target_betas =  {subbetas(find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)).name}';
%1:12:60
%%
if subID == 7
    disp(['Roi ' num2str(which_roi) '/' num2str(length(roi_name)) ' ' roi_name{which_roi}])
end
disp(['Running Sub ' num2str(subID)])
mask = fullfile(rois_fn,rois{which_roi});
clear all_scans
clear single_scan

which_tasks = pairs(paircomp,:);
%disp(['Pair ' num2str(which_tasks)])
for run = 1:5
for task = which_tasks
single_scan = cosmo_fmri_dataset(fullfile(sprintf(subDir,subID),target_betas{task + run*12 - 12}),'mask',mask,'targets',task,'chunks',run);
if run == 1 & task == which_tasks(1);
all_scans=single_scan;else
all_scans = cosmo_stack({all_scans,single_scan});end
%disp(['stacking' num2str(run) '/' num2str(task) ' out of ' '5/12'])
end
end
all_scans.sa.labels = all_scans.sa.targets;
all_scans.sa.labels = arrayfun(@(x) lbls{x},all_scans.sa.labels,'UniformOutput',false);
% clear_all_scans = cosmo_remove_useless_data(all_scans);
% ds = all_scans;
%% Decoding
%opts
%disp('nbrhood')
nbrhood = cosmo_spherical_neighborhood(all_scans, 'radius', 10);
%disp('choosing measure')
measure=@cosmo_crossvalidation_measure;  % pick to classify
%disp('picking struct')
opt=struct();
opt.classifier=@cosmo_classify_lda;
%disp('opt.partitions')
opt.partitions=cosmo_nchoosek_partitioner(all_scans,1);

corr_results=cosmo_searchlight(all_scans,nbrhood,measure,opt,'nproc',4);% ,'nproc',4
%corr_results.samples=corr_results.samples-(1/40);
corr_results.samples=corr_results.samples-(1/length(unique(all_scans.sa.targets)));
all_corResult{which_roi,subID,paircomp} = corr_results;
% r structure has the accuracies
r{1,1} = 'mean accuracy';
r{1,2} = 'max accuracy';
r{1,3} = '#vx above 2% accuracy';
r{1,4} = '#vx above 3% accuracy';
r{1,5} = '#vx above 4% accuracy';
r{2,1} = mean(corr_results.samples);
r{2,2} = max(corr_results.samples);
r{2,3} = length(find(corr_results.samples > 0.02));
r{2,4} = length(find(corr_results.samples > 0.03));
r{2,5} = length(find(corr_results.samples > 0.04));
all_r{which_roi,subID,paircomp} = r;
% [which_tasks(1),which_tasks(2)]
% r'
%%
%%
single_sub_conf_mat(which_tasks(1),which_tasks(2)) = mean(corr_results.samples);
single_sub_conf_mat(which_tasks(2),which_tasks(1)) = mean(corr_results.samples);
%imagesc(reshape(all_conf(which_roi,subID,:,:),6,6))

%% Blank Conf mat




%% %plot individual
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
all_conf(which_roi,subID,:,:) = single_sub_conf_mat;
% Add subject conf to master confs
%master_confs{which_roi} = all_conf;
%% Roi Average Plot
% ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion2/';
% if exist(ofn) == 0; mkdir(ofn);end
% conf = figure(5);
% imagesc(mean(all_conf(:,:,subvect),3));
% drawnow
% conf.CurrentAxes.XTick = [1:12];conf.CurrentAxes.YTick = [1:12];
% conf.CurrentAxes.XTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.XTickLabel)}};
% conf.CurrentAxes.YTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.YTickLabel)}};
% colorbar
% conf.Position = [-1214          -1        1120         806];
% ttl_c = ['AVG Confusion Matrix ' 'All sub Average' roi_name{which_roi}];
% title(ttl_c);
% saveas(conf,[ofn ttl_c],'jpg');
% Z = linkage(mean(all_conf(:,:,subvect),3));
% dend = figure(4);dendrogram(Z);
% drawnow
% dend.Position = [-1274          -6        1267         811];
% ttl_d = ['AVG Dendogram ' 'All sub Average' roi_name{which_roi}];
% title(ttl_d);
% dend.CurrentAxes.XTickLabel = lbls(str2num(dend.CurrentAxes.XTickLabel));
% saveas(dend,[ofn ttl_d],'jpg');
end
save('/Users/aidas_el_cap/Desktop/RSA_ana/all_conf','all_conf')
end
disp('All done')