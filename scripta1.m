clear all
loadMR
w_t = [1:10];
%w = warning('query','last');
warning('off','stats:linkage:NotEuclideanMatrix');
nperms = 1
fid.mat = zeros(18,18);
fid.allmat = zeros(nperms,18,18);

for perm = 1:nperms

for s = 1:20%randi(20,[1 20])%20;
    b_roi = zscore(subBeta.array(:,[1:10],s),[],2);
    keep.roi(:,:,s) = corr(b_roi');
    b_task = zscore(subBeta.array(:,1:10,s),[],1);
    keep.task(:,:,s) = corr(b_task);
end
keep.roi = mean(keep.roi,3);
keep.task = mean(keep.task,3);
roi_or_task = 1;
    all.mats = {keep.roi keep.task};
    all.labels = {r_labels t_labels(1:10)};
    t.mat = all.mats{roi_or_task};
    t.labels = all.labels{roi_or_task};
    
    newVec = get_triu(t.mat);
    Z = linkage(1-newVec,'ward');
   figure(1)
   dendrogram(Z)
    n_items = length(t.mat);
    Z_atlas = get_Z_atlas(Z,n_items);
    %dendrogram(Z)
%end % ends perm
for r = 1:length(Z_atlas)
fid.mat([Z_atlas{r,[1]}],[Z_atlas{r,[2]}]) =fid.mat([Z_atlas{r,[1]}],[Z_atlas{r,[2]}])+ Z_atlas{r,3};
fid.mat([Z_atlas{r,[2]}],[Z_atlas{r,[1]}]) = fid.mat([Z_atlas{r,[2]}],[Z_atlas{r,[1]}]) + Z_atlas{r,3};

fid.allmat(perm,[Z_atlas{r,[1]}],[Z_atlas{r,[2]}]) =fid.allmat(perm,[Z_atlas{r,[1]}],[Z_atlas{r,[2]}])+ Z_atlas{r,3};
fid.allmat(perm,[Z_atlas{r,[2]}],[Z_atlas{r,[1]}]) = fid.allmat(perm,[Z_atlas{r,[2]}],[Z_atlas{r,[1]}]) + Z_atlas{r,3};
end

end %ends perm
disp('done')
%

% plot fid mat
fid.avgmat = fid.mat ./ perm;
newVec = get_triu(fid.avgmat);
Z = linkage(newVec);
figure(9)
[h p ord] = dendrogram(Z);
%[h p ord] = dendrogram(Z,'labels',r_labels,'orientation','left');
title('permuted mean clustering')

figure(8)
add_numbers_to_mat(fid.avgmat(ord,ord), r_labels(ord))
title('permuted mean dissimilarity')
%%
figure(9)
%[h p ord] = dendrogram(Z);
[h p ord] = dendrogram(Z,'labels',r_labels,'orientation','left');