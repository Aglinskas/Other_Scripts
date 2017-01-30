clear all
addpath('/Applications/Fiji.app/scripts/')
m = Miji
%%
fn = '/Users/aidasaglinskas/Desktop/3d_play/highres_nopeel.nii'
% Open fn in fiji
m.run('Bio-Formats', ['open=[' fn '] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT']);
