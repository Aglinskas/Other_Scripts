%load people list
load('/Users/aidas_el_cap/Desktop/Other_Scripts/people.mat')
init = 1
%% add names
for i = 1 : length([myTrials]);
   a = strsplit(myTrials(i).filenames, '/');
    myTrials(i).name = a{7};
    %myTrials(i).stimKind = a{1};
end
%% replace zeros
% for i = 1 : length(myTrials);
% if isempty(myTrials(i).response);
% % % myTrials(i).response = 0;;
% % % end
% % % end

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

recognize = 7;
how_old = 2;
essay = 8;
com_name = 9;
how_mFacts = 10;
wh_do = 11;

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
%% Fixes blockNum, defuncted. fuck Matlab
% 
% Task{1,1} = 'Di che colore sono i capelli di questa persona?' %Control or baseline
% Task{2,1} = 'Quanti anni avevi quando hai sentito parlare di questa persona per la prima volta?' %episodic
% Task{3,1} = 'Quanto ritieni sia fisicamente attraente questa persona?'
% Task{4,1} = 'Quanto ritieni sia amichevole questa persona?'
% Task{5,1} = 'Quanto ritieni sia affidabile questa persona?'
% Task{6,1} = 'Associ questa persona ad emozioni pi? positive o pi? negative?'
% Task{7,1} = 'Hai mai visto questa persona prima?/Riconosci il suo volto?' % semantic access 1
% Task{8,1} = 'Se ti chiedessero di scrivere un tema su questa persona, quanto potresti scrivere?'%semantic access
% Task{9,1} = 'Quanto ? comune il nome proprio di questa persona?'
% Task{10,1} = 'Quanti fatti riesci a ricordare di questa persona?'
% Task{11,1} = 'Chi ? questa persona?'
% Task{12,1} = 'Quanto ? distintivo e distinguibile il volto di questa persona?'
% Task{13,1} = 'Considerate tutte le informazioni a tua disposizione\n(se conosci o meno questa persona);\nQuanto ritieni sia brava o cattiva questa persona?'
% Task{14,1} = 'E? lo stesso volto rispetto al precedente?' %control
% Task{15,1} = 'E? lo stesso monumento rispetto al precedente?'
% 
% 
% 
% [myTrials.blockNum] = deal(0)
% for i = 1:length(myTrials)
% for t = 1:length(Task)    
% if strcmp(myTrials(i).TaskName,Task{t})
%     myTrials(i).blockNum = t
%     disp('yes')
% end
% end
% end
% 
% if isempty(find([myTrials.blockNum] == 0))
%     disp('All Tasks fixed')
% else disp('NOT ALL TASKS FIXED')
% end


%% REALLY fixes the blockNum
l = length(myTrials) / max([myTrials.trialnum])
for i = 1: l
order{i} = myTrials(i*40 - 1).TaskName
end
l
order'



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

if isempty(find([myTrials.blockNum] == 0))
    disp('All Tasks fixed')
else disp('NOT ALL TASKS FIXED')
end
%%
