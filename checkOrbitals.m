loadMR
%%
size(subBetaArray)

sq = squeeze(mean(mean(subBetaArray(:,:,:),1),2))
%%
for i = 1:18
b = figure(8)
bar(sq(i,:))
hold on
plot(sq(i,:),'r*')
b.CurrentAxes.XTick = [1:size(sq,2)];
title(masks_name{i})
hold off
pause 
end
%% Loop figure task
%subBetaArray(ROI,Task,subject)
%subBetaArray = subBetaArray(:,:,[1:8 10:20])
t = tasks;
%w_task = 1;
nsubs = size(subBetaArray,3)
v = squeeze(mean(subBetaArray(:,w_task,:),1));
b = figure(8)
bar(squeeze(mean(subBetaArray(:,w_task,:),1)))
hold on
plot(squeeze(mean(subBetaArray(:,w_task,:),1)),'r*')
hold off
b.CurrentAxes.XLim = [0 nsubs + 1]
b.CurrentAxes.XTick = 1:nsubs
title(t{w_task})
w_task = w_task+1
%% Average
loadMR
hold off
dt = squeeze(mean(mean(subBetaArray,2),1));
dt = zscore(dt)
bar(dt)
hold on 
plot(dt,'r*')
%%
loadMR
for r = 1:2:size(subBetaArray,1)
for t = 1:size(subBetaArray,2)
s = r
dt = squeeze(subBetaArray(s,t,:));
b = figure(8)
hold off;clf
subplot(3,4,1)
bar(dt);
hold on 
plot(dt,'r*');
b.CurrentAxes.XLim = [0 size(subBetaArray,3)+1];
b.CurrentAxes.YLim = [min(reshape(subBetaArray(s,:,:),[],1)) max(reshape(subBetaArray(s,:,:),[],1))];
b.CurrentAxes.XTick = [0 : size(subBetaArray,3)];
ttl = [masks_name{s} ' ' tasks{t}];
title(ttl);

drawnow;
pause(1);
[r t]
end
end
clf



