
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