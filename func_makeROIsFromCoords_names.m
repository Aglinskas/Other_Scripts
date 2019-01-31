function func_makeROIsFromCoords_names(coords,names,ofn,sph_radius,space_fn,blobs_dir)
% func_makeROIsFromCoords_names(coords,names,ofn,sph_radius,space_fn,blobs_dir)

addpath(genpath('/Users/aidasaglinskas/Documents/MATLAB/spm12/toolbox/marsbar/'));
%% If ROIs Exist, delete them
if ~exist(ofn)
    mkdir(ofn)
else
    delete([ofn '*.nii'])
end
%% Set ROI space
addpath('/Users/aidasaglinskas/Documents/MATLAB/marsbar/')
space = mars_space(space_fn);
%% Combine Blobs
combine_blobs = 0;
blobs_nm = 'Combined_blobs.mat';
blobs_fn = fullfile(blobs_dir,blobs_nm);
if ~exist(blobs_fn)
combine_blobs = 1;
disp('combining blobs')
end

if combine_blobs == 1
    temp = dir([blobs_dir '*.mat']);
blobs_fls = {temp.name}';
all_blobs = [];
for i = 1:length(blobs_fls);
clear roi 
    load(fullfile(blobs_dir,blobs_fls{i}));
    if isempty(all_blobs);
        all_blobs = roi;
    else
        all_blobs = all_blobs | roi;
    end
end
saveroi(all_blobs,blobs_fn); %
mars_rois2img(blobs_fn,strrep(blobs_fn,'.mat','.nii'),space); %
end
%%
masks.all_blobs = load(blobs_fn);
space = mars_space(space_fn);
all_rois = [];
for i = 1:length(names);
   this_sphere = maroi_sphere(struct('centre',coords(i,:),'radius', sph_radius));
    if isempty(all_rois); all_rois = this_sphere;end
    
this_sphere = this_sphere & masks.all_blobs.roi;
all_rois = all_rois | this_sphere;

ofn_nm = [ofn 'ROI_' names{i} '.mat'];
saveroi(this_sphere,ofn_nm);
mars_rois2img(ofn_nm,strrep(ofn_nm,'.mat','.nii'),space)
end
%% RoiSizes 
v = [];
RoiSizes = 1;
if RoiSizes == 1
r_list = dir([ofn '*.nii']);
r_list = {r_list.name}';
for i = 1:length(r_list)
temp =  cosmo_fmri_dataset(fullfile(ofn,r_list{i}));
v(i) = sum(temp.samples); 
end
end
T = table(r_list,v','VariableNames',{'ROI' 'Voxels'});
disp(T);
