loadMR
%subBetaArray(ROI,Task,SUBJECT)
%%

clear Task_Cor_Mat
y = [1:12 15 18] % which rois
%y = 1:18
subBetaArray = subBetaArray(:,1:10,:);
for subject = 1:size(subBetaArray,3); % loop subjects
    for r = 1:size(subBetaArray,2); % loop task
        for c = 1:size(subBetaArray,2); % loop task
Task_Cor_Mat(subject,r,c) = corr(subBetaArray(y,r,subject),subBetaArray(y,c,subject));
        end
    end
end

%%
a = squeeze(mean(Task_Cor_Mat,1)) % mean across subjects
add_numbers_to_mat(a,tasks) % imagesc + add numbers
title('Task Correlation across all ROIs')