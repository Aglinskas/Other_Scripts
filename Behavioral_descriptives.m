
% for i = 1 : length(myTrials);
% if isempty(myTrials(i).resp);
% myTrials(i).resp = 0;;
% end
% end %replace zeros
% 
% find([myTrials.blockNum] == 7 & [myTrials.resp] == 1);
% y = find([myTrials.blockNum] == 7 & [myTrials.resp] == 1);
% n = find([myTrials.blockNum] == 7 & [myTrials.resp] == 2);
% 
% known = length(y);
% unknown = length(n);
% 
% recognized = {};
% for i = 1 : length(y);
%     recognized{length(recognized) + 1} = myTrials(y(i)).name;
% end
% recognized = recognized';
% 
% unrecognized = {};
% for i = 1 : length(n);
%     unrecognized{length(unrecognized) + 1} = myTrials(n(i)).name;
% end
% unrecognized = unrecognized';
% 
% 
% %% responses per task
% for i = 1 : length(myTrials);
% if isempty(myTrials(i).resp);
% myTrials(i).resp = 0;;
% end
% end %replace zeros
% 
% responses = {};
% for i = 1 : 15
% responses{i,1} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 1));
% responses{i,2} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 2));
% responses{i,3} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 3));
% responses{i,4} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 4));
% responses{i,5} = length(find([myTrials.blockNum] == i & [myTrials.resp] == 0));
% end    


% %% How many PPL recognized
% 
% % for i = 1 : length(myTrials);
% % if isempty(myTrials(i).resp);
% % myTrials(i).resp = 0;;
% % end
% % end %replace zeros
% 
% %find([myTrials.blockNum] == 7 & [myTrials.resp] == 1);
% find([myTrials.blockNum] == 7 & [myTrials.response] == 1);
% y = find([myTrials.blockNum] == 7 & [myTrials.resp] == 1);
% n = find([myTrials.blockNum] == 7 & [myTrials.resp] == 2);
% 
% known = length(y);
% unknown = length(n);
% 
% recognized = {};
% for i = 1 : length(y);
%     recognized{length(recognized) + 1} = myTrials(y(i)).name;
% end
% recognized = recognized';
% 
% unrecognized = {};
% for i = 1 : length(n);
%     unrecognized{length(unrecognized) + 1} = myTrials(n(i)).name;
% end
% unrecognized = unrecognized';
%%
subject = 7
r_task = 2 % which one is the recognition task

%correct the 1! 2@ 3# 4$ weirdness
for i = 1 : length(myTrials)
   if strmatch(myTrials(i).response,'1!')
       myTrials(i).response = 1
   elseif strmatch(myTrials(i).response,'2@')
       myTrials(i).response = 2
   elseif strmatch(myTrials(i).response,'3#')
       myTrials(i).response = 3
   elseif strmatch(myTrials(i).response,'4$')
       myTrials(i).response = 4
   end
end
     
%% add names
for i = 1 : length([myTrials]);
   a = strsplit(myTrials(i).filenames, '/');
    myTrials(i).name = a{7};
    myTrials(i).stimKind = a{1};
end

for i = 1 : length(myTrials);
if strmatch(myTrials(i).stimKind,'People'); %myTrials(i).stimKind == 'People'
    c{i} = myTrials(i).name;
end
end
    


y = find([myTrials.blockNum] == r_task & [myTrials.response] == 1);

n = find([myTrials.blockNum] == r_task & [myTrials.response] == 2);

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


[known unknown]

all_recognized{:,subject} = recognized
all_not_recognized{:,subject} = unrecognized
allknown(1,subject) = known
allknown(2,subject) = unknown







%% Recognition

for i = 1 : length(list1)
    list1{i}
   for c = 1:7
       all_recognized{c}
    for r = 1 : length(all_recognized{c})
if strmatch(list1{i},all_recognized{c}{r})
list2{i,c+1} = 1
end
    end
   end
end

for i = 1:length(final_list)
for c = 1:4
    for r = 1 : length(match_list{c})
        
if strmatch(final_list{i},match_list{c}{r})
final_list{i,c+2} = 1

end
end
end
end

%% New descriptives by face

load('/Users/aidas_el_cap/Documents/MATLAB/x_Mat_Storage/people.mat')
Task7 = 2

for i = 1 : length(people)
    r(i).name = people{i}
end

for t = 1 : length(myTrials)
strcmp(myTrials(i).TaskName, )







%%