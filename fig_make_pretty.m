function fig_make_pretty(f,ttl)
% fig_make_pretty(f,ttl)
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
title(ttl,'fontsize',20);
f.CurrentAxes.XTickLabelRotation = 45;
box off;
end