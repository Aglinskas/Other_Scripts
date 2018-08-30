function func_makeROIsFromCoords(coords,names,ofn,sph_radius)
%func_makeROIsFromCoords(coords,names,ofn,sph_radius)

addpath(genpath('/Users/aidasaglinskas/Documents/MATLAB/spm12/toolbox/marsbar/'));
%% Combine Blobs and Covert Blobs
if ~exist(ofn)
    mkdir(ofn)
else
    delete([ofn '*'])
end

addpath('/Users/aidasaglinskas/Documents/MATLAB/marsbar/')
space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);
%% Combine Blobs
%blobs_dir = '/Users/aidasaglinskas/Desktop/faces_blobsp01/';
combine_blobs = 0;
if combine_blobs == 1
%blobs_dir = '/Users/aidasaglinskas/Desktop/newblobls/';
blobs_dir = '/Users/aidasaglinskas/Desktop/ROIs_Analysis_Data/afce_p001/';
    temp = dir([blobs_dir 'a*.mat']);
blobs_fn = {temp.name}';
all_blobs = [];
for i = 1:length(blobs_fn);
clear roi 
    load(fullfile(blobs_dir,blobs_fn{i}));
    if isempty(all_blobs);
        all_blobs = roi;
    else
        all_blobs = all_blobs | roi;
    end
end
saveroi(all_blobs,[blobs_dir 'Blobs_combined_roi.mat']); %
mars_rois2img([blobs_dir 'Blobs_combined_roi.mat'],[blobs_dir 'Blobs_combined.nii'],space); %
end
%%
%sph_radius = 7.5;
masks.all_blobs = load('/Users/aidasaglinskas/Desktop/Work_Clutter/faces_blobsp01/N40_Blobs_combined.mat');
masks.psts = load('/Users/aidasaglinskas/Desktop/Work_Clutter/psts_ang_masks/pSTS_mask_roi.mat');
masks.AG = load('/Users/aidasaglinskas/Desktop//Work_Clutter/psts_ang_masks/AG_mask_roi.mat');
space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);
%ofn = '/Users/aidasaglinskas/Desktop/faces_blobsp01/'

all_rois = [];
for i = 1:length(names);
%escape pSTS and Angular;
   this_sphere = maroi_sphere(struct('centre',coords(i,:),'radius', sph_radius));
    if isempty(all_rois); all_rois = this_sphere;end
if ~isempty(strfind(names{i},'Angular'))
this_sphere = this_sphere & masks.all_blobs.roi & masks.AG.roi;
all_rois = all_rois | this_sphere;
disp('Angular Detected, Special Treatment')
elseif ~isempty(strfind(names{i},'pSTS'))
this_sphere = this_sphere & masks.all_blobs.roi & masks.psts.roi;
all_rois = all_rois | this_sphere;    
disp('pSTS Detected, Special Treatment')
else
end
this_sphere = this_sphere & masks.all_blobs.roi;
all_rois = all_rois | this_sphere;

ofn_nm = [ofn 'ROI_' names{i} '.mat'];
saveroi(this_sphere,ofn_nm);
mars_rois2img(ofn_nm,strrep(ofn_nm,'.mat','.nii'),space)
end
%saveroi(all_rois,[ofn 'ROIs_Combined.mat'])    
%mars_rois2img([ofn 'ROIs_Combined.mat'],[ofn 'Combined_ROIs.nii'],space)
%% RoiSizes 
RoiSizes = 1;
if RoiSizes == 1
r_list = dir([ofn '*.nii']);
r_list = {r_list.name}';
for i = 1:length(r_list)
temp =  cosmo_fmri_dataset(fullfile(ofn,r_list{i}));
v(i) = sum(temp.samples); 
end
end