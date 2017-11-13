clear;clc;tic
Subs_to_run = [ 1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31]; % WORD EXP
spm_con_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/Analysis_INDF/con_%s.nii';

masks.dir = '/Users/aidasaglinskas/Desktop/RR/';
a = dir([masks.dir '*.nii']);
masks.nii_files = {a.name}';
a = strrep({a.name}','ROI_','');
a = strrep(a,'.nii','');
masks.lbls = a;

vx = struct;
for s_ind = 1:length(Subs_to_run)
    subID = Subs_to_run(s_ind)
for con_ind = 1:40;
    clc;disp(sprintf('S:%d/24/C:%d/40',s_ind,con_ind))
for r_ind = 1:length(masks.nii_files)
con_fn = sprintf(spm_con_temp,subID,num2str(con_ind,'%.4i'));
mask_fn = fullfile(masks.dir,masks.nii_files{r_ind});
ds = cosmo_fmri_dataset(con_fn,'mask',mask_fn);
vx.vx{r_ind,con_ind,s_ind} = ds.samples;
end
end
end
toc

load('/Users/aidasaglinskas/Desktop/unique_face.mat');
vx.roi_lbls = masks.lbls;
vx.unique_faces = unique_face;
save('/Users/aidasaglinskas/Desktop/INDF_VX.mat','vx')
%%
vx.mat  =[];
for r = 1:size(vx.vx,1)
for f = 1:size(vx.vx,2)
for s = 1:size(vx.vx,3)
vx.mat(r,f,s) = nanmean(vx.vx{r,f,s});
end
end
end
vx.mat(:,:,11) = [];
vx.vx(:,:,11) = [];
%% Show mat
v = 1:21;
v(11) = []; % subject 11 is all fucked up
m = mean(vx.mat(:,:,v),3)
m = zscore(m,[],2)
add_numbers_to_mat(m,vx.roi_lbls,vx.unique_faces)
%% Dendros
fcmat = [];
rcmat = [];
r_ninds = [9 10 13 14 19 20];
inds = find(~ismember(1:21,r_ninds))
for s = 1:size(vx.mat,3)
fcmat(:,:,s) = corr(vx.mat(inds,:,s));
rcmat(:,:,s) = corr(vx.mat(inds,:,s)');
end
cmat = {fcmat rcmat};
albls = {vx.unique_faces vx.roi_lbls(inds)};

ind = 1;
vec = 1-get_triu(mean(cmat{ind},3));
Z = linkage(vec,'ward');
f = figure(2)
[h x perm] = dendrogram(Z,0,'labels',albls{ind},'orientation','left');
make_pretty_dend(f,h)
%% Correlation with ratings;
s_inds = find(ismember(vx.subvec,vx.behav_subvec));
vx_red = vx.mat(:,:,s_inds);
cmat = [];
vx.rating_mat = 5 - vx.rating_mat;
%vx.rating_mat = -(vx.rating_mat-5)
for s_ind = 1:size(vx_red,3);
for t_ind = 1:10;
for r_ind = 1:size(vx_red,1);
rating_vec = vx.rating_mat(t_ind,:,s_ind)';
beta_vec = vx_red(r_ind,:,s_ind)';
c = corr(rating_vec,beta_vec,'rows','pairwise');
cmat(r_ind,t_ind,s_ind) = c;
end
end
end
disp('done')
add_numbers_to_mat(mean(cmat,3),vx.roi_lbls,vx.t_labels(1:10))
%%
for i = 1:21
for j = 1:10
[H,P,CI,STATS] = ttest(squeeze(cmat(i,j,:)));
tmat(i,j) = STATS.tstat;
end
end
f = figure(2)
add_numbers_to_mat(tmat,vx.roi_lbls,vx.t_labels(1:10))
f.CurrentAxes.CLim = [1.96 1.97]
%% Multivariate Correlation

cmat = [];
for r_ind = 1:21
for s_ind = 1:23
for f1 = 1:40
for f2 = 1:40
    c = corr(vx.vx{r_ind,f1,s_ind}',vx.vx{r_ind,f2,s_ind}','rows','pairwise');
    cmat(r_ind,f1,f2,s_ind) = c;
end
end
end
end
disp('done')
%%
rcmat = [];
for s_ind = 1:23
for r1 = 1:21
for r2 = 1:21
c = corr(get_triu(squeeze(cmat(r1,:,:,s_ind)))',get_triu(squeeze(cmat(r2,:,:,s_ind)))');
rcmat(r1,r2,s_ind) = c;
end
end
end
disp('done')
%%

f = figure(1)
m = mean(rcmat,3);
Z = linkage(1-get_triu(m),'ward');
[h x perm] = dendrogram(Z,'labels',vx.roi_lbls,'orientation','left');
make_pretty_dend(f,h)




