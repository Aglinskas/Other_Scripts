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