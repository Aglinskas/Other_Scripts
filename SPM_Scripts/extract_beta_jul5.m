clear all
loadMR
masks.dir = '/Users/aidasaglinskas/Desktop/faces_blobsp01/'
temp = dir([masks.dir 'ROI*.nii']);
masks.nii_files = {temp.name}'
temp = strrep(masks.nii_files,'ROI_','');
temp = strrep(temp,'.nii','');
masks.lbls_nii = temp;
%%
bt_fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/beta_%s.nii';
bt_vec = find(repmat([ones(1,12) zeros(1,6)],1,5));
f_subvec = [ 7     8     9    10    11    14    15    17    18    19    20    21    22    24  25    27    28    29    30    31]; 
w_subvec = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22]'
subvec = f_subvec;
mat = [];
for s_ind = 1:length(subvec);
    subID = subvec(s_ind);
for m_ind = 1:length(masks.nii_files)
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
disp(sprintf('subject %d/%d mask %d/%d',s_ind,length(subvec),m_ind,length(masks.nii_files)));
tic
for t_ind = 1:12
    run_betas = bt_vec(t_ind:12:end);
    
parfor run_ind = 1:5
bt_ind = run_betas(run_ind);
bt_str = num2str(bt_ind,'%.4i');

bt_fn = sprintf(bt_fn_temp,subID,bt_str);
    
    ds = cosmo_fmri_dataset(bt_fn,'mask',m_fn);
    mat(m_ind, t_ind, s_ind,run_ind) = nanmean(ds.samples);
end
end
toc
end
end
mat = mean(mat,4);
save('/Users/aidasaglinskas/Desktop/mat.mat','mat','masks')
%%


