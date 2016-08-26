clear all
pr_fg = '/Users/aidas_el_cap/Desktop/2nd_Fig/%d%d'
opts_xSPM.p_tresh = 0.1
opts_xSPM.k_extent = 80
set_up_xSPM
% {SPM.xCon.name}'      Available cons
%colormap(map)
%% Cycle thru clust
A = spm_clusters(xSPM.XYZ);
get_mip;
% max(A)
%pause(1)
delete([sprintf(pr_fg,'','') '*'])
clust = unique(spm_clusters(xSPM.XYZ));
for c = clust 
    for s = 1:2; opts_clust.size = s
    go_to_clust = ceil(median(find(A==c)));
spm_results_ui('SetCoords',xSPM.XYZmm(:,go_to_clust))
extract_from_adjusted_cluster
colormap(map)
%pause;
export_fig(sprintf(pr_fg,c,s),'-jpg')
    end
end
disp('done')


%%
A = spm_clusters(xSPM.XYZ);
get_mip;
% max(A)
%pause(1)
delete([sprintf(pr_fg,'','') '*'])
clust = unique(spm_clusters(xSPM.XYZ));
for c = clust 
    for s = 1:2; opts_clust.size = s
    go_to_clust = ceil(median(find(A==c)));
spm_results_ui('SetCoords',xSPM.XYZmm(:,go_to_clust))
plot_w_sections
colormap(map)
%pause;
export_fig(sprintf(pr_fg,c,s),'-jpg')
    end
end
disp('done')
