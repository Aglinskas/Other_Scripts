loadMR
L = spm_atlas('list');
xA = spm_atlas('load',L.file);
ii = 1
%% Set up a subject
for ii = [1:12 14:20]
%%
subID = subvect(ii)
opts_xSPM.spm_path = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/SPM.mat',subID)
opts_xSPM.p_tresh = .001;
opts_xSPM.k_extent = 15;
opts_xSPM.mask_which_mask_ind = 0;
opts_xSPM.useContrast = 2; %3 or 1
opts_xSPM.MC_correction = 'none'
set_up_xSPM
clusters = spm_clusters(xSPM.XYZ);
%% SetCoords
for a_ind = [1 2]
    a = [38 -54 -20
     -40 -52 -20]
%[42 -52 -26
% 42   -46   -22
% -39   -46   -22
%  42 -58 -23]
spm_mip_ui('SetCoords',a(a_ind,:),mip)
%% GetCoords & label
curr_coords = spm_mip_ui('SetCoords',spm_mip_ui('GetCoords',mip),mip)'
spm_atlas('query',xA,curr_coords')
% curr_coords = spm_mip_ui('Jump',mip,'nrmax')'
%% Save Fig
mip
curr_coords = spm_mip_ui('SetCoords',spm_mip_ui('GetCoords',mip),mip)'
curr_coords = spm_mip_ui('Jump',mip,'nrmax')';
this_voxel_ind = find(xSPM.XYZmm(1,:) == curr_coords(1) & xSPM.XYZmm(2,:) == curr_coords(2) & xSPM.XYZmm(3,:) == curr_coords(3));
if isempty(this_voxel_ind)
    ttl = [num2str(curr_coords) ' no significant voxels here'];
else
this_clust = clusters(1,this_voxel_ind);
this_clust_size = length(find(clusters == this_clust));
ttl = [num2str(curr_coords) ' size: ' num2str(this_clust_size) ' Voxels']
end
mip
title(ttl)
saveas(mip,['/Users/aidasaglinskas/Desktop/2nd_Fig/mip2/' '001sub ' num2str(subID) ' Coord ' ttl ' Pthresh ' strrep(num2str(opts_xSPM.p_tresh),'0.','')],'jpg')
end
end
%% 
%extract_from_adjusted_cluster