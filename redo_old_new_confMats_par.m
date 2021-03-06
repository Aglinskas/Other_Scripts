loadMR
subDir = '~/Google Drive/MRI_data/S%d/Analysis_mask02/';
rois_fn = '~/Google Drive/ROI_masks/';
rois = dir([rois_fn '*.nii']);
rois = {rois.name}';
roi_name = rois;
lbls = tasks;
pairs = nchoosek(1:18,2);
%%
%for which_roi = 1%2:length(rois);
for subID = subvect(1);
single_sub_conf_mat = repmat(2,18,18);
subbetas = dir(sprintf([subDir 'beta_*'],subID));
target_betas =  {subbetas(find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)).name}';

parfor paircomp = 1:length(pairs);
    
    
disp(['Running subject ' num2str(subID) ' Comparison: ' num2str(paircomp) '/' num2str(length(pairs))])
mask1 = fullfile(rois_fn,rois{pairs(paircomp,1)});
mask1 = fullfile(rois_fn,rois{pairs(paircomp,2)});
all_scans = struct;
single_scan  = struct;
which_tasks = pairs(paircomp,:);

for m_ind = pairs(paircomp,:);
for run = 1:5
for task = 1:12
single_scan = cosmo_fmri_dataset(fullfile(sprintf(subDir,subID),target_betas{task + run*12 - 12}),'mask',mask,'targets',task,'chunks',run);
if run == 1 & m_ind == pairs(paircomp,1);
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

corr_results=cosmo_searchlight(all_scans,nbrhood,measure,opt,'nproc',2);% ,'nproc',4
corr_results.samples=corr_results.samples-(1/length(unique(all_scans.sa.targets)));

meanall_corResult{which_roi,subID,paircomp} = mean(corr_results.samples);;
rawall_corResult{which_roi,subID,paircomp} = corr_results;
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
%save('/Users/aidas_el_cap/Desktop/RSA_ana/all_conf','all_conf')
save(['~/Google Drive/MVPA_data/all_conf_' datestr(datetime)])
%end
disp('All done')