clear all
loadMR
%load('/Users/aidasaglinskas/Google Drive/MVPA_data/allconf_29-Sep-2016 15:24:47.mat')
%% Unwrap results set
clear a
size(results_set)
for s_ind = 1:length(subvect)%size(results_set,3)
for r_ind  = 1:size(results_set,1)
for p_ind = 1:size(results_set,2)
a(s_ind,r_ind,pairs(p_ind,1),pairs(p_ind,2)) = results_set(r_ind,p_ind,subvect(s_ind));
a(s_ind,r_ind,pairs(p_ind,2),pairs(p_ind,1)) = results_set(r_ind,p_ind,subvect(s_ind));
end
%add_numbers_to_mat2(squeeze(a(s_ind,r_ind,:,:)),tasks)
%title({['Subject ' num2str(s_ind)] ['ROI: ' masks_name{r_ind}]    })
%pause
end
end
%a = a(subvect,:,:,:,:);
size(a)
MVPA_results = a;
%% Sub averaged
i = 1
avg1 = squeeze(mean(a,1));
avg2 = squeeze(mean(avg1,1));
size(avg2)
%for i = 1:18
m = figure(9)
add_numbers_to_mat(squeeze(avg1(i,:,:)),tasks)
m.CurrentAxes.FontSize = 16;
title({masks_name{i} ['all subs averaged']})
%saveas(gcf,['/Users/aidasaglinskas/Desktop/2nd_Fig/MVPA_confMAts_sept30/' masks_name{i}],'jpg')
%end
%wh_r = 1
%add_numbers_to_mat2(avg2(ground_ord,ground_ord),tasks(ground_ord))
%title(masks_name{wh_r})

%% All averaged
%size(subBetaArray) = [18    12    20]
%size(a) = [20    18    12    12]

subMVPAarray = (mean(a,4));
size(subMVPAarray)
all_avg = squeeze(mean(subMVPAarray,1));
%%
b = figure(8)
%for i = 1:18
bar(all_avg(i,:))
b.CurrentAxes.XTickLabel = tasks
b.CurrentAxes.XTickLabelRotation = 15
b.CurrentAxes.FontSize = 14
title({masks_name{i} 'Task decodability'})
saveas(gcf,['/Users/aidasaglinskas/Desktop/2nd_Fig/MVPA_BarGraphs_sept30/' masks_name{i}],'jpg')
%end
%% Raw movie
%add_numbers_to_mat(all_avg(ord,ground_ord),masks_name(ord),tasks(ground_ord))
%mvpa_roi_keep = corr(all_avg');
%mvpa_task_keep = corr(1-all_avg);

                            %MVPA(20,18,12,12)
%squeeze(mean(mean(MVPA_results,1),2))
%% MVPA_keep
clear MVPA_keep
wh_t = 1:10
for sub = 1:20
for roi1 = 1:18
for roi2 = 1:18
MVPA_keep(roi1,roi2,sub) = corr(1-get_triu(squeeze(MVPA_results(sub,roi1,wh_t,wh_t)))',1-get_triu(squeeze(MVPA_results(sub,roi2,wh_t,wh_t)))'); 
%MVPA_keep(roi1,roi2,sub) = corr(1-squeeze(mean(MVPA_results(sub,roi1,:,:),3)),squeeze(1-mean(MVPA_results(sub,roi2,:,:),3))); 
end  
end
end
disp('MVPA_keep Created')
%MVPA_keep = MVPA_keep(wh_r,wh_r,:);
%% Plot Decoding accuracies per subject for a control task
f = figure(9)
bar(MVPA_results(:,6,12,11))
f.CurrentAxes.XTick = 1:20
f.CurrentAxes.XTickLabel = arrayfun(@(x) cellstr(num2str(x)),subvect)%num2str(subvect)
f.CurrentAxes.FontSize = 20
masks_name{5}