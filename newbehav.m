clear;loadMR;
mat = m.mats_RT{3};
cmat_RFX1 = [];cmat2_RFX2 = [];
for s = 1:size(mat,3)
    cmat_RFX1(:,:,s) = corr(mat(:,:,s),'rows','pairwise');
    cmat_RFX2(:,:,s) = corr(mat(:,:,s)','rows','pairwise');
end
cmat_FFX1 = corr(nanmean(mat,3),'rows','pairwise');
cmat_FFX2 = corr(nanmean(mat,3)','rows','pairwise');
mcmat_RFX1 = nanmean(cmat_RFX1,3);
mcmat_RFX2 = nanmean(cmat_RFX2,3);
cmats_all = {mcmat_RFX1 mcmat_RFX2 cmat_FFX1 cmat_FFX2};
cmats_lbls = {m.t_lbls m.f_lbls m.t_lbls m.f_lbls};
%%
cmat_ind = 1;
use_cmat = cmats_all{cmat_ind};
use_lbls = cmats_lbls{cmat_ind};
figure(1)
Z = linkage(1-get_triu(use_cmat),'ward');
[h x perm] = dendrogram(Z,0,'labels',use_lbls,'orientation','left');
make_pretty_dend(h)