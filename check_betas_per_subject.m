load('/Volumes/Aidas_HDD/MRI_data/subBetaArray_32_fixedmPFC_31subs.mat')
load('/Volumes/Aidas_HDD/MRI_data/master_coords2.mat')
load('/Volumes/Aidas_HDD/MRI_data/roi_names')
size(subBetaArray)
%subBetaArray(ROI,task,subject)
%%
task_averaged_B = squeeze(mean(subBetaArray(:,1:10,:),2));
size(task_averaged_B)
%%
for i = 1:size(task_averaged_B,1)
f = figure(5);
bar(task_averaged_B(i,:))
%bar(squeeze(subBetaArray(i,1,:)))
title(roi_names{i})
f.CurrentAxes.XTick = 1:size(subBetaArray,3);
drawnow
pause
end
