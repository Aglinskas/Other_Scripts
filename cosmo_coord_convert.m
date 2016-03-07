%% Cosmo Voxel to coordiantes
cosmo_voxel = 6183;
i = all_scans.fa.i(cosmo_voxel);
j = all_scans.fa.j(cosmo_voxel);
k = all_scans.fa.k(cosmo_voxel);
[i j k];
Coordinates = [i j k] - 1

% c = find(a.fa.i == i & a.fa.j == j & a.fa.k == k)
% a.samples(c)

%% coordinates to voxel

coordinates = [38 56 43]
cosmo_voxel = find(a.fa.i == coordinates(1) + 1 & a.fa.j == coordinates(2) + 1 & a.fa.k == coordinates(3)) + 1
cosmo_voxel_value = a.samples(cosmo_voxel)