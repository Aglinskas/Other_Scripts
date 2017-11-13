tic
temp = gcf
temp.Visible = 'off'
disp('Exporting')
ofn = fullfile('/Users/aidasaglinskas/Desktop/Figures/',[datestr(datetime) '.png']);
export_fig(ofn,'-png','-transparent','-opengl');
toc