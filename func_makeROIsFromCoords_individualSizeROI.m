function func_makeROIsFromCoords_individualSizeROI(coords,names,subID)
%func_makeROIsFromCoords(coords,names,ofn,sph_radius)

%is_done = 0;
ofn_temp = '/Users/aidasaglinskas/Desktop/sROIS/S%d/';
ofn = sprintf(ofn_temp,subID);
nvoxels = 80;
%sph_radius = 11;
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
%% Get Blobs
masks.all_blobs = load('/Users/aidasaglinskas/Desktop/Work_Clutter/faces_blobsp01/N40_Blobs_combined.mat');
masks.psts = load('/Users/aidasaglinskas/Desktop/Work_Clutter/psts_ang_masks/pSTS_mask_roi.mat');
masks.AG = load('/Users/aidasaglinskas/Desktop//Work_Clutter/psts_ang_masks/AG_mask_roi.mat');
space_fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S7/Analysis/beta_0002.nii';
space = mars_space(space_fn);
%% MAIN ROI LOOP
all_rois = [];
for i = 1:length(names); % LOOPS THROUGH ROIS
    
    % WHILE LOOP GOES HERE
is_done = 0;
sph_radius = 6;
    while ~is_done
this_sphere = maroi_sphere(struct('centre',coords(i,:),'radius', sph_radius));
           %escape pSTS and Angular;
        if isempty(all_rois); all_rois = this_sphere;end
        if ~isempty(strfind(names{i},'Angular'))
        %this_sphere = this_sphere & masks.all_blobs.roi & masks.AG.roi;
        this_sphere = this_sphere & masks.AG.roi;
        all_rois = all_rois | this_sphere;
        %disp('Angular Detected, Special Treatment')
        elseif ~isempty(strfind(names{i},'pSTS'))
        %this_sphere = this_sphere & masks.all_blobs.roi & masks.psts.roi;
        this_sphere = this_sphere & masks.psts.roi;
        all_rois = all_rois | this_sphere;    
        %disp('pSTS Detected, Special Treatment')
        else
        end

% MAKE THE SPHERE
%this_sphere = this_sphere;
all_rois = all_rois | this_sphere;

ofn_nm = [ofn 'ROI_' names{i} '.mat'];
saveroi(this_sphere,ofn_nm);
ofn_nm_nii = strrep(ofn_nm,'.mat','.nii');
mars_rois2img(ofn_nm,ofn_nm_nii,space);


% TRIM SPHERE here

%data_fn = '/Users/aidasaglinskas/Google Drive/Group_anal_m-3_s8n44/spmT_0001.nii'
 data_fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/beta_0001.nii';
 data_fn = sprintf(data_fn_temp,subID);
 cosmo_warning('off');
ds = cosmo_fmri_dataset(data_fn,'mask',ofn_nm_nii);
ds = cosmo_remove_useless_data(ds);
if length(ds.samples) >= nvoxels;
    % found optimal size;
    is_done = 1;
    msg = sprintf('size of %s found, sphere of %.1f mm, %d vxls',names{i},sph_radius,length(ds.samples));
    disp(msg);
[Y I] = sort(ds.samples,'descend');
keep_inds = I(1:nvoxels);
ds.samples(1:end) = 0;
ds.samples(keep_inds) = 1;

ofn_nm_nii_trim = strrep(ofn_nm_nii,'ROI_','trimROI_');
cosmo_map2fmri(ds,ofn_nm_nii_trim);

t{i,1} = names{i};
t{i,2} = sph_radius;
t{i,3} = length(ds.samples);
if i == 1;
       all_masks = load_nii(ofn_nm_nii_trim);
else
       this_mask = load_nii(ofn_nm_nii_trim);
       all_masks.img = all_masks.img+this_mask.img;
end



else 
    %msg = sprintf('size of %s NOT found, tried sphere of %.1f mm, got %d vxls',names{i},sph_radius,length(ds.samples));
    %disp(msg);
    sph_radius = sph_radius+.5;
end % if enough voxels
    end % ends while loop
    
    

end % ends ROI loop

all_fn = fullfile(ofn,'trimallcombined.nii');
save_nii(all_masks,all_fn);
tt = cell2table(t,'VariableNames',{'RoiName' 'SphereSize' 'VxCount'});
writetable(tt,[ofn 'S' num2str(subID) '_report.csv']);




%saveroi(all_rois,[ofn 'ROIs_Combined.mat'])    
%mars_rois2img([ofn 'ROIs_Combined.mat'],[ofn 'Combined_ROIs.nii'],space)
%% Trim The Spheres
% fls = dir([ofn '*.nii']);
% fls = {fls.name}';
% for i = 1:length(fls)
%     clc;disp(sprintf('%d|%d - %s',i,length(fls),fls{i}))
%     ds = cosmo_fmri_dataset(data_fn,'mask',fullfile(ofn,fls{i}));
%     [Y I] = sort(ds.samples,'descend');
%     keep_inds = I(1:nvoxels);
%     ds.samples(1:end) = 0;
%     ds.samples(keep_inds) = 1;
%    cosmo_map2fmri(ds, fullfile(ofn,['trim_' fls{i}]));
%     
%    if i == 1;
%        all_masks = load_nii(fullfile(ofn,['trim_' fls{i}]));
%    else
%        this_mask = load_nii(fullfile(ofn,['trim_' fls{i}]));
%        all_masks.img = all_masks.img+this_mask.img;
%    end
%    all_fn = fullfile(ofn,'trimallcombined.nii');
%    save_nii(all_masks,all_fn);
% end
% %% RoiSizes 
% RoiSizes = 1;
% if RoiSizes == 1
% r_list = dir([ofn 'trim*.nii']);
% r_list = {r_list.name}';
% for i = 1:length(r_list)
% temp = cosmo_fmri_dataset(fullfile(ofn,r_list{i}));
% isnan(temp.samples)
% v(i) = sum(temp.samples); 
% txt = arrayfun(@(x) [num2str(x) '|' r_list{x} ' : ' num2str(v(x))],1:length(v),'UniformOutput',0)';
% disp(txt)
% end
end