loadMR
%%
data_fn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Functional/Sess%d/wdata.nii';

for s_ind = 1:20;
subID = subvect(s_ind);
for m_ind = 1:18;
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
rep  = 'Running subject: %d/20, mask: %d/18';
disp(sprintf(rep,s_ind,m_ind))
for sess_ind = 1:5;
data_fn = sprintf(data_fn_temp,subID,sess_ind);
ds = cosmo_fmri_dataset(data_fn,'mask',m_fn);
%vec = mean(ds.samples,2);
tsnr(m_ind,s_ind,sess_ind) = mean( mean(ds.samples) ./ std(ds.samples));

end
end
end

save('/Users/aidasaglinskas/Desktop/TSNR.mat')
%add_numbers_to_mat(squeeze(mean(tsnr,2)),r_labels)
%%
size(tsnr)

mat = mean(tsnr,3);
mat = mean(mat,2);
mat = squeeze(mat);

f = figure(1)
add_numbers_to_mat(mat')

f.CurrentAxes.XTick = 1:18
f.CurrentAxes.XTickLabel = masks.lbls_nii
f.CurrentAxes.XTickLabelRotation = 45
f.CurrentAxes.FontSize = 12
f.CurrentAxes.FontWeight = 'bold'
title({'TSNR'},'FontSize',28)