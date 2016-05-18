voiName{1}='Left_plFG';
voiName{end+1}='Right_plFG';
voiName{end+1}='Right_MTG';
voiName{end+1}='Right_alFG';
voiName{end+1}='Right_STS';
voiName{end+1}='Left_SOG';
voiName{end+1}='Left_MTG';
voiName{end+1}='Left_IPS';
voiName{end+1}='Left_amFG';
voiName{end+1}='Right_amFG';
clear coord
coord{1}=[-39   -64 -17];
coord{end+1}=[42    -64 -17];
coord{end+1}=[51    -76 1];
coord{end+1}=[42    -46 -23];
coord{end+1}=[51    -43 16];
coord{end+1}=[-36   -91 19];
coord{end+1}=[-51   -58 -11];
coord{end+1}=[-18   -67 49];
coord{end+1}=[-27   -58 -11];
coord{end+1}=[30    -49 -11];
-48, -64, -20
%%
% load('/Volumes/Aidas_HDD/MRI_data/master_coords.mat')
% coord = master_coords;
% 
% for i=1:length(coord)
%  sph_centre = [coord{i,2:4}];
%  sph_widths = 6;
%  sph_roi = maroi_box(struct('centre', sph_centre, ...
%                 'widths', sph_widths));
%  
% path='/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/';
% trim_stim = maroi('load', [path '/Trim_roi.mat']);
% trim_stim = sph_roi & trim_stim;
% trim_stim = label(trim_stim, voiName{i});
% saveroi(trim_stim, ([path '/Sph_' voiName{i} '_roi.mat']));
% end
%% Spheres on coordinates (1)
load('/Volumes/Aidas_HDD/MRI_data/master_coords.mat')
ofn='/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/';
coord = master_coords;
for i=1:length(coord)
 sph_centre = [coord{i,2:4}];
 sph_widths = 6;
 sph_roi = maroi_sphere(struct('centre', sph_centre, ...
                'radius', sph_widths));
%trim_stim = maroi('load', [path '/Trim_roi.mat']);
%trim_stim = sph_roi & trim_stim;
sph_roi = label(sph_roi, coord{i});
saveroi(sph_roi, ([ofn '/Sph2_' coord{i} '_roi.mat']));
end
%% my interpretation
% have group_anal open, thresh'ed, etc.
%
ofn = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/';
extract_voi_coords = 0;
%load([ofn 'Voi_coords.mat'])
load('/Volumes/Aidas_HDD/MRI_data/master_coords.mat')
addpath('/Users/aidas_el_cap/Documents/MATLAB/spm12/toolbox/marsbar/')
%%
if extract_voi_coords == 1
mip = spm_mip_ui('FindMIPax');
A = spm_clusters(xSPM.XYZ);
% Get Atlas
atlas = fullfile('/Users/aidas_el_cap/Documents/MATLAB/spm12/tpm/','labels_Neuromorphometrics.nii');
xA = spm_atlas('load',atlas);
spm_atlas('query',xA,curr_coord);
% Get Clusters, labels, sizes
clust = unique(spm_clusters(xSPM.XYZ));
for c = clust 
go_to_clust = ceil(median(find(A==c)));
curr_coord = spm_results_ui('SetCoords',xSPM.XYZmm(:,go_to_clust));
curr_coord = spm_mip_ui('Jump',mip,'nrmax');
Voi_coords{c,1} = curr_coord';
Voi_coords{c,2} = spm_atlas('query',xA,curr_coord);
Voi_coords{c,3} = length(find(A==c));
end
save([ofn 'Voi_coords.mat'],'Voi_coords')
end
%% Combine ROIs (2)
fls = dir([ofn 'Sph2*roi.mat']);
clear all_rois
for i = 1:length(fls)
%all_rois{i} = load(fullfile(ofn,fls(i).name));
all_rois{i} = maroi('load',fullfile(ofn,fls(i).name));
end
disp(['loadded ' num2str(length(all_rois)) ' ROIs'])
clear Trim_stim_ALL
Trim_stim_ALL = all_rois{1};
for i = 2:length(all_rois)
Trim_stim_ALL = Trim_stim_ALL + all_rois{i};
end
saveroi(Trim_stim_ALL,[ofn 'ALLcombined_roi.mat'])
disp('Combined and Saved')
%% Trim ROI (2)
spc = mars_space('/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/beta_0008.nii');
for i=1:length(coord)
 sph_centre = [coord{i,2:4}];
 sph_widths = 6;
 sph_roi = maroi_sphere(struct('centre', sph_centre, ...
                'radius', sph_widths));
%path='/Users/scott/Data/RSexpItem/Group_anal_NIndex';
%trim_stim = maroi('load', [path '/Trim_roi.mat']);
trim_stim = maroi('load', [ofn 'ALLcombined_roi.mat'])
trim_stim = sph_roi & trim_stim;
trim_stim = label(trim_stim,coord{i});
%trim_stim = label(trim_stim, Voi_coords{i,2})
 saveroi(trim_stim, ([ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.mat']));
 mars_rois2img([ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.mat'],[ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.nii'],spc)
end
%% Combine and save trimmed
fls = dir([ofn '/TrSph_*roi.mat']);
clear all_rois
for i = 1:length(fls)
%all_rois{i} = load(fullfile(ofn,fls(i).name));
all_rois{i} = maroi('load',fullfile(ofn,fls(i).name));
end
disp(['loadded ' num2str(length(all_rois)) ' ROIs'])
clear Trim_stim_ALL
Trim_stim_ALL = all_rois{1};
for i = 2:length(all_rois)
Trim_stim_ALL = Trim_stim_ALL | all_rois{i};
end
saveroi(Trim_stim_ALL,[ofn 'Sphere_MASK_combined_roi2'])
disp('Combined and Saved')
spc = mars_space('/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/beta_0008.nii');
mars_rois2img([ofn 'Sphere_MASK_combined_roi2.mat'],[ofn 'Sphere_MASK_combined_roi2.nii'],spc)
%%
%mars_rois2img(roi_list, img_name, roi_space, flags)

%%










% Atlas multi-function
%   FORMAT xA = spm_atlas('load',atlas)
%   FORMAT L = spm_atlas('list')
%   FORMAT [S,sts] = spm_atlas('select',xA,label)
%   FORMAT Q = spm_atlas('query',xA,XYZmm)
%   FORMAT [Q,P] = spm_atlas('query',xA,xY)
%   FORMAT VM = spm_atlas('mask',xA,label,opt)
%   FORMAT V = spm_atlas('prob',xA,label)
%   FORMAT V = spm_atlas('maxprob',xA,thresh)
%   FORMAT D = spm_atlas('dir')
%  
%   FORMAT url = spm_atlas('weblink',XYZmm,website)
%   FORMAT labels = spm_atlas('import_labels',labelfile,fmt)
%   FORMAT spm_atlas('save_labels',labelfile,labels)