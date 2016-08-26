subID = 22
opts_xSPM.spm_path = sprintf('/Volumes/Aidas_HDD/MRI_data/S%d/Analysis/SPM.mat',subID);
ofn  = '/Users/aidas_el_cap/Desktop/2nd_Fig/'
set_up_xSPM
%%
opts_clust.size = 2
opts_clust.inset = 4 % 1 = full, 2 = adjusted
opts_clust.suppress4 = 1;
extract_from_adjusted_cluster
%% Cycle thru clust
A = spm_clusters(xSPM.XYZ);
clust = unique(spm_clusters(xSPM.XYZ));
for c = clust 
    for s = 1:2 % cycle options
opts_clust.size = s;
go_to_clust = ceil(median(find(A==c)));
spm_results_ui('SetCoords',xSPM.XYZmm(:,go_to_clust))
extract_from_adjusted_cluster
export_fig([ofn num2str(c) num2str(s)])
disp(['printing' num2str(c) '/' num2str(max(clust))])
    end
end