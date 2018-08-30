% get_sections
%if exist('sections_fig','var') == 0
%set(0,'DefaultFigureVisible','off')
sections_fig = figure(300);
set(sections_fig,'Visible', 'off');
 %set(sections_fig,'Visible', 'off');
%a = figure(300,'Visible', 'off');%

spm_figs = (get(0, 'Children')); %figure out SPM graphics window, go to graphics, get children;
for p = 1:length(spm_figs);
if strmatch(spm_figs(p).Name,'SPM12 (6685): Graphics');
    disp(['found spm graphics window, it''s ' num2str(p)]);
    spm_g = spm_figs(p);
    for o = 1: length(spm_g.Children);
        if strmatch('hMIPax',spm_g.Children(o).Tag);
            mip = spm_g.Children(o);
        end
    end
end
end

sag = spm_figs(1).Children(14);
cor = spm_figs(1).Children(15);
axial = spm_figs(1).Children(13);
copyobj(sag,gcf);
copyobj(cor,gcf);
copyobj(axial,gcf);
colormap(sections_fig,map)
%set(0,'DefaultFigureVisible','on')

%figure(300)