get_sections
figure(301)
j = subplot(2,1,1)
opts_clust.inset = 0
copyobj(f.Children(10).Children(:),j)
j = subplot(2,3,4)
copyobj(sag.Children(:),j)
j= subplot(2,3,5)
copyobj(axial.Children(:),j)
j = subplot(2,3,6)
copyobj(cor.Children(:),j)
colormap(map)


%%
opts_clust.inset = 3
extract_from_adjusted_cluster
%%
opts_clust.inset = 4
extract_from_adjusted_cluster
%%