loadMR2
%subBetaArray = subBetaArray(:,:,[1:8 10:20]);
%% Keep
% clear keep roi_keep task_keep

%SubBetaArray(ROI,TASK,SUBJECT)
%ROI_KEEP
for subj = 1:size(subBetaArray,3)
    for r = 1:size(subBetaArray,1);
        for c = 1:size(subBetaArray,1);
    roi_keep(subj,r,c) = corr(squeeze(subBetaArray(r,1:10,subj))',squeeze(subBetaArray(c,1:10,subj))');         
        end
    end
end
%%
which_rois_to_cor = 1:size(subBetaArray,1);
reducedBetaArray=(subBetaArray(which_rois_to_cor,1:12,:));%subBetaArray(ROI,TASK,SUB)
clear roi_keep task_keep
for subj=1:size(reducedBetaArray,3)
   %roi_keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,:,subj))','type', 'Spearman'); %the transpose is important reducedBetaArray(:,:,subj))'); 
   roi_keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,1:10,subj))','type', 'Spearman'); %the transpose is important reducedBetaArray(:,:,subj))'); 
   task_keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,1:10,subj)),'type', 'Spearman'); %the transpose is important reducedBetaArray(:,:,subj))'); 
end
%disp()
%size(roi_keep)
%%
%%
matrix = task_keep
lbls = {tasks{1:10}}'
singmat = squeeze(mean(matrix,1))
%singmat = avgSortedKeep
newVec = get_triu(singmat)
Z = linkage(1-newVec,'ward')
dendrogram(Z,'labels',lbls,'orientation','left')
%% Task Cor MAt
% clear Task_Cor_Mat
% %y = [1:12 15 18] % which rois
% y = 1:18 % ROIS
% tt = 1
% subBetaArray = subBetaArray(:,:,[1:8 10:20]); % reduce subjects
% %subBetaArray = subBetaArray(:,1:10,:);
% for subject = 1:size(subBetaArray,3); % loop subjects
%     for r = 1:size(subBetaArray,2); % loop task
%         for c = 1:size(subBetaArray,2); % loop task
% Task_Cor_Mat(subject,r,c) = corr(subBetaArray(y,r,subject),subBetaArray(y,c,subject),'type', 'Spearman');
%         end
%     end
% end