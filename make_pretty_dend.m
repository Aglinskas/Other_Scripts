function make_pretty_dend(f,h)

[h(1:end).LineWidth] = deal(3);
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold'
f.Color = [1 1 1]
box off
