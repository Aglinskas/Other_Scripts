roi = 16;
%%
m = squeeze(mean(mean(MVPA_results(:,:,1:10,1:10),1),4));
b = mean(subBetaArray(:,1:10,:),3);
net_mean_b = mean(b)';
net_mean_m = mean(m)';
this_b = b(roi,:)'% - net_mean_b
this_m = m(roi,:)'% - net_mean_m
%perc_m = 100*this_m ./ net_mean_m
%perc_b = 100*this_b ./ net_mean_b

bar_plot = figure(7)
n = subplot(2,1,1)
bar(this_b)
bar_plot.CurrentAxes.XTickLabel = {tasks{1:10}}'
legend('betas')
title(masks_name{roi})
nn = subplot(2,1,2)
bar(this_m)
legend('MVPA')
bar_plot.CurrentAxes.XTickLabel = tasks
title(masks_name{roi})

%ylim([-100 500])
title(masks_name{roi})
if roi == 19
    roi = 1
else
roi = roi+1
end