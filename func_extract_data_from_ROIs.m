function roi_data = func_extract_data_from_ROIs(roi_dir,spm_dir)
%roi_data = func_extract_data_from_ROIs(roi_dir,spm_dir,ntasks,nsubs)
addpath(genpath('/Users/aidasaglinskas/Documents/MATLAB/spm12/toolbox/marsbar/'));
%% Get Masks
extract_voxel_data = 0;
masks.dir = roi_dir;
%masks.dir = '/Users/aidasaglinskas/Desktop/faces_blobsp01/';


temp = dir([masks.dir 'R*.mat']);
masks.nii_files = {temp.name}'; clear temp;
masks.mat_files = strrep(fullfile(masks.dir,masks.nii_files),'.nii','.mat');
    masks.lbls = masks.nii_files;
    masks.lbls = strrep(masks.lbls,'ROI_','');
    masks.lbls = strrep(masks.lbls,'.nii','');
disp(masks.lbls);
disp([num2str(length(masks.lbls)) ' ROIs found']);
%% Get ROI Mean Data
%loadMR
%spm_dir = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_Analysis/';
spm_path = [spm_dir 'SPM.mat'];
load(spm_path);

tempa = cellfun(@(x) strsplit(x,filesep),SPM.xY.P,'UniformOutput',0);
tempb = cellfun(@(x) x{end},tempa,'UniformOutput',0);
nconds = length(unique(tempb));
nsubs = SPM.nscan / nconds;
disp(sprintf('%d Conds',nconds))
disp(sprintf('%d Subjects',nsubs))

D  = mardo(spm_path);% Make marsbar design object
roi_data = [];
for r_ind = 1:length(masks.mat_files)
ROI_fn = masks.mat_files{r_ind};
R  = maroi(ROI_fn);% Make marsbar ROI object
Y  = get_marsy(R, D, 'mean');% Fetch data into marsbar data object
y = summary_data(Y); % Take 
r = reshape(y,nconds,nsubs);
roi_data.mat(r_ind,:,:) = r;
end
roi_data.lbls = masks.lbls;
ofn = '/Users/aidasaglinskas/Desktop/ROI_data.mat';
%save(ofn,'roi_data')
%% Extract Voxel Data
if extract_voxel_data == 1;
n.subs = nsubs;
n.conds = ntasks;
n.masks = length(masks.mat_files);
voxel_data = {};
clc;
for r_ind = 1:n.masks
disp(sprintf('%d/%d',r_ind,n.masks));
R  = maroi(masks.mat_files{r_ind});
dt = {};
for i = 1:length({SPM.xY.VY.fname}); % All data
dt{i,1} = getdata(R,SPM.xY.VY(i).fname);
end % end subject task loop
dt = reshape(dt,n.conds,n.subs);
voxel_data(r_ind,:,:) = dt;
end % ends roi loop
ofn = '/Users/aidasaglinskas/Desktop/voxel_data.mat';
%save(ofn,'voxel_data')
end % ends if 
%% Fix SPM
fix_spm = 0;
if fix_spm;
old_str = '/Users/aidasaglinskas/Google Drive/Data/';
new_str = '/Users/aidasaglinskas/Google Drive/Aidas:Summaries & Analyses (WP 1.4)/Data_faces/';
SPM.xY.P = strrep(SPM.xY.P,old_str,new_str);
    b = strrep({SPM.xY.VY.fname},old_str,new_str)';
[SPM.xY.VY.fname] = deal(b{:});
save(spm_path,'SPM');
end