loadMR
%%
arr = subBeta.array;
%^ arr(ROI,Task,Subject)
% size(arr) = [18 12 20]
arr = arr - arr(:,11,:); %subtract face response
arr = arr(:,1:10,:); % trim to 10 cognitive tasks
arr = zscore(arr,[],2); %Zscore across tasks

w_m = {[1] [2 3]  [4 5]  [6 7] [8 9]  [10 11] [12 13] [14] [15 16] [17 18]}
lbls = {'Precuneus'    'Angular'    'OFA'    'FFA'    'IFG'    'ATL' 'Amygdala'    'PFCmedial'    'Orb'    'Face Patch'}'
hem_avg = [];
for i = 1:length(w_m)
hem_avg(i,:,:) = mean(arr(w_m{i},:,:),1);
end
disp('done')
size(hem_avg)
%
%hem_avg(ROI,TASK,SUBJECT)
for s = 1:20
keep(:,:,s) = corr(hem_avg(:,:,s)');
end
keep = mean(keep,3)

f = figure(1)
newVec = get_triu(keep);
Z = linkage(1-newVec,'ward');
%
[h x perm] = dendrogram(Z,'labels',lbls,'orientation','left')
[h(1:end).LineWidth] = deal(3);
f.CurrentAxes.FontSize = 14;
f.CurrentAxes.FontWeight = 'bold'
%saveas(f,[ofn datestr(datetime)],'png')


%%

h.about = sprintf('array(ROI,TASK,SUBJECT)\nZscored across tasks')
h.keepROI = h.keep

h = rmfield(h,'indexing')
hem_avg  = h
save('/Users/aidasaglinskas/Google Drive/Mat_files/Betas_Hemisphere_averaged.mat','hem_avg')
