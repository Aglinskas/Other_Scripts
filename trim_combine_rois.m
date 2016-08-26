% The idea is to have 
% % 1. Rois corresponding to activities from your target brain
% % 2. List of independent coordinates
%% Spheres on coordinates (1)
load('/Volumes/Aidas_HDD/MRI_data/master_coords30.mat')
ofn='/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02';
%%
coord = master_coords;
for i=1:length(coord)
 sph_centre = [coord{i,1}];
 sph_widths = 6;
 sph_roi = maroi_sphere(struct('centre', sph_centre, ...
                'radius', sph_widths));
%trim_stim = maroi('load', [path '/Trim_roi.mat']);
%trim_stim = sph_roi & trim_stim;
sph_roi = label(sph_roi, coord{i});
saveroi(sph_roi, ([ofn '/Sph2_' coord{i,2} '_roi.mat']));
end
%%
% %% my interpretation
% % have group_anal open, thresh'ed, etc.
% %
% ofn = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/';
% extract_voi_coords = 0;
% %load([ofn 'Voi_coords.mat'])
% load('/Volumes/Aidas_HDD/MRI_data/master_coords.mat')
% addpath('/Users/aidas_el_cap/Documents/MATLAB/spm12/toolbox/marsbar/')
%% Get the Rois into a single file
load('/Volumes/Aidas_HDD/MRI_data/master_coords30.mat')
roi_dir = '/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/'
clear all_rois;
%a = dir([roi_dir 'TrSph*roi.mat'])
%a = {a.name}'
for i = 1:length(a)
    all_rois{i} = maroi('load',[roi_dir 'TrSph_' master_coords{i,2} '_' num2str(master_coords{i}) '_roi.mat']);
end
all_rois = all_rois'
%% Get list of coordinates from the ROI
% roi_o = maroi('roiname.mat')
% V = spm_vol('path_to_the_volume_you_want_to_put_the_roi_in')
% sp = mars_space(V);
% Pos = voxpts(roi_o,sp);
base_spc = '/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/beta_0001.nii';
%%
roi_to_get = all_rois{24};
Pos = voxpts(roi_to_get,base_spc)
for i = 1:length(Pos)
    [a p] = spm_atlas('query',xA,Pos(:,i))
end
%% Check if ROI sphere coords are within the anatomical cluster;
coord = [3 -52 29]'
atlas = fullfile('/Users/aidas_el_cap/Documents/MATLAB/spm12/tpm/','labels_Neuromorphometrics.nii');
xA = spm_atlas('load',atlas);
[a b] = spm_atlas('query',xA,coord) % Good coord has to be fed in

%   FORMAT xA = spm_atlas('load',atlas)
%   FORMAT L = spm_atlas('list')
%   FORMAT [S,sts] = spm_atlas('select',xA,label)
%   FORMAT Q = spm_atlas('query',xA,XYZmm)
%   FORMAT [Q,P] = spm_atlas('query',xA,xY)
%   FORMAT VM = spm_atlas('mask',xA,label,opt)
%   FORMAT V = spm_atlas('prob',xA,label)
%   FORMAT V = spm_atlas('maxprob',xA,thresh)
%   FORMAT D = spm_atlas('dir')

%%
if extract_voi_coords == 1
mip = spm_mip_ui('FindMIPax');
A = spm_clusters(xSPM.XYZ);
% Get Atlas
atlas = fullfile('/Users/aidas_el_cap/Documents/MATLAB/spm12/tpm/','labels_Neuromorphometrics.nii');
xA = spm_atlas('load',atlas);
spm_atlas('query',xA,curr_coord);
% Get Clusters, labels, sizes
%%
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
%%
test_roi = all_rois{1};
volume(test_roi)
%display(test_roi)
%% Combine ROIs (2)
fls = dir([ofn '/eye(12)*roi.mat']);
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
spc = mars_space('/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/beta_0008.nii');
for i=1:length(coord)
 sph_centre = [coord{i,1}];
 sph_widths = 6;
 sph_roi = maroi_sphere(struct('centre', sph_centre, ...
                'radius', sph_widths));
%path='/Users/scott/Data/RSexpItem/Group_anal_NIndex';
%trim_stim = maroi('load', [path '/Trim_roi.mat']);
trim_stim = maroi('load', [ofn '/ALLcombined_roi.mat'])
trim_stim = sph_roi & trim_stim;
trim_stim = label(trim_stim,[coord{i,2} ' ' num2str(coord{i,1})]);
%trim_stim = label(trim_stim, Voi_coords{i,2})
 saveroi(trim_stim, ([ofn '/TrSph_' coord{i,2} '_' num2str([coord{i,1}]) '_roi.mat']));
 mars_rois2img([ofn '/TrSph_' coord{i,2} '_' num2str([coord{i,1}]) '_roi.mat'],[ofn '/TrSph_' coord{i,2} '_' num2str([coord{i,1}]) '_roi.nii'],spc)
% saveroi(trim_stim, ([ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.mat']));
%  mars_rois2img([ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.mat'],[ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.nii'],spc)
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

%% just convert to .nii
% options
addpath(genpath('/Users/aidas_el_cap/Documents/MATLAB/spm12/toolbox/marsbar/'))
roi_fn = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/';
roi_pref  = 'old';
lbls = {'lHIP' 'lpSTS' 'lATL' 'rHIP' 'rOFA' 'PREC' 'vmPFC' 'rFFA' 'rIFG' 'rpSTS' 'rATL' 'dmPFC'}';
rois = dir(fullfile(roi_fn,[roi_pref '*']));
export_prefix = 'oldnii';
rois = {rois.name}';
spc = mars_space('/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/beta_0008.nii');
%% code
if length(rois) ~= length(lbls); error('mismatch between number of ROIs and Labels, check-ity check yourself');end
for r = 1:length(rois)

a_roi = maroi('load',fullfile(roi_fn,rois{r}));
a_roi = label(a_roi,lbls{r})
saveroi(a_roi,fullfile(roi_fn,rois{r}))
mars_rois2img(fullfile(roi_fn,rois{r}),fullfile(roi_fn,[ num2str(r) export_prefix '_' lbls{r} '.nii']),spc)
end
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
%   FORMAT url = spm_atlas('weblink',XYZmm,website)
%   FORMAT labels = spm_atlas('import_labels',labelfile,fmt)
%   FORMAT spm_atlas('save_labels',labelfile,labels)