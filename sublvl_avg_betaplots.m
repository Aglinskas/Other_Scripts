%Load variables that were used to compute the dends
load('/Users/aidas_el_cap/Desktop/RSA_ana/all_conf24-May-2016 19:07:00.mat')
load('/Users/aidas_el_cap/Desktop/master_rois.mat')
%% Just info
% subvect = [ 7     8     9    10    11    14    15    17    18    19    20    21    22];
% subDir = '/Volumes/Aidas_HDD/MRI_data/S%d/Analysis_mask02/';
% rois_fn = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/new_masks/';
%                     rois = dir([rois_fn '*may24_*.nii']);
% % rois_fn = '/Volumes/Aidas_HDD/MRI_data/Group_anal_m-3_s8n44/';
% %                     rois = dir([rois_fn '*conj_a1*.nii']);
% rois = {rois.name}';
% roi_name = rois;
% % roi_name = cellfun(@(x) strsplit(x,{'oldnii_' '.nii'}),rois,'UniformOutput',false);
% roi_name = cellfun(@(x) regexprep(x,{'may24_' '.nii'},''),rois,'UniformOutput',false);
% % roi_name = cellfun(@(x) x{2},roi_name,'UniformOutput',false);
% load('/Users/aidas_el_cap/Desktop/Tasks.mat');
% lbls = {t{:,1}}';
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/Rois_minus_baseline30/'
mask_dir = '/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/';
ext = 'TrSph';
rois = dir([mask_dir ext '*.nii']);
rois = {rois.name}'
%%
for this_roi_ind = 2:32
for subID = subvect(1);
clear opts_xSPM
this_roi_fn = [mask_dir rois{this_roi_ind}]
this_roi_coords = [master_rois{this_roi_ind,2:4}];
this_roi_name = master_rois{this_roi_ind,5};
opts_xSPM.mask_mask{4} = this_roi_fn
opts_xSPM.mask_which_mask_ind = 4;
set_up_xSPM
spm_results_ui('SetCoords',this_roi_coords)
%  spm_path: '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/SPM.mat'
%             useContrast: 1
%                 p_tresh: 0.9999
%           MC_correction: 'none'
%                k_extent: 0
%     mask_which_mask_ind: 3
%               mask_mask: {1x3 cell}
%             mask_method: {'incl.'  'excl.'}
%                rend_opt: 1
%             mask_maskfn: 'Sphere_MASK_combined_roi2.nii'
%%
%% extract_from_adjusted_cluster
% Plots contrast estimates from a cluster.
% Options:
% opts_clust.size = 
%   1 for whole cluster, (default)
%   2 for adjusted cluster (see adjust_cluster)
% opts_clust.inset:
%   0 prints clean to gcf
%   1 for clear, 
%   2 or mip inset (default);
%   3 for do nothing (clean stays hidden with handle figure(f))
%   4 for plot w/ sections (awesome shit)
%opts_clust.suppress4: using opt 4, suppress output   
Ic = 1; % which contrast to extract estimates from: F con usually
T_leg = t; % Tasks: Are they  or t_old?
[xyzmm,i] = spm_XYZreg('NearestXYZ',...
spm_results_ui('GetCoords'),xSPM.XYZmm);
spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
A = spm_clusters(xSPM.XYZ); % gets all clusters
j = find(A == A(i));
XYZ = xSPM.XYZ(:,j);
XYZmm = xSPM.XYZmm(:,j);
disp(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm))])
%
% Average across voxels
% if opts_clust.size == 1
%%
beta  = spm_get_data(SPM.Vbeta, XYZ);
ind_beta = spm_get_data(SPM.xY.VY, XYZ);
subBetas = reshape(mean(ind_beta,2),12,13); %subBetas(task,subject) same as beta method
% for i = 1:13
%     subBetas(:,i) = subBetas(:,i) - subBetas(11,i);
% end
stdev = std(subBetas');
se = stdev/sqrt(13);
ResMS = spm_get_data(SPM.VResMS,XYZ);

vx = length(beta);
beta = mean(beta,2);
ResMS = mean(ResMS,2);
Bcov  = ResMS*SPM.xX.Bcov;

CI_cv    = 1.6449;
% compute contrast of parameter estimates and 90% C.I.
%------------------------------------------------------------------
cbeta = SPM.xCon(Ic).c'*beta;
cbeta = cbeta - cbeta(11);
SE    = sqrt(diag(SPM.xCon(Ic).c'*Bcov*SPM.xCon(Ic).c));
%CI    = CI*SE;
CI = CI_cv*se'
CI_old =  CI_cv*SE
% Plot errorbar
%clf
f = figure(500);
subplot(2,1,1);
bar(mean(subBetas,2))
hold on
errorbar(mean(subBetas,2),CI,'rx')
%title([SPM.xCon(Ic).name 'est at cluster' num2str(A(i))])
% if opts_clust.size == 1
%title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm)) ' Voxels'])
%title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(vx) 'Voxels'])
%
ttl = {this_roi_name ['Roi Center: ' num2str(this_roi_coords)] ['Clust Size: ' num2str(length(spm_clusters(xSPM.XYZ)))]};
title(ttl)
%
set(gca,'XTickLabel',T_leg)
% inset
%addpath('/Users/aidas_el_cap/Downloads/inset/')
%h_eb = figure(eb_fig);
%t_fig = figure(5)
%c = a(2).Children(21)
%inset(f,a,0.2); %inset(f,mip,0.2);
colormap(map)
%cluster_bar = gcf;
%f.Position = [93 165 1296 640];
% title(xSPM.title)
%inset(h_eb,hMIPax,0.19
hold off
% opts_clust.inset = 1 for clear, 2 or mip inset (default)
get_sections
%g = sections_fig;
%g = figure(500)
% jj = subplot(2,1,1);
% opts_clust.inset = 0
% copyobj(f.Children(10).Children(:),jj)
% if opts_clust.size == 1
% title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(length(XYZmm)) ' Voxels'])
% else title(['Cluster ' num2str(A(i)) '/' num2str(max(A)) ' Size ' num2str(vx) ' Most significant voxels Voxels'])
% end
% set(jj,'XTickLabel',T_leg)
% jj.XTick = [1:12];
figure(f)
% Rest of the subplots, colormap and position
j = subplot(2,3,4);
copyobj(sag.Children(:),j);
%title(num2str(xyzmm')) < coordinates 
j= subplot(2,3,5);
copyobj(axial.Children(:),j);
j = subplot(2,3,6);
copyobj(cor.Children(:),j);
colormap(map);
f.Position = [1 1 1436 804]
title(['Crosshair at: ' num2str(spm_mip_ui('GetCoords',mip)')])
%% End of figure 
%% Save
if exist(ofn) == 0;mkdir(ofn);end
saveas(f,[ofn this_roi_name],'jpg')
end
end