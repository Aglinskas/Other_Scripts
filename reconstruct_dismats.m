load('/Users/aidas_el_cap/Desktop/RSA_ana/all_conf1_5.mat')
% load meanall_corResult
%%
%meanall_corResult{roi,subid,pair}
%subvect
for roi_ind = 1:length(rois);
for pair_ind = 1:length(pairs);
    roi_name{roi_ind};
    lbls(pairs(pair_ind,:))';
r_cormat(pairs(pair_ind,1),pairs(pair_ind,2)) = mean([meanall_corResult{roi_ind,subvect,pair_ind}]);
r_cormat(pairs(pair_ind,2),pairs(pair_ind,1)) = mean([meanall_corResult{roi_ind,subvect,pair_ind}]);
end
%end
%% Plot
ofn = '/Users/aidas_el_cap/Desktop/2nd_Fig/confusion5/';
if exist(ofn) == 0; mkdir(ofn);end
conf = figure(5);
imagesc(r_cormat);
drawnow
conf.CurrentAxes.XTick = [1:12];conf.CurrentAxes.YTick = [1:12];
conf.CurrentAxes.XTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.XTickLabel)}};
conf.CurrentAxes.YTickLabel = {lbls{cellfun(@str2num,conf.CurrentAxes.YTickLabel)}};
colorbar
conf.Position = [-1214          -1        1120         806];
ttl_c = ['All Sub AVG Confusion Matrix ' roi_name{roi_ind}];
title(ttl_c);
saveas(conf,[ofn ttl_c],'jpg');
Z = linkage(r_cormat,'ward');
dend = figure(4);dendrogram(Z);
drawnow
dend.Position = [-1274          -6        1267         811];
ttl_d = ['All Sub AVG Dendogram ' roi_name{roi_ind}];
title(ttl_d);
dend.CurrentAxes.XTickLabel = lbls(str2num(dend.CurrentAxes.XTickLabel));
saveas(dend,[ofn ttl_d],'jpg');
end