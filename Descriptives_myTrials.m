
% S2 = /Volumes/Aidas_HDD/MRI_data/S2/S2 MyTrials.mat
% S3 = /Volumes/Aidas_HDD/MRI_data/S3/S3_Results.mat
n_runs = myTrials(length([myTrials.time_presented])).fmriRun;
for i = 1 : n_runs;
RTs{:,i} = [myTrials(find([myTrials.fmriRun] == i)).RT];
perRun{1,1} = 'Median';
perRun{1+i,1} = median(RTs{i});
perRun{1,2} = 'max';
perRun{1+i,2} = max(RTs{i});
perRun{1,3} = 'min';
perRun{1+i,3} = min(RTs{i});
perRun{1,4} = 'std';
perRun{1+i,4} = std(RTs{i});

% md(i) = median(RTs{i});
% mx(i) = max(RTs{i});
% mn(i) = min(RTs{i});
for o = 1:15;
   inx = find([myTrials.blockNum] == o & [myTrials.fmriRun] == i);
   perBlock{1,1} = 'Run/Task';
   perBlock{o+1 + (i-1) * 15,1} = ['Run ' num2str(i) ' Task ' num2str(o)];
   perBlock{1,2} = 'Mean RT';
   perBlock{o+1 + (i-1) * 15,2} = mean([myTrials(inx).RT]);
   perBlock{1,3} = 'Median RT';
   perBlock{o+1 + (i-1) * 15,3} = median([myTrials(inx).RT]);
   perBlock{1,4} = 'Min';
   perBlock{o+1 + (i-1) * 15,4} = min([myTrials(inx).RT]);
   perBlock{1,5} = 'Max';
   perBlock{o+1 + (i-1) * 15,5} = max([myTrials(inx).RT]);
   perBlock{1,6} = 'Max';
   perBlock{o+1 + (i-1) * 15,6} = max([myTrials(inx).RT]);
end
end

for o = 1:15;
   inx = find([myTrials.blockNum] == o);
   perTask{1,1} = 'Run/Task';
   perTask{o+1,1} = [' Task ' num2str(o)];
   perTask{1,2} = 'Mean RT';
   perTask{o+1,2} = mean([myTrials(inx).RT]);
   perTask{1,3} = 'Median RT';
   perTask{o+1,3} = median([myTrials(inx).RT]);
   perTask{1,4} = 'Min';
   perTask{o+1,4} = min([myTrials(inx).RT]);
   perTask{1,5} = 'Max';
   perTask{o+1,5} = max([myTrials(inx).RT]);
   perTask{1,6} = 'std';
   perTask{o+1,6} = std([myTrials(inx).RT]);
end

%% add names
for i = 1 : length([myTrials]);
   a = strsplit(myTrials(i).filepath, '/');
    myTrials(i).name = a{2};
    myTrials(i).stimKind = a{1};
end

for i = 1 : length(myTrials);
if strmatch(myTrials(i).stimKind,'People'); %myTrials(i).stimKind == 'People'
    c{i} = myTrials(i).name;
end
end

load('people');

indp = [];
for p = 1: length(people);
for l = 1:length(myTrials);
        if strmatch(myTrials(l).name,people{p});
            indp(length(indp) + 1) = l;
        end
end
RT_byName{p,1} = people{p};
RT_byName{p,2} = median([myTrials(indp).RT]);
RT_byName{p,3} = mean([myTrials(indp).RT]);
RT_byName{p,4} = std([myTrials(indp).RT]);
RT_byName{p,5} = std([myTrials(indp).RT]) / sqrt(length(indp));
RT_byName{p,6} = min([myTrials(indp).RT]);
RT_byName{p,7} = max([myTrials(indp).RT]);
indp = [];
end

%% How many ppl they know

for i = 1 : length(myTrials);
if isempty(myTrials(i).resp);
myTrials(i).resp = 0;;
end
end %replace zeros

find([myTrials.blockNum] == 7 & [myTrials.resp] == 1);
y = find([myTrials.blockNum] == 7 & [myTrials.resp] == 1);
n = find([myTrials.blockNum] == 7 & [myTrials.resp] == 2);

known = length(y);
unknown = length(n);

recognized = {};
for i = 1 : length(y);
    recognized{length(recognized) + 1} = myTrials(y(i)).name;
end
recognized = recognized';

unrecognized = {};
for i = 1 : length(n);
    unrecognized{length(unrecognized) + 1} = myTrials(n(i)).name;
end
unrecognized = unrecognized';


%% responses per task
for i = 1 : length(myTrials);
if isempty(myTrials(i).resp);
myTrials(i).resp = 0;;
end
end %replace zeros

responses = {};
for i = 1 : 15
responses{i,1} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 1));
responses{i,2} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 2));
responses{i,3} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 3));
responses{i,4} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 4));
responses{i,5} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 0));
end    
    
    
    
   

% md
% mx
% mn


%[H,P,CI,STATS] = ttest2(x,y) H=1 rejected null