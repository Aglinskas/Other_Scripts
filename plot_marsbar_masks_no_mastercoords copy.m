%Load variables that were used to compute the dends
%load('/Users/aidas_el_cap/Desktop/RSA_ana/all_conf24-May-2016 19:07:00.mat')
%load('/Volumes/Aidas_HDD/MRI_data/master_coords30.mat')
%load('/Volumes/Aidas_HDD/MRI_data/subvect.mat')
loadMR
nsubs = length(subvect);
% Just info
ofn = '~/Desktop/2nd_Fig/Rois_minus_baseline_September21/';
mask_dir = '/Users/aidasaglinskas/Google Drive/MRI_data/Group3_Analysis_mask02/new_masks/';
spm_dir = '/Users/aidasaglinskas/Google Drive/MRI_data/Group31_Analysis_mask02/'
% get the masks to be used
rois = dir([mask_dir '*.nii']);
rois = {rois.name}';
roi_name = rois;
roi_name = cellfun(@(x) regexprep(x,{'may24_' '.nii'},''),rois,'UniformOutput',false);
lbls = tasks;
%%

%mask_dir = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/new_masks/';
%%
for this_roi_ind = 1:length(rois)
%for subID = subvect(1);
clear opts_xSPM
opts_xSPM.spm_path = [spm_dir 'SPM.mat']
this_roi_fn = [mask_dir rois{this_roi_ind}]
%this_roi_coords = [master_rois{this_roi_ind,2:4}];
%this_roi_name = master_rois{this_roi_ind,1};
opts_xSPM.mask_mask{4} = this_roi_fn
opts_xSPM.mask_which_mask_ind = 4;
set_up_xSPM
%spm_results_ui('SetCoords',this_roi_coords)
this_roi_coords = spm_mip_ui('Jump',mip,'glmax')';
this_roi_name = strrep(rois{this_roi_ind},'.nii','');
master_coords{this_roi_ind,1} = this_roi_coords;
master_coords{this_roi_ind,2} = this_roi_name;
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
% subtract baseline
beta = beta';
beta = beta - repmat(beta(:,11),1,12);
beta = beta';

ind_beta = spm_get_data(SPM.xY.VY, XYZ);
subBetas = reshape(mean(ind_beta,2),12,nsubs); %subBetas(task,subject) same as beta method
subBetas =subBetas'
subBetas = subBetas - repmat(subBetas(:,11),1,12);
% for i = 1:13
%     subBetas(:,i) = subBetas(:,i) - subBetas(11,i);
% end

%%
stdev = std(subBetas);
se = stdev/sqrt(nsubs);
ResMS = spm_get_data(SPM.VResMS,XYZ);
vx = length(beta);
beta = mean(beta,2);
ResMS = mean(ResMS,2);
Bcov  = ResMS*SPM.xX.Bcov;
CI_cv    = 1.6449;
% compute contrast of parameter estimates and 90% C.I.
%------------------------------------------------------------------
cbeta = SPM.xCon(Ic).c'*beta;
%cbeta = cbeta - cbeta(11);
SE    = sqrt(diag(SPM.xCon(Ic).c'*Bcov*SPM.xCon(Ic).c));
%CI    = CI*SE;
CI = CI_cv*se'
CI_old =  CI_cv*SE
% Plot errorbar
%clf
f = figure(500);
subplot(2,1,1);
bar(mean(subBetas',2))
hold on
errorbar(mean(subBetas',2),CI,'rx')
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
%f.Position = [-1279        -123        1280         928]
title(['Crosshair at: ' num2str(spm_mip_ui('GetCoords',mip)')])
%% End of figure 
%% Save
if exist(ofn) == 0;mkdir(ofn);end
saveas(f,[ofn this_roi_name],'jpg')
%export_fig([ofn 'Rois_minus_baseline_goodmPFC_30subs'],'-pdf','-append')
end
%end