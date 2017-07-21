% The idea is to have 
% % 1. Rois corresponding to activities from your target brain
% % 2. List of independent coordinates
%% Spheres on coordinates (1)
load('/Volumes/Aidas_HDD/MRI_data/master_coords30.mat')
ofn = '/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/'
sv_dir ='/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/July_19th_ROIS_2';
if exist(sv_dir) == 0; mkdir(sv_dir);end
addpath('~/Documents/MATLAB/spm12/toolbox/marsbar/')
%%
master_coords = {}
%master_coords{1,1} = [3,50,-19]
%master_coords{1,2} = 'may24_new__mPFC2'
% manual override of coords
% master_coords{1,1} = [57,-52,11];master_coords{1,2} = 'rpSTS_vis'
% master_coords{2,1} = [-42,-58,20];master_coords{2,2} = 'lpSTS_vis'
% master_coords{3,1} = [33,35,-13];master_coords{3,2} = 'rORB_new2'
% master_coords{4,1} = [-36,26,-22];master_coords{4,2} = 'lORB_new2'
% master_coords{1,1} = [33,35,-13];master_coords{1,2} = 'rORB-33'
% master_coords{2,1} = [-33,35,-13];master_coords{2,2} = 'lORB-33'
% master_coords{3,1} = [-36,26,-22];master_coords{3,2} = 'rORB-36'
% master_coords{4,1} = [36,26,-22];master_coords{4,2} = 'lORB-36'
% master_coords{end+1,1} = [48,-58,20];master_coords{end,2} = 'rPSTS2'
% master_coords{end+1,1} = [-45,-64,29];master_coords{end,2} = 'lPSTS2'
% master_coords{end+1,1} = [-45,-64,34];master_coords{end,2} = 'lPSTS3'

% rrpsts_far = [54   -64    26] % good
% lrpsts_far = [-36   -70    47] % good,right ang
% 
% master_coords{end+1,1} = [57 -58 5];master_coords{end,2} = 'pSTS-Silvia-Right'
% master_coords{end+1,1} = [-45 -64 14];master_coords{end,2} = 'pSTS-Silvia-Left'


master_coords{end+1,1} = [-42,-61,26];master_coords{end,2} = 'lpsts_peak'
master_coords{end+1,1} = [48,-58,20];master_coords{end,2} = 'rpsts_peak'

% master_coords{end+1,1} = [54   -64    26];master_coords{end,2} = 'rrpsts_far'
% master_coords{end+1,1} = [-36   -70    47];master_coords{end,2} = 'lrpsts_far'
% master_coords{end+1,1} = [36   -70    47];master_coords{end,2} = 'rrpsts_far2'
% master_coords{end+1,1} = [-39   -73    41];master_coords{end,2} = 'lpsts_pole'
% master_coords{end+1,1} = [ 39   -64    47];master_coords{end,2} = 'rpsts_pole'
% master_coords{end+1,1} = [,,];master_coords{end,2} = ''
% master_coords{end+1,1} = [,,];master_coords{end,2} = ''
% master_coords{end+1,1} = [,,];master_coords{end,2} = ''
% master_coords{end+1,1} = [,,];master_coords{end,2} = ''
%%
coord = master_coords;
for i=1:size(coord,1)
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
for i = 1:length(master_coords)
    all_rois{i} = maroi('load',[roi_dir 'TrSph_' master_coords{i,2} '_' num2str(master_coords{i}) '_roi.mat']);
end
all_rois = all_rois'
%% Get list of coordinates from the ROI
% roi_o = maroi('roiname.mat')
% V = spm_vol('path_to_the_volume_you_want_to_put_the_roi_in')
% sp = mars_space(V);
% Pos = voxpts(roi_o,sp);
base_spc = '/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/beta_0001.nii';
%base_spc = '/Users/aidas_el_cap/Documents/MATLAB/spm12/canonical/single_subj_T1.nii'
%%
roi_to_get = all_rois{24};
Pos = voxpts(roi_to_get,base_spc)
for i = 1:length(Pos)
    [a p] = spm_atlas('query',xA,Pos(:,i))
end
%% Check if ROI sphere coords are within the anatomical cluster;
at_chk = 0;
if at_chk
for i = 1:size(master_coords,1)
coord = master_coords{i,1}';
atlas = fullfile('/Users/aidas_el_cap/Documents/MATLAB/spm12/tpm/','labels_Neuromorphometrics.nii');
xA = spm_atlas('load',atlas);
[a b] = spm_atlas('query',xA,coord); % Good coord has to be fed in
disp(coord')
disp(a)
end
end
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
%fls = dir([ofn '/eye(12)*roi.mat']);
fn_path = '/Users/aidas_el_cap/Desktop/44_clust/';
fls = dir([fn_path '/*roi.mat'])
clear all_rois
for i = 1:length(fls)
%all_rois{i} = load(fullfile(ofn,fls(i).name));
all_rois{i} = maroi('load',fullfile(fn_path,fls(i).name));
end
disp(['loadded ' num2str(length(all_rois)) ' ROIs'])
clear Trim_stim_ALL
Trim_stim_ALL = all_rois{1};
for i = 2:length(all_rois)
Trim_stim_ALL = Trim_stim_ALL + all_rois{i};
end
saveroi(Trim_stim_ALL,[fn_path 'ALLcombined_roi.mat'])
disp('Combined and Saved')
%% Create and Trim ROI (2) Final
spc = mars_space('/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/beta_0008.nii');
%spc = mars_space('/Users/aidas_el_cap/Desktop/mirtemp/GG-366-GM-0.7mm.nii');
coord = master_coords;
for i=1:size(coord,1)
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
saveroi(trim_stim, ([sv_dir '/TrSph_' coord{i,2} '_' num2str([coord{i,1}]) '_roi.mat']));
mars_rois2img([sv_dir '/TrSph_' coord{i,2} '_' num2str([coord{i,1}]) '_roi.mat'],[sv_dir '/TrSph_' coord{i,2} '_' num2str([coord{i,1}]) '_roi.nii'],spc)
% saveroi(trim_stim, ([ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.mat']));
%  mars_rois2img([ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.mat'],[ofn '/TrSph_' coord{i} '_' num2str([coord{i,2:4}]) '_roi.nii'],spc)
end
%% Combine and save trimmed
ofn = '/Volumes/Aidas_HDD/MRI_data/Group30_Analysis_mask02/July_19th_ROIS_2/'
%spc = mars_space('/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/beta_0008.nii');
%spc = mars_space('/Users/aidas_el_cap/Documents/MATLAB/spm12/canonical/single_subj_T1_bet.nii');
spc = mars_space('/Users/aidas_el_cap/Desktop/mirtemp/GG-366-GM-0.7mm.nii')
fls = dir([ofn '/TrSph_*roi.mat']);
all_rois = {}
for i = 1:length(fls)
%all_rois{i} = load(fullfile(ofn,fls(i).name));
all_rois{end+1} = maroi('load',fullfile(ofn,fls(i).name));
end
disp(['loadded ' num2str(length(all_rois)) ' ROIs'])
clear Trim_stim_ALL
Trim_stim_ALL = all_rois{1};
for i = 1:length(all_rois)
Trim_stim_ALL = Trim_stim_ALL | all_rois{i};
end
saveroi(Trim_stim_ALL,[ofn 'Sphere_MASK_combined_roi2'])
disp('Combined and Saved')
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