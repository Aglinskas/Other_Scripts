loadMR
subBetaArray = subBetaArray(:,:,[1:8 10:20]);
%% Keep
clear keep
which_rois_to_cor = 1:size(subBetaArray,1);
reducedBetaArray=(subBetaArray(which_rois_to_cor,1:10,:));%subBetaArray(ROI,TASK,SUB)
for subj=1:size(reducedBetaArray,3)
   keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,:,subj))','type', 'Spearman'); %the transpose is important reducedBetaArray(:,:,subj))'); 
end
size(keep)
%% Task Cor MAt
clear Task_Cor_Mat
%y = [1:12 15 18] % which rois
y = 1:18 % ROIS
tt = 1
subBetaArray = subBetaArray(:,:,[1:8 10:20]); % reduce subjects
%subBetaArray = subBetaArray(:,1:10,:);
for subject = 1:size(subBetaArray,3); % loop subjects
    for r = 1:size(subBetaArray,2); % loop task
        for c = 1:size(subBetaArray,2); % loop task
Task_Cor_Mat(subject,r,c) = corr(subBetaArray(y,r,subject),subBetaArray(y,c,subject),'type', 'Spearman');
        end
    end
end