%load people list
%cd '/Users/aidas_el_cap/Desktop/Other_Scripts'
load('/Users/aidas_el_cap/Desktop/Other_Scripts/people.mat')
load('/Users/aidas_el_cap/Desktop/Other_Scripts/block_order.mat') 
myTrials_dir = '/Users/aidas_el_cap/Desktop/Summaries & Results/Recognition/myTrials_behav/'
init = 1
subject = 1:7
for s = subject

myTrials_fn = sprintf('participant%d_Results.mat',s)
load(fullfile(myTrials_dir, myTrials_fn))

if s == 2
    init = 0
end


%% fix block numbers
[myTrials.blockNum] = deal(0);
ord = b_order(:,s);
for k = 1:14
    [myTrials(k*40-40+1:k*40).blockNum] = deal(ord(k))
end

%% add names
for i = 1 : length([myTrials]);
   a = strsplit(myTrials(i).filenames, '/');
    myTrials(i).name = a{7};
    myTrials(i).stimKind = a{1};
end
% %replace zeros
% for i = 1 : length(myTrials);
% if isempty(myTrials(i).response);
% myTrials(i).response = 0;;
% end
% end

%% fix responses
for i = 1 : length(myTrials);
   if strmatch(myTrials(i).response,'1!');
       myTrials(i).response = 1;
   elseif strmatch(myTrials(i).response,'2@');
       myTrials(i).response = 2;
   elseif strmatch(myTrials(i).response,'3#');
       myTrials(i).response = 3;
   elseif strmatch(myTrials(i).response,'4$');
       myTrials(i).response = 4;
   end
end

%% variables
recognize = 7
how_old = 2
essay = 8
com_name = 9
how_mFacts = 10
wh_do = 11


%% add r.struct
if init == 1
    %fill names
for i = 1 : length(people)
    r(i).name = people{i}
end
[r.recognize] = deal(0)
    [r.wh_do] = deal(0)
    [r.how_old]= deal(0)
    [r.essay]= deal(0)
    [r.com_name]= deal(0)
    [r.how_mFacts]= deal(0)
end

%% The master loop
for i = 1 : length(myTrials)
if myTrials(i).blockNum == recognize && myTrials(i).response == 1
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).recognize = r(l).recognize + 1
          end
       end
end

if myTrials(i).blockNum == wh_do && myTrials(i).response ~= 4 %&& myTrials(i).response ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).wh_do = r(l).wh_do + 1
          end
       end
end

if myTrials(i).blockNum == how_old && myTrials(i).response ~= 4% && myTrials(i).response ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).how_old = r(l).how_old + 1
          end
       end
end

if myTrials(i).blockNum == essay && myTrials(i).response ~= 4 %&& myTrials(i).response ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).essay = r(l).essay + 1
          end
       end
end

if myTrials(i).blockNum == com_name && myTrials(i).response ~= 4 %&& myTrials(i).response ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).com_name = r(l).com_name + 1
          end
       end
end

if myTrials(i).blockNum == how_mFacts && myTrials(i).response ~= 4 %&& myTrials(i).response ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).how_mFacts = r(l).how_mFacts + 1
          end
       end
end
end
end % ends subjects loop
  %%
    