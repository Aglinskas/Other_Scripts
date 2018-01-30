clear;loadMR;
%%
mat = [];
fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Functional/Sess%d/wdata.nii';
for sess_ind = 1:5;
for s_ind = 1:20;
    subID = subvect.face(s_ind);
for m_ind = 1:21;
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
fn = sprintf(fn_temp,subID,sess_ind);
dt = cosmo_fmri_dataset(fn,'mask',m_fn);
v = mean(dt.samples,2);
mat(m_ind,sess_ind,s_ind,:) = v;
clc;
disp(sprintf('sess: %d/5 s_ind: %d/20 ROI: %d/21',sess_ind,s_ind,m_ind))
end

save('/Users/aidasaglinskas/Desktop/fc1.mat','mat')
end
end
%%
cmat = [];
for s_ind = 1:20
for sess_ind = 1:5
   cmat(:,:,sess_ind,s_ind) = corr(squeeze(mat(:,sess_ind,s_ind,:))');
end
end
mcmat = mean(mean(cmat,3),4);
%mcmat = squeeze(mean(cmat,3));
%%
Z = linkage(get_triu(1-mcmat),'ward');
lbls = masks.lbls
[h x perm] = dendrogram(Z,0,'labels',lbls,'orientation','left')
make_pretty_dend(h)
add_numbers_to_mat(mcmat(perm,perm),lbls(perm))
%%



%%


