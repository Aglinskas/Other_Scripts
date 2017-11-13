%%%%
loadMR;
addpath(genpath('/Users/aidasaglinskas/Documents/MATLAB/marsbar/'))
masks = [];
masks.roi_dir = '/Users/aidasaglinskas/Desktop/RR/';
temp = dir([masks.roi_dir '*.nii']);
masks.nii_files = {temp.name}';
temp = dir([masks.roi_dir '*.mat']);
masks.mat_files = {temp.name}';
temp = strrep(masks.nii_files,'.nii','');
masks.labels = strrep(temp,'ROI_','')
%% Extract Voxel Data
clc
voxel_data = {};
p.v = repmat([ones(1,12) zeros(1,6)],1,5);
p.wh_betas = find(p.v);
p.beta_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/beta_%s.nii';
for m_ind = 1:length(masks.nii_files)
    m_fn = fullfile(masks.roi_dir,masks.nii_files{m_ind});
    R  = maroi(fullfile(masks.roi_dir,masks.mat_files{m_ind}));
for s_ind = 1:20
    clc;disp(sprintf('%d/21 | %d/20',m_ind,s_ind))
    subID = subvect.face(s_ind);
for t_ind = 1:12
    task_betas = p.wh_betas(t_ind:12:end);
for run_ind = 1:5
this_beta = task_betas(run_ind);
bt_fn = sprintf(p.beta_temp,subID,num2str(this_beta,'%.4i'));
% extract
voxel_data{m_ind,t_ind,s_ind,run_ind} = getdata(R,bt_fn);
end
end
end
end
disp('done')
%%
vx = struct;
vx.f_voxel_data = voxel_data;
vx.info = 'ROI|TASK|SUB|RUN'
vx.r_labels = masks.labels;
vx.t_labels = { 'First memory'    'Attractiveness'    'Friendliness'    'Trustworthiness' 'Familiarity'    'Common name'    'How many facts'    'Occupation' 'Distinctiveness'    'Full name'    'Same Face'    'Same monument'}'
save('/Users/aidasaglinskas/Desktop/a_voxel_data.mat','vx')
disp('saved')