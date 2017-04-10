clear
loadMR
load('/Users/aidasaglinskas/Desktop/bt_task.mat')
%%
arr = bt;
arr(:,:,:,6) = mean(arr(:,:,:,:),4);

arr = arr - arr(:,11,:,:);
arr = arr(:,1:10,:,:);
arr = zscore(arr,[],1);

%Task
clear keep
for r_ind = 1:6
for s_ind = 1:20
    for t1 = 1:10
        for t2 = 1:10
       %keep(r1,r2,r_ind,s_ind) = corr(arr(r1,:,s_ind,r_ind)',arr(r2,:,s_ind,r_ind)');
       keep(t1,t2,r_ind,s_ind) = corr(arr(:,t1,s_ind,r_ind),arr(:,t2,s_ind,r_ind));
        end
    end
end
end

% %ROI
% clear keep
% for r_ind = 1:6
% for s_ind = 1:20
%     for r1 = 1:18
%         for r2 = 1:18
%        keep(r1,r2,r_ind,s_ind) = corr(arr(r1,:,s_ind,r_ind)',arr(r2,:,s_ind,r_ind)');
%        keep(t1,t2,r_ind,s_ind) = corr(arr(:,t1,s_ind,r_ind),arr(:,t2,s_ind,r_ind));
%         end
%     end
% end
% end

%
size(keep)
mkeep = mean(keep,4);

ttls = {'Run 1' 'Run 2' 'Run 3' 'Run 4' 'Run 5' 'Run Avg'}

%lbls = masks.lbls_nii;
lbls = t_labels(1:10);
for r_ind = 1:6
    
this_keep = mkeep(:,:,r_ind);
newVec = get_triu(this_keep);
Z = linkage(1-newVec,'ward');

sp = subplot(2,3,r_ind);
[h x perm] = dendrogram(Z,'labels',lbls,'orientation','left');
[h(1:end).LineWidth] = deal(3);
sp.FontSize = 12;
sp.FontWeight= 'bold'
title(ttls{r_ind})
end

