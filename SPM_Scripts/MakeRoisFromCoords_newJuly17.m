%% Combine Blobs and Covert Blobs
addpath('/Users/aidasaglinskas/Documents/MATLAB/marsbar/')
space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);

%blobs_dir = '/Users/aidasaglinskas/Desktop/faces_blobsp01/';
blobs_dir = '/Users/aidasaglinskas/Desktop/newblobls/';
    temp = dir([blobs_dir '*.mat']);
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
saveroi(all_blobs,[blobs_dir 'Blobs_combined.mat'])
mars_rois2img([blobs_dir 'Blobs_combined.mat'],[blobs_dir 'Blobs_combined.nii'],space)
%% Make ROIs from coords
coords = [3	-52	29
48	-58	20
-42	-61	26
30	-91	-10
-33	-88	-10
42	-46	-22
-39	-46	-22
39	17	23
-36	20	26
-60	-7	-19
57	-7	-19
-21	-10	-13
21	-7	-16
3	50	-19
33	35	-13
-33	35	-13
33	-10	-40
-36	-10	-34
-48	-67	35
42	-64	35
-48	-49	14
48	-55	14
6	59	23];
names = {'Precuneus'
'AngularRight-OLD'
'AngularLeft-OLD'
'OFARight'
'OFALeft'
'FFARight'
'FFALeft'
'IFGRight'
'IFGLeft'
'ATLLeft'
'ATLRight'
'AmygdalaLeft'
'AmygdalaRight'
'PFCmedial'
'OrbRight'
'OrbLeft'
'Face PatchRight'
'Face PatchLeft'
'Angular-Left'
'Angular-Right'
'pSTS-Left'
'pSTS-Right'
'dMPFC'};
%%
sph_radius = 7.5;
all_blobs = load('/Users/aidasaglinskas/Desktop/faces_blobsp01/N40_Blobs_combined.mat')
    space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);
ofn = '/Users/aidasaglinskas/Desktop/faces_blobsp01/'

all_rois = [];
for i = 1:length(names)

   this_sphere = maroi_sphere(struct('centre',coords(i,:),'radius', sph_radius));
    if isempty(all_rois); all_rois = this_sphere;end

this_sphere = this_sphere & all_blobs.roi
    all_rois = all_rois | this_sphere;
ofn_nm = [ofn 'ROI_' names{i} '.mat'];

saveroi(this_sphere,ofn_nm)    
mars_rois2img(ofn_nm,strrep(ofn_nm,'.mat','.nii'),space)
end

saveroi(all_rois,[ofn 'ROIs_Combined.mat'])    
mars_rois2img([ofn 'ROIs_Combined.mat'],[ofn 'Combined_ROIs.nii'],space)
%% Roi Sizes 

r_list = dir([ofn '*.nii']);
r_list = {r_list.name}';
for i = 1:length(r_list)
temp =  cosmo_fmri_dataset(fullfile(ofn,r_list{i}));
v(i) = sum(temp.samples); 
end