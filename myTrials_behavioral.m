load('/Users/aidasaglinskas/Google Drive/Mat_files/Other_mats/all_myTrials.mat')
%%
nanmedian([all_myTrials.RT])
nanmedian([all_myTrials.resp])
%%
subplot(1,2,1)
plot(sort([all_myTrials.resp]))
subplot(1,2,2)
histogram(sort([all_myTrials.resp]))
%% Reaction times by task
for b = 1:12
    b_inds = find([all_myTrials.blockNum] == b);
    des(1,b) = nanmedian([all_myTrials(b_inds).resp]);
    des(2,b) = nanstd([all_myTrials(b_inds).resp]);
end
    
%  errorbar(Y,E) plots Y and draws a vertical error bar at each element of
%     Y. The error bar is a distance of E(i) above and below the curve so
%     that each bar is symmetric and 2*E(i) long.
%%
f = figure(1)
clf
bar(des(1,:))
hold on
errorbar(des(1,:),des(2,:),'r')
f.CurrentAxes.XTickLabel = t_labels
f.CurrentAxes.FontSize = 20
f.CurrentAxes.XTickLabelRotation = 25
%% add names 
for r = 1:length(all_myTrials);
sp = strsplit(all_myTrials(r).filepath,'/');
if strcmp(sp{1},'People')
    all_myTrials(r).isperson = 1;
else
    all_myTrials(r).isperson = 0;
end
all_myTrials(r).name = sp{2};
end
%%
loadMR
for s = 1:20
    subID = subvect(s);
for b = 1:12
    b_inds = find([all_myTrials.blockNum] == b & [all_myTrials.subID] == subID);
    des(1,b,s) = nanmedian([all_myTrials(b_inds).RT]);
    des(2,b,s) = nanstd([all_myTrials(b_inds).RT]);
end
end
disp('done')
%%

s = s+1
f = figure(1)
clf
bar(des(1,:,s))
hold on
errorbar(des(1,:,s),des(2,:,s),'r')
f.CurrentAxes.XTickLabel = t_labels
f.CurrentAxes.FontSize = 20
f.CurrentAxes.XTickLabelRotation = 25
%%
