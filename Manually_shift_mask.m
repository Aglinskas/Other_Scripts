a = cosmo_fmri_dataset('/Users/aidas_el_cap/Desktop/2fixed_mask_NOnans.nii')

m = find(a.samples == 1);
db = []
transform = [0 2 2]
for k = m
    ovx = [a.fa.i(k) a.fa.j(k) a.fa.k(k)];
    a.samples(k) = 0;
    nvx = [a.fa.i(k) + transform(1) a.fa.j(k) + transform(2) a.fa.k(k) + transform(3)];
    nvxl = find([a.fa.i == nvx(1) & a.fa.j == nvx(2) & a.fa.k == nvx(3)]);
   db = [db;[k nvxl]];
    a.samples(nvxl) = 1;
end

cosmo_map2fmri(a,'test2.nii')



histogram(jm1)

