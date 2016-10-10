for subID = subvect
opts_xSPM.spm_path = sprintf('/Users/aidasaglinskas/Google Drive/MRI_data/S%d/Analysis_mask02/SPM.mat',subID)
opts_xSPM.p_tresh = .999;
opts_xSPM.k_extent = 0;
opts_xSPM.mask_which_mask_ind = 0;
opts_xSPM.useContrast = 2;
opts_xSPM.MC_correction = 'none'
set_up_xSPM

spm_mip_ui('SetCoords',[40 -50 -22]',mip)
%spm_mip_ui('Jump',mip,'nrmax')
cor.Title.String = ['[40 -50 -22] Position']
ofn = '/Users/aidasaglinskas/Desktop/2nd_Fig/Signal_Dropout/';
if exist(ofn) == 0
    mkdir(ofn)
end
saveas(mip,[ofn num2str(subID)],'bmp')
end