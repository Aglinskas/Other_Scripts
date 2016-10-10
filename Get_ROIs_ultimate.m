analysis_name = '44subs, manual peak, 6mm spheres no trim'
%% Group Average, - Get Peaks
opts_xSPM.spm_path = '/Users/aidasaglinskas/Google Drive/MRI_data/Group_anal_m-3_s8n44/SPM.mat'
opts_xSPM.p_tresh = .001;
opts_xSPM.k_extent = 25;
opts_xSPM.mask_which_mask_ind = 0;
opts_xSPM.useContrast = 1;
opts_xSPM.MC_correction = 'none'
set_up_xSPM
% Get Atlas
L = spm_atlas('list');
xA = spm_atlas('load',L.file);
%% Master Coords way, 
master_coord_fn = '/Users/aidasaglinskas/Google Drive/MRI_data/master_coords_44Peak.mat';
spc = mars_space('/Users/aidasaglinskas/Google Drive/MRI_data/GroupAnalysis_31_6th_Oct/beta_0001.nii');
load(master_coord_fn);
sph_radius = 6;
ofn = '/Users/aidasaglinskas/Google Drive/ROI_masks/Revisited/';
prefix = analysis_name;
%%
clear all_rois combined_rois
for p_ind = 1:length(master_coords)
p_coord = master_coords(p_ind,:);
% Get the xSPM index of the current voxel
a = spm_mip_ui('SetCoords',p_coord,mip);
this_peak_ind = find(xSPM.XYZmm(1,:) == a(1) & xSPM.XYZmm(2,:) == a(2) & xSPM.XYZmm(3,:) == a(3));
%xSPM.XYZ(:,this_peak_ind); gets current voxel coords
                all_clusts = spm_clusters(xSPM.XYZ);
this_clust = all_clusts(this_peak_ind);
this_clust_coords = xSPM.XYZmm(:,find(all_clusts == this_clust));

this_point_list_roi  = maroi_pointlist(struct('XYZ',this_clust_coords,'mat',[]),'vox');
this_sphere_roi = maroi_sphere(struct('centre', p_coord,'radius', sph_radius));

trim_ROI = this_sphere_roi;%this_point_list_roi & this_sphere_roi;
all_rois{p_ind} = trim_ROI; % Collect them all

out_fn = [ofn 'Sph_' prefix ' ' master_coords_labels{p_ind} ' ' num2str(p_coord) '_roi.mat'];
saveroi(trim_ROI,out_fn); % Save ROI mat
mars_rois2img(out_fn,strrep(out_fn,'.mat','.nii'),spc); % and .nii

%size(voxpts(this_sphere_roi,base_space),2)
if p_ind == 1
    combined_rois = trim_ROI;
else
    combined_rois = combined_rois | trim_ROI;
end
end
out_fn = [ofn 'Sph_' prefix 'Combined_ROIs' '_roi.mat'];
saveroi(combined_rois,out_fn); % Save ROI mat
mars_rois2img(out_fn,strrep(out_fn,'.mat','.nii'),spc); % and .nii
%% Extract Beta
disp('Extracting Betas')
subDir_temp = '/Users/aidasaglinskas/Google Drive/MRI_data/S%d/Analysis_mask02/'
%subID = 7
subDir = sprintf(subDir_temp,subID); % inserts subID to template
all_betas = 1:90; %all betas
betas_ind = (find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)); % without 
subBetas = arrayfun(@(x) sprintf([subDir beta_temp],num2str(x,'%0.2u')),betas_ind,'UniformOutput',0)'
%
tic
%clear extracted_betas subBetaArray
subBetaArray = nan(length(all_rois),12,length(subvect));
extracted_betas = nan(length(subvect),length(all_rois),size(subBetas,1));
for s_ind = 1:length(subvect);
    subID = subvect(s_ind);
    subDir = sprintf(subDir_temp,subID);
    subBetas = arrayfun(@(x) sprintf([subDir beta_temp],num2str(x,'%0.2u')),betas_ind,'UniformOutput',0)';
for r_ind = 1:length(all_rois);
disp(sprintf('Extracting betas from: Subject %d | ROI %d',subvect(s_ind),r_ind))
for b_ind = 1:length(subBetas);
y = getdata(all_rois{r_ind},subBetas{b_ind});
extracted_betas(s_ind,r_ind,b_ind) = mean(y);
end
% Mean across runs
for t_ind = 1:12
    subBetaArray(r_ind,t_ind,s_ind) = mean(extracted_betas(s_ind,r_ind,[t_ind:12:60]));
end
end
end
toc
%% COMPUTE DENDOGRAM
fig_ofn = '/Users/aidasaglinskas/Desktop/2nd_Fig/Clustering_Different_ROIS/'

for method = [1 2]; % 1-Fixed Effects, 2-Random Effecs
method_str = {'Fixed Effects (Average then Correlate)' 'Random Effects (Correlate then Average)'}
for roi_or_task = [1 2]; %1-ROI,2-Task
roi_or_task_str = {'ROI Clustering' 'Task Clustering'}

all_lbls = {master_coords_labels,{tasks{1:10}}'};
switch method
    case 1
        disp('Average THEN correlate')
avg_keep = mean(subBetaArray(:,1:10,:),3);
if roi_or_task == 1;
matrix = corr(avg_keep');
elseif roi_or_task == 2;
    matrix = corr(avg_keep);
end
    case 2
        disp('Correlate THEN Average')
        clear keep
for ss = 1:size(subBetaArray,3)
if roi_or_task == 1;
keep(:,:,ss) = corr(subBetaArray(:,1:10,ss)');
elseif roi_or_task == 2;
keep(:,:,ss) = corr(subBetaArray(:,1:10,ss));
end
avg_keep = mean(keep,3);
matrix = avg_keep;
end
end

labels = all_lbls{find(cellfun(@(x) isequal(length(x),length(matrix)),all_lbls) == 1)};
[size(matrix) size(labels)]

newVec = get_triu(matrix);
Z = linkage(1-newVec,'ward');
dend = figure(7);
clf
[h x] = dendrogram(Z,length(matrix),'orientation','left');
ord = str2num(dend.CurrentAxes.YTickLabel);
ord_r = ord(end:-1:1);
dend.CurrentAxes.YTickLabel = {labels{ord}}';
dend.CurrentAxes.FontSize = 16;
[h(1:end).LineWidth] = deal(3)
% TITLE
ttl = {analysis_name method_str{method} roi_or_task_str{roi_or_task}}
title(ttl)
mat = figure(8)
add_numbers_to_mat(matrix(ord_r,ord_r),{labels{ord_r}})
mat.CurrentAxes.FontSize = 16;
title(ttl)
mat.Position = [-1919         447        1920        1030]
dend.Position = [-1919         447        1920        1030]
saveas(mat,[fig_ofn 'matrix' [ttl{:}]  '.jpg'],'jpg')
saveas(dend,[fig_ofn 'Dend' [ttl{:}]  '.jpg'],'jpg')

end
end
disp('Done, exported')
close all










































