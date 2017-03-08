clear all
close all
%%
% {'IndependentROIS' 'NOT_IndependentROIS'}
analysis_name = 'feb20_2017'
%% Group Average, - Get Peaks
opts_xSPM.spm_path = '/Users/aidasaglinskas/Google Drive/MRI_data/Group_anal_m-3_s8n44/SPM.mat'
%opts_xSPM.spm_path = '/Users/aidasaglinskas/Google Drive/MRI_data/GroupAnalysis_31_6th_Oct/SPM.mat'
opts_xSPM.p_tresh = .001;
opts_xSPM.k_extent = 0;
opts_xSPM.mask_which_mask_ind = 0;
opts_xSPM.useContrast = 1; %3 or 1
opts_xSPM.MC_correction = 'none'
set_up_xSPM
% Get Atlas
L = spm_atlas('list');
xA = spm_atlas('load',L.file);
%% Master Coords way, 
master_coord_fn = '/Users/aidasaglinskas/Google Drive/MRI_data/master_coords_44Peak.mat';
load(master_coord_fn);
%Space to extract from
%spc_ex = mars_space('/Users/aidasaglinskas/Google Drive/MRI_data/Group_anal_m-3_s8n44/beta_0001.nii')
% Space to save in
spc_ofn = mars_space('/Users/aidasaglinskas/Google Drive/Data/S8/Analysis/beta_0001.nii');

sph_radius = 7.5;
root_ofn = '/Users/aidasaglinskas/Google Drive/ROI_masks/Revisited/'
ofn = fullfile(root_ofn,analysis_name);
if exist(ofn) == 0;mkdir(ofn);end
prefix = analysis_name;
% get blobs
addpath('~/Documents/MATLAB/spm12/toolbox/marsbar/spm5/')
mars_blobs2rois(xSPM,ofn,['Blobs_' analysis_name]) %saves 'em
all_blobs.fn = dir([fullfile(ofn,['Blobs_' strrep(analysis_name,' ','_') '*.mat'])])
all_blobs.fn = {all_blobs.fn.name}'
% loops over blobs, imports and combines them
for b_ind = 1:length(all_blobs.fn)
    this_blob = load(fullfile(ofn,all_blobs.fn{b_ind}));
if b_ind == 1
    combined_blobs = this_blob.roi;
else 
    combined_blobs = combined_blobs | this_blob.roi;
end
end
all_blobs.outfn = fullfile(ofn,'Blobs_ALL_COMBINED.mat');
saveroi(combined_blobs,all_blobs.outfn); % Save ROI mat
mars_rois2img(all_blobs.outfn,strrep(all_blobs.outfn,'.mat','.nii'),spc_ofn); % and .nii
%
clear all_rois combined_rois 
ROI_report = {};
rep_cats = {'index' 'label' 'sphere volume' 'voxels in clust' 'Voxel size sphere' 'Voxel Size ROI' 'master_coord' 'a_coord' 'sphere centre' 'com_sphere' 'com_clust'};
ROI_report(1,1:length(rep_cats)) = deal(rep_cats);
for p_ind = 1:length(master_coords)
p_coord = master_coords(p_ind,:);
% Get the xSPM index of the current voxel
a = spm_mip_ui('SetCoords',p_coord,mip);
this_peak_ind = find(xSPM.XYZmm(1,:) == a(1) & xSPM.XYZmm(2,:) == a(2) & xSPM.XYZmm(3,:) == a(3));


this_sphere_roi = maroi_sphere(struct('centre', p_coord,'radius', sph_radius));
trim_ROI = this_sphere_roi & combined_blobs;


temp_c = matrixdata(maroi_matrix(trim_ROI,spc_ofn));
ROI_vox_size = length(find(temp_c > 0));
temp_sph = matrixdata(maroi_matrix(this_sphere_roi,spc_ofn));
Sphere_vox_size = length(find(temp_sph > 0));


%Collect them all
all_rois{p_ind} = trim_ROI; 
all_spheres{p_ind} = this_sphere_roi;

%Trim ROIS
out_fn_trimSPH = [ofn '/' 'Trim_Sph_' prefix ' ' master_coords_labels{p_ind} ' ' num2str(p_coord) '_roi.mat'];
saveroi(trim_ROI,out_fn_trimSPH); % Save ROI mat
mars_rois2img(out_fn_trimSPH,strrep(out_fn_trimSPH,'.mat','.nii'),spc_ofn); % and .nii
%Spheres
% out_fn_trimSPHERE = strrep(out_fn_trimSPH,'_Trim_Sph_','_Sphere_');
% saveroi(this_sphere_roi,out_fn_trimSPHERE);
% mars_rois2img(out_fn_trimSPHERE,strrep(out_fn_trimSPHERE,'.mat','.nii'),spc_ofn); % and .nii

%size(voxpts(this_sphere_roi,base_space),2)
if p_ind == 1
    combined_rois = trim_ROI;
else
    combined_rois = combined_rois | trim_ROI;
end
                            % Report
                            ROI_report{p_ind+1,1} = p_ind;
                            ROI_report{p_ind+1,2} = master_coords_labels{p_ind};
                            ROI_report{p_ind+1,3} = round(volume(this_sphere_roi));
                            %ROI_report{p_ind+1,4} = volume(this_point_list_roi);
                            ROI_report{p_ind+1,5} = size(voxpts(this_sphere_roi,spc_ofn),2);
                            ROI_report{p_ind+1,6} = size(voxpts(trim_ROI,spc_ofn),2);
                            ROI_report{p_ind+1,7} = p_coord;
                            ROI_report{p_ind+1,8}  = a'
                            ROI_report{p_ind+1,9} = centre(this_sphere_roi);
                            ROI_report{p_ind+1,10} = round(c_o_m(this_sphere_roi))
                            %ROI_report{p_ind+1,11} = round(c_o_m(this_point_list_roi)')
end
out_fn_trimSPH = [ofn '/Combined_ROIs' prefix  '_roi.mat'];
saveroi(combined_rois,out_fn_trimSPH); % Save ROI mat
mars_rois2img(out_fn_trimSPH,strrep(out_fn_trimSPH,'.mat','.nii'),spc_ofn); % and .nii
%% Extract Beta
   %load('/Users/aidasaglinskas/Google Drive/MRI_data/subvect_full20.mat')
subvect =  [7  8  9 10 11 14 15 17 18 19 20 21 22 24 25 26 27 28 29 30 31];
disp('Extracting Betas')
subDir_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/'
subID = 7
subDir = sprintf(subDir_temp,subID); % inserts subID to template
all_betas = 1:90; %all betas
betas_ind = (find(repmat([ones(1,12) zeros(1,6)],1,5) == 1)); % without 
beta_temp = 'beta_00%s.nii'
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
ROI_size(s_ind,r_ind,b_ind) = length(y);
end
% Mean across runs
for t_ind = 1:12
    subBetaArray(r_ind,t_ind,s_ind) = mean(extracted_betas(s_ind,r_ind,[t_ind:12:60]));
end
end
end
save(['~/Desktop/' analysis_name 'SubBetaArray.mat'],'subBetaArray','master_coords_labels')
toc
%% COMPUTE DENDOGRAM
load('/Users/aidasaglinskas/Google Drive/MRI_data/tasks.mat')
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

