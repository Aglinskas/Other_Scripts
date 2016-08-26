
% S2 = /Volumes/Aidas_HDD/MRI_data/S2/S2 MyTrials.mat
% S3 = /Volumes/Aidas_HDD/MRI_data/S3/S3_Results.mat
n_runs = myTrials(length([myTrials.time_presented])).fmriRun
for i = 1 : n_runs
RTs{:,i} = [myTrials(find([myTrials.fmriRun] == i)).RT];
perRun{1,1} = 'Median'
perRun{1+i,1} = median(RTs{i});
perRun{1,2} = 'max'
perRun{1+i,2} = max(RTs{i});
perRun{1,3} = 'min'
perRun{1+i,3} = min(RTs{i});

% md(i) = median(RTs{i});
% mx(i) = max(RTs{i});
% mn(i) = min(RTs{i});
for o = 1:15
   inx = find([myTrials.blockNum] == o & [myTrials.fmriRun] == i)
   perBlock{1,1} = 'Run/Task'
   perBlock{o+1 + (i-1) * 15,1} = ['Run ' num2str(i) ' Task ' num2str(o)]
   perBlock{1,2} = 'Mean RT'
   perBlock{o+1 + (i-1) * 15,2} = mean([myTrials(inx).RT])
   perBlock{1,3} = 'Median RT'
   perBlock{o+1 + (i-1) * 15,3} = median([myTrials(inx).RT])
   perBlock{1,4} = 'Min'
   perBlock{o+1 + (i-1) * 15,4} = min([myTrials(inx).RT])
   perBlock{1,5} = 'Max'
   perBlock{o+1 + (i-1) * 15,5} = max([myTrials(inx).RT])
end
end

for o = 1:15
   inx = find([myTrials.blockNum] == o)
   perTask{1,1} = 'Run/Task'
   perTask{o+1,1} = [' Task ' num2str(o)]
   perTask{1,2} = 'Mean RT'
   perTask{o+1,2} = mean([myTrials(inx).RT])
   perTask{1,3} = 'Median RT'
   perTask{o+1,3} = median([myTrials(inx).RT])
   perTask{1,4} = 'Min'
   perTask{o+1,4} = min([myTrials(inx).RT])
   perTask{1,5} = 'Max'
   perTask{o+1,5} = max([myTrials(inx).RT])
end



% md
% mx
% mn


%[H,P,CI,STATS] = ttest2(x,y) H=1 rejected null