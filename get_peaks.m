%% Get_peaks
clusters = spm_clusters(xSPM.XYZ);
num_clust = unique(clusters)
for curr_clust = num_clust
curr_clust_inds = find(clusters == curr_clust);
peak_ind = find(xSPM.Z == max(xSPM.Z(curr_clust_inds)))
peakZ = xSPM.Z(peak_ind)
peakC = xSPM.XYZmm(:,peak_ind)'
mip_peaks{curr_clust} = peakC
mip_peaks(curr_clust,4) = peakZ
end