%% New descriptives by face
p_mt = '/Users/aidas_el_cap/Documents/MATLAB/x_Mat_Storage'
s = '/Users/aidas_el_cap/Desktop/Other_Scripts'
load('/Users/aidas_el_cap/Desktop/Other_Scripts/people.mat')
load('/Users/aidas_el_cap/Documents/MATLAB/x_Mat_Storage/participant1_Results.mat')

% how_old =     'Quanti anni avevi quando hai sentito parlare di questa persona per la prima volta?'
% recognize =     'Hai mai visto questa persona prima?/Riconosci il suo volto?'
% essay =     'Se ti chiedessero di scrivere un tema su questa persona, quanto potresti scrivere?'
% com_name =  'Quanto ? comune il nome proprio di questa persona?'
% how_mFacts =     'Quanti fatti riesci a ricordare di questa persona?'
% wh_do  = 'Chi ? questa persona?'

recognize = 7
how_old = 2
essay = 8
com_name = 9
how_mFacts = 10
wh_do = 11

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
 
for i = 1 : length(myTrials);
if isempty(myTrials(i).response);
myTrials(i).response = 0;;
end
end %replace zeros


%fill names
for i = 1 : length(people)
    r(i).name = people{i}
end

for t = 1 : length(myTrials)
if strcmp(myTrials(i).TaskName,recognize)
    
end
end


init = 1
if init == 1
    [r.recognize] = deal(0)
    [r.wh_do] = deal(0)
    [r.how_old]= deal(0)
    [r.essay]= deal(0)
    [r.com_name]= deal(0)
    [r.how_mFacts]= deal(0)
end
%%
%strcmp(myTrials(i).TaskName,recognize) && myTrials(i).response == 1
for i = 1 : length(myTrials)
    if strcmp(myTrials(i).TaskName,recognize) && myTrials(i).response == 1
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name) 
            r(l).recognize = r(l).recognize + 1
          end
       end
    end
        if strcmp(myTrials(i).TaskName,wh_do) && myTrials(i).response == 4
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name)
            r(l).wh_do = r(l).wh_do + 1
          end
       end
        end
        
            if strcmp(myTrials(i).TaskName,how_old) && myTrials(i).response == 4
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name)
            r(l).how_old = r(l).how_old + 1
          end
       end
            end
            if strcmp(myTrials(i).TaskName,essay) && myTrials(i).response == 4
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name)
            r(l).essay = r(l).essay + 1
            end
       end
            end
            if strcmp(myTrials(i).TaskName,how_mFacts) && myTrials(i).response == 4
       for l = 1: length(r)
          if strcmp(myTrials(i).name,r(l).name)
            r(l).how_mFacts = r(l).how_mFacts + 1
        	end
       end
            end
    end


