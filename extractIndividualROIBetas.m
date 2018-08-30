%% Prep
clear all;
loadMR;
load('/Users/aidasaglinskas/Desktop/Federico/FMvx.mat')
vx.r_labels = [];
vx.f_voxel_data = [];
vx.list_r = [];
%f_voxel_data: {21×12×20×5 cell}
load('/Users/aidasaglinskas/Desktop/c.mat')% coordinates for ROIs
coords = c.coords;names = c.names 
%%
mofn_temp = '/Users/aidasaglinskas/Desktop/sROIS/S%d/';
beta_fn.temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/beta_%s.nii';
beta_fn.vect = repmat([ones(1,12),zeros(1,6)],1,5);
beta_fn.inds = find(beta_fn.vect);

tstart = GetSecs;
for s_ind = 1:20
    subID = subvect.face(s_ind);
    % find the size of the ROI
    mofn = sprintf(mofn_temp,subID); %make sub dir
    mkdir(mofn);delete([mofn '*']); % clear sub dir
    func_makeROIsFromCoords_individualSizeROI(coords,names,subID)
    mask = make_mask_struct(mofn);
    %temp = load_nii(fullfile(mask.dir,mask.filenames{1}));
    %sum(temp.img(:));
    
for r_ind = 1:21
for t_ind = 1:12
for sess_ind = 1:5
clc;disp(sprintf('%d/%d|%d/%d|%d/%d|%d/%d - time: %s minutes, %s perc',s_ind,20,r_ind,21,t_ind,12,sess_ind,5,num2str(round((GetSecs - tstart) / 60,2),'%.2f'),num2str(round((s_ind*r_ind) ./ (20*21)*100,2))))
sess_betas = beta_fn.inds(t_ind:12:end);
this_beta_ind = num2str(sess_betas(sess_ind),'%.4i');
this_beta_fn = sprintf(beta_fn.temp,subID,this_beta_ind);
this_mask_fn = fullfile(mask.dir,mask.filenames{r_ind});

ds = cosmo_fmri_dataset(this_beta_fn,'mask',this_mask_fn);
vx.f_voxel_data{r_ind,t_ind,s_ind,sess_ind} = ds.samples;
% mat_all_descrp: 'mat_all(row_index,col_index,task1,task2,r_ind,s_ind)'
    
end
end
end
end


vx.list_r = arrayfun(@(x) [num2str(x,'%.2i') ': ' vx.r_labels{x}],1:length([vx.r_labels]),'UniformOutput',0)'
vx.list_t = arrayfun(@(x) [num2str(x,'%.2i') ': ' vx.t_labels{x}],1:length([vx.t_labels]),'UniformOutput',0)'

save('/Users/aidasaglinskas/Desktop/Federico/newVX_individual2.mat','vx')