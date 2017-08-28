function cg = func_plot_clustergram(m,lbls,ttl)
% cg = func_plot_clustergram(m,lbls,ttl)
cg = clustergram(m,'RowLabels',lbls,'ColumnLabels',lbls),'ImputeFun', @knnimpute;
set(cg, 'Linkage', 'ward', 'Dendrogram',2);
cm = colormap('parula');
set(0, 'DefaultFigureVisible', 'off');
cg.Colormap = cm;
cg.Annotate = 'on';
cg.AnnotPrecision = 2;
cg.AnnotColor = 'k';
cg.LabelsWithMarkers = 1;
cg.Dendrogram = 2;
cg.addTitle(ttl);
%cg_plot = cg.plot
%cg_plot.FontSize = 12
%cg_plot.FontWeight = 'bold'
%delete(cg)
set(0, 'DefaultFigureVisible', 'off');
end