opts_xSPM.spm_path = '/Volumes/Aidas_HDD/MRI_data/Group2_Analysis/SPM.mat'
opts_xSPM.useContrast = 2
set_up_xSPM

% opts_xSPM.p_tresh
% opts_xSPM.MC_correction
% opts_xSPM.k_extent
% opts_xSPM.mask_which_mask_ind
%%
clusters = spm_clusters(xSPM.XYZ);
c2 = find(xSPM.XYZ(:, clusters==2));
peak_ind = find(xSPM.Z == max(xSPM.Z(find(xSPM.XYZ(:, clusters==9)))))
peakZ = xSPM.Z(peak_ind)
peakC = xSPM.XYZmm(:,peak_ind)'
%% find current cluster
curr_coord = spm_results_ui('GetCoords')
ff = find(xSPM.XYZmm(1,:) == curr_coord(1) & xSPM.XYZmm(2,:) == curr_coord(2) & xSPM.XYZmm(3,:) == curr_coord(3))
curr_clust = clusters(ff)

%% Get peaks

%%w

% 
% opts_clust.inset = 4
opts_clust.size = 2
opts_clust.inset = 2
try;clf(b);catch;end
extract_from_adjusted_cluster
b = figure(500); b.Position = [1 1 1388 804];
%close(g)

%%
%% Cycle thru clust
opts_xSPM.spm_path = '/Volumes/Aidas_HDD/MRI_data/Group3_Analysis_mask02/SPM.mat'
opts_xSPM.mask_which_mask_ind = 3;
set_up_xSPM
%%
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/wut/'
A = spm_clusters(xSPM.XYZ);
clust = unique(spm_clusters(xSPM.XYZ));
for c = clust 
go_to_clust = ceil(median(find(A==c)));
spm_results_ui('SetCoords',xSPM.XYZmm(:,go_to_clust))
extract_from_adjusted_cluster3
b = figure(500)
%title({master_coords_legend([master_coords_legend.spmCluster] == c).label})
drawnow
saveas(b,[ofn num2str(c)],'png')
% disp(['printing' num2str(c) '/' num2str(max(clust))])
% export_fig()
end


%% master_coords_legend  way 
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/ScottROIs/'
A = spm_clusters(xSPM.XYZ);
clust = unique(spm_clusters(xSPM.XYZ));
for c = clust %length(master_coords_legend)%clust 
go_to_clust = ceil(median(find(A==c)));
spm_results_ui('SetCoords',xSPM.XYZmm(:,go_to_clust))



aa = [master_coords_legend.nearestCoords]';
cc = round(spm_mip_ui('Getcoords'))';
v = sum(abs([aa(:,1) - cc(1) aa(:,2) - cc(2) aa(:,3) - cc(3)]),2);
y = master_coords_legend(find(abs(v) == min(abs(v)))).label;
sanch{c} = y;
% extract_from_adjusted_cluster3
% b = figure(500)
% title([master_coords_legend([master_coords_legend.spmCluster] == c).label ' ' num2str(master_coords_legend(c).nearestCoords')])
% drawnow
% saveas(b,[ofn num2str(c)],'png')
% disp(['printing' num2str(c) '/' num2str(max(clust))])
% export_fig()
end

%%