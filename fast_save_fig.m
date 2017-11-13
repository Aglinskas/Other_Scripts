tic
disp('Exporting')
ofn = fullfile('/Users/aidasaglinskas/Desktop/Figures/',[datestr(datetime) '.pdf']);
export_fig(ofn,'-pdf','-transparent','-opengl');
toc

%{painters opengl zbuffer}