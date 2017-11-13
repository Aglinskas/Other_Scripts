function func_makeROIsFromCoords_cosmo(coords,names,ofn,sph_radius)

load('/Users/aidasaglinskas/Desktop/mc.mat')
coords = mc.coords;
names = mc.names;
ofn = '/Users/aidasaglinskas/Desktop/untitled folder 2/';
sph_radius = 7.5

addpath('/Users/aidasaglinskas/Documents/MATLAB/marsbar/')
space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);

blobs_fn = '/Users/aidasaglinskas/Desktop/ROIs_Analysis_Data/afce_p01/Blobs_combined.nii';
blobs = load_nii(blobs_fn);
blobs.img(blobs.img ~= 1) = NaN;
T = struct;
if size(coords,1) ~= size(names,1);error('Corrds and Names not same size');end
for i = 1:size(coords,1)

% Make Sphere
ofn_nm_mat = fullfile(ofn,['sph_' names{i} '.mat']);
ofn_nm_sph_nii = fullfile(ofn,['sph_' names{i} '.nii']);
ofn_nm_sph_tr_nii = fullfile(ofn,['tr_sph_' names{i} '.nii']);
[this_sphere o] = maroi_sphere(struct('centre',coords(i,:),'radius', sph_radius));
saveroi(this_sphere,ofn_nm_mat);
mars_rois2img(ofn_nm_mat,ofn_nm_sph_nii,space);

% Trim sphere
sph_roi = load_nii(ofn_nm_sph_nii);
sph_roi.img = nan(size(sph_roi.img));
tr_sph_roi = sph_roi;
tr_sph_roi.img = tr_sph_roi.img .* blobs.img;
save_nii(tr_sph_roi,ofn_nm_sph_tr_nii);

T(i).name = names{i};

end