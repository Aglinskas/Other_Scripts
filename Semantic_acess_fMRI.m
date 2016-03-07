%load people list

analysis = 1
% 1 = score correlation analysis
%2 = recognition analysis
myTrials_dir = '/Users/aidas_el_cap/Desktop/Summaries & Results/Recognition/myTrials_fmri/'
subject = [3]
myTrials_fn = sprintf('S%d_Results.mat',subject)
load(fullfile(myTrials_dir,myTrials_fn))
%%
load('/Users/aidas_el_cap/Desktop/Other_Scripts/people.mat')
init = 1
%% add names
for i = 1 : length([myTrials]);
   a = strsplit(myTrials(i).filepath, '/');
    myTrials(i).name = a{2};
    myTrials(i).stimKind = a{1};
end
%% replace zeros
for i = 1 : length(myTrials);
if isempty(myTrials(i).resp);
myTrials(i).resp = nan;
myTrials(i).RT = nan;
end
end

%% Recognition analysis
if analysis == 2
recognize = 7
how_old = 2
essay = 8
com_name = 9
how_mFacts = 10
wh_do = 11
% add r.struct
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

% The master loop
for i = 1 : length(myTrials)
if myTrials(i).blockNum == recognize && myTrials(i).resp == 1
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).recognize = r(l).recognize + 1
          end
       end
end

if myTrials(i).blockNum == wh_do && myTrials(i).resp ~= 4 %&& myTrials(i).resp ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).wh_do = r(l).wh_do + 1
          end
       end
end

if myTrials(i).blockNum == how_old && myTrials(i).resp ~= 4% && myTrials(i).resp ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).how_old = r(l).how_old + 1
          end
       end
end

if myTrials(i).blockNum == essay && myTrials(i).resp ~= 4 %&& myTrials(i).resp ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).essay = r(l).essay + 1
          end
       end
end

if myTrials(i).blockNum == com_name && myTrials(i).resp ~= 4 %&& myTrials(i).resp ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).com_name = r(l).com_name + 1
          end
       end
end

if myTrials(i).blockNum == how_mFacts && myTrials(i).resp ~= 4 %&& myTrials(i).resp ~= 0
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).how_mFacts = r(l).how_mFacts + 1
          end
       end
end
end
end

%% response correlation analysis
if analysis == 1
    [~,index] = sortrows({myTrials.name}.'); myTrials = myTrials(index); clear index
    [~,index] = sortrows([myTrials.blockNum].'); myTrials = myTrials(index); clear index
    






end