mask1 = '/Users/aidas_el_cap/Desktop/2fixed_mask_NOnans.nii'
mask2 = '/Users/aidas_el_cap/Desktop/test2.nii'
fn = '/Users/aidas_el_cap/Desktop/Scott_MVPA/MVPA_results/Sub6_MVPA_results1.nii'

a1 = cosmo_fmri_dataset(fn,'mask',mask1);
a2 = cosmo_fmri_dataset(fn,'mask',mask2);

jm1 = cosmo_fmri_dataset(mask1)
jm2 = cosmo_fmri_dataset(mask2)

tresh = 0.02
n_vox = ['Mask1 ' num2str(length(find(a1.samples > tresh))) ' Mask2 ' num2str(length(find(a2.samples > tresh)))]