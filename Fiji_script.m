clear all
addpath('/Applications/Fiji.app/scripts/')
m = Miji
%
%fn{1} = '/Users/aidasaglinskas/Google Drive/Data/S11/Anatomical/Ana_nopeel.nii'
%fn{2} = '/Users/aidasaglinskas/Desktop/sds,sd.jpg'
%m.run('Open...', ['path=' fn]);
%%
m.run('Bio-Formats', 'open=/Users/aidasaglinskas/Desktop/3d_play/highres_nopeel.nii autoscale color_mode=Default rois_import=[ROI manager] split_timepoints view=Hyperstack stack_order=XYCZT');
