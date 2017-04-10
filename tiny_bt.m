load('/Users/aidasaglinskas/Desktop/bt_task.mat')
bt = bt - bt(:,11,:,:);
bt = bt(:,1:10,:,:);
bt = zscore(bt,[],2);
w_rois = { [1 2]  [3 4]  [5 6]  [7 8]  [9 10]  [11 12]  [13 14]  [15 16] [17] [18]};
tiny_r_labels = {   'ATL'    'Amygdala'    'pSTS'    'FFA'    'Face Patch'    'IFG'    'OFA'  'Orb'    'PFCmedial'    'Precuneus'};
w_tasks = {[1 5]  [7 8 ] [3 4] [6 10] [2 9]};
tiny_t_labels = {'Episodic' 'Factual' 'Social' 'Nominal' 'Perceptual'};
%% All tiny
% for r = 1:length(w_rois)
%     for t = 1:length(w_tasks)
% tiny_bt(r,t,:,:) = mean(mean(bt(w_rois{r},w_tasks{t},:,:),1),2);
%     end
% end
%%
for r = 1:18%length(w_rois)
    for t = 1:length(w_tasks)
tiny_bt(r,t,:,:) = mean(bt(r,w_tasks{t},:,:),2);
    end
end

%save('/Users/aidasaglinskas/Desktop/Tiny_BT.mat','tiny_bt','w_rois', 'tiny_r_labels' ,'tiny_t_labels')



