function Coordinates = v2c(cosmo_voxel,all_scans)
%cosmo_voxel = 6183;
i = all_scans.fa.i(cosmo_voxel);
j = all_scans.fa.j(cosmo_voxel);
k = all_scans.fa.k(cosmo_voxel);
[i j k];
Coordinates = [i j k] - 1;
end