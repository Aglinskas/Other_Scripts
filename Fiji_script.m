addpath('/Applications/Fiji.app/scripts/')
m = Miji
%%
fn = '/Users/aidasaglinskas/Desktop/Clutter/Aidas:  Summaries & Analyses (WP 1.4)/MVPA/MVPA 4th Feb/Aidas_MVPA/Data/S6/Ana_peel.nii'
MIJ.run(fn)
MIJ.run('Open...', 'path=[/Users/aidasaglinskas/Desktop/Clutter/Aidas:  Summaries & Analyses (WP 1.4)/MVPA/MVPA 4th Feb/Aidas_MVPA/Data/S6/Ana_peel.nii]')
%%
%MIJ.run('Open...', 'path=[C:\\Documents and Settings\\Fiji\\Test.png]')
%OPENING
% MIJ.run('Embryos (42K)');
% I = MIJ.getCurrentImage;
% E = imadjust(wiener2(im2double(I(:,:,1))));
% imshow(E);
% MIJ.createImage('result', E, true);
%m.exit