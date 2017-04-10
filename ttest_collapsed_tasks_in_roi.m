loadMR
%%
arr = subBeta.array;
%^ Raw subject beta array ()
%arr(ROI,Task,subject)
% Size arr = 18 by 12 by 20
arr = arr - arr(:,11,:); %subtract face response
arr = arr(:,1:10,:); % trim to 10 cognitive tasks
arr = zscore(arr,[],1); %Zscore across tasks

nominal_physical_inds = [6 10]; %index of nominal and physical tasks
soc_ep_fact_inds = [3 4] % indexes of social episodic 

roi_ind = 1 % precuneus

v1 = arr(roi_ind,nominal_physical_inds,:);
v1 = squeeze(mean(v1,2));

v2 = arr(roi_ind,soc_ep_fact_inds,:);
v2 = squeeze(mean(v2,2));

[H,P,CI,STATS] = ttest(v2,v1);
STATS.tstat
P

%%

arr = subBeta.array;
%^ Raw subject beta array ()
%arr(ROI,Task,subject)
% Size arr = 18 by 12 by 20
arr = arr - arr(:,11,:); %subtract face response
arr = arr(:,1:10,:); % trim to 10 cognitive tasks
arr = zscore(arr,[],1); %Zscore across tasks
pairs = {[6 10]  [2 9] [3 4]  [1 5]  [7 8] };
pairs_lbls = {'Nominal' 'Physical' 'Social' 'Episodic'  'Factual'};
%%
for t1 = 1:5
    for t2 = 1:5
        
task1 = pairs{t1}; %index of nominal and physical tasks
task2 = pairs{t2}% indexes of social episodic 

roi_ind = 4 % precuneus

v1 = arr(roi_ind,task1,:);
v1 = squeeze(mean(v1,2));

v2 = arr(roi_ind,task2,:);
v2 = squeeze(mean(v2,2));

[H,P,CI,STATS] = ttest(v2,v1);
STATS.tstat
P

tmatrix(t1,t2) = abs(STATS.tstat)
    end
end

f = figure(1)
add_numbers_to_mat(tmatrix,pairs_lbls)
title(r_labels{roi_ind},'FontSize',20)
f.CurrentAxes.FontSize = 16
f.CurrentAxes.FontWeight = 'bold'
ofn = '/Users/aidasaglinskas/Desktop/lol_betas/';
saveas(f,[ofn datestr(datetime)],'png')