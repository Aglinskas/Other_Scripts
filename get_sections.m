% get_sections
%if exist('sections_fig','var') == 0
%set(0,'DefaultFigureVisible','off')
sections_fig = figure(300);
set(sections_fig,'Visible', 'off');
 %set(sections_fig,'Visible', 'off');
%a = figure(300,'Visible', 'off');%
%
sag = spm_figs(1).Children(14);
cor = spm_figs(1).Children(15);
axial = spm_figs(1).Children(13);
copyobj(sag,gcf);
copyobj(cor,gcf);
copyobj(axial,gcf);
colormap(sections_fig,map)
%set(0,'DefaultFigureVisible','on')

%figure(300)