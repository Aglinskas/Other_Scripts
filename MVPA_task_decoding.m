clear all
loadMR
subDir = '~/Google Drive/MRI_data/S%d/Analysis_mask02/';
rois_fn = '~/Google Drive/ROI_masks/';
rois = dir([rois_fn '*.nii']);rois = {rois.name}';roi_name = rois;
roi_name = cellfun(@(x) strrep(x,'.nii',''),rois,'UniformOutput',0)
lbls = tasks;
%% prepare
processors = 2;
all_conf(1:length(rois),1:max(subvect),1:12,1:12) = 2;
pairs = nchoosek(1:12,2);
results_set = repmat(nan,length(rois),length(pairs),max(subvect));
%results_set(which_roi,subID,paircomp) = mean(corr_results.samples); % Aidas
%%
for which_roi = 1:length(rois);
for subID = subvect;
single_sub_conf_mat = repmat(2,12,12);
subbetas = dir(sprintf([subDir 'beta_*'],subID));
target_betas =  {subbetas(find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)).name}';

parfor paircomp = 1:length(pairs);
%1:12:60
%%
% if subID == 7
%     disp(['Roi ' num2str(which_roi) '/' num2str(length(roi_name)) ' ' roi_name{which_roi}])
% end

disp(sprintf('Running Roi %d/%d, sub %d',which_roi,length(rois),subID))
mask = fullfile(rois_fn,rois{which_roi});
all_scans = struct;
single_scan  = struct;
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

corr_results=cosmo_searchlight(all_scans,nbrhood,measure,opt,'nproc',processors);% ,'nproc',4
%corr_results.samples=corr_results.samples-(1/40);
corr_results.samples=corr_results.samples-(1/length(unique(all_scans.sa.targets)));

meanall_corResult{which_roi,subID,paircomp} = mean(corr_results.samples);

results_set(which_roi,paircomp,subID) = mean(corr_results.samples); % Aidas

rawall_corResult{which_roi,subID,paircomp} = corr_results;

%to_conf_mat = [which_tasks mean(corr_results.samples)]
% single_sub_conf_mat(which_tasks(1),which_tasks(2)) = mean(corr_results.samples);
% single_sub_conf_mat(which_tasks(2),which_tasks(1)) = mean(corr_results.samples);

% single_sub_conf_mat(which_roi,subID,paircomp,) = mean(corr_results.samples);
% single_sub_conf_mat{which_tasks(2),which_tasks(1)} = mean(corr_results.samples);


% r structure has the accuracies
% r{1,1} = 'mean accuracy';
% r{1,2} = 'max accuracy';
% r{1,3} = '#vx above 2% accuracy';
% r{1,4} = '#vx above 3% accuracy';
% r{1,5} = '#vx above 4% accuracy';
% r{2,1} = mean(corr_results.samples);
% r{2,2} = max(corr_results.samples);
% r{2,3} = length(find(corr_results.samples > 0.02));
% r{2,4} = length(find(corr_results.samples > 0.03));
% r{2,5} = length(find(corr_results.samples > 0.04));
% all_r{which_roi,subID,paircomp} = r;
% [which_tasks(1),which_tasks(2)]
% r'
%%
%%

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
%save('/Users/aidas_el_cap/Desktop/RSA_ana/all_conf','all_conf')
save(['~/Google Drive/MVPA_data/all_conf_' datestr(datetime)])
end
disp('All done')