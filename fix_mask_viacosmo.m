dt = cosmo_fmri_dataset('/Users/aidas_el_cap/Desktop/rBroadMVPMask.nii')
dt.samples(dt.samples < 1) = 0;
dt.samples(dt.samples > 1) = 1;
hist(dt.samples)
cosmo_map2fmri(dt,'/Users/aidas_el_cap/Desktop/fixed_rBroadMVPMask.nii')