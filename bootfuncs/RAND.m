new = squeeze(mean(Bootstrapedkeep,1));
newVec = get_triu(new);
Z = linkage(1 - newVec,'ward')
figure;dendrogram(Z,'labels',masks_name,'orientation','left')

%%
loadMR
%
useKeep = avgSortedKeep .* 
figure;schemaball(masks_name,useKeep)
figure;add_numbers_to_mat(squeeze(mean(keep,1)),masks_name)


%%
use = squeeze(mean(keep,1))
%%
thresh=.2
ff=((use-thresh).*double((use-thresh)>0))
%
figure;schemaball(masks_name,ff)
%%
figure;add_numbers_to_mat(ff,masks_name)