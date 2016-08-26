function [cosmo_voxel cosmo_voxel_value] = c2v(coordinates,all_scans)
%coordinates = [38 56 43]
cosmo_voxel = find(all_scans.fa.i == coordinates(1) + 1 & all_scans.fa.j == coordinates(2) + 1 & all_scans.fa.k == coordinates(3)) + 1
cosmo_voxel_value = all_scans.samples(cosmo_voxel)
end