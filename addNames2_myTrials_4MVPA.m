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

 myTrials(1).name_ID =[]
 
for i = 1 : length(myTrials)
    for l = 1: length(people)
    if strcmp(myTrials(i).name, people{l})
        myTrials(i).name_ID = l
    elseif strcmp(myTrials(i).stimKind, 'Monuments')
         myTrials(i).name_ID = 0
    end
    end
end

save('S6_Results.mat','myTrials')