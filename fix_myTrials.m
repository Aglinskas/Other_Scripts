fn = '/Volumes/Aidas_HDD/MRI_data/S%d/S%d_Results%s.mat';
% ^myTrials fn, with '%d' where subID should go
ofn = '/Users/aidas_el_cap/Desktop/myTrials/Fixed/S%d_results_fixed'
% ^output directory fn, with '%d' where subID should go
subvect = [7 8 9 10 11 14 15 17 18 19 20 21 22]
for subID = subvect
%%
trial_dur = 2.5; %Trial duration
%TR = 2.5;
unique_tasks = 12; % how many unique task are there in the experiment
face_control_task = [11 12 13];
momument_control_task = [14 15 16];
tasks_eng = {'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Full name' 'Same_Face' 'Same_monument'};
%%
load(sprintf(fn,subID,subID))
disp(['loaded ' sprintf(fn,subID,subID)])
%% Fixes Control task coding
if max([myTrials.blockNum]) > unique_tasks
 [myTrials(ismember([myTrials.blockNum],face_control_task)).blockNum] = deal(11);
 [myTrials(ismember([myTrials.blockNum],momument_control_task)).blockNum] = deal(12);
end
% %% Add TR
% for i = 1:length(myTrials)
%     myTrials(i).TR = floor((myTrials(i).time_presented / TR));
% end
%% Fix resps
for i = 1: length(myTrials);
if iscell(myTrials(i).resp);
    if isstr(myTrials(i).resp{1});
        if length(myTrials(i).resp{1}) == 2;
            try
                myTrials(i).resp = str2num(myTrials(i).resp{1}(1));
            catch
            end
        end
    end
end
%save(fullfile(dr,['S' sub_str],[fln ext{p}]),'myTrials');
end



%% Add Name
if isfield(myTrials, 'Name') == 0;
for i = 1: length(myTrials);
a = strsplit(myTrials(i).filepath,'/');
if length(a) > 2
myTrials(i).name = a{2};
myTrials(i).face = 1;
myTrials(i).monument = 0;
elseif length(a) == 2
a = strsplit(myTrials(i).filepath,{'/' '.' 'copy' 'jpg'});
myTrials(i).name = a{2};
myTrials(i).face = 0;
myTrials(i).name_ID = 0;
myTrials(i).monument = 1;
end

%% Add english task names
[myTrials(1:end).t_eng] = deal(tasks_eng{[myTrials(1:end).blockNum]});
end
%% Skipped responses == 0
for i = 1 : length(myTrials);
if isempty(myTrials(i).resp);
myTrials(i).resp = 0;
end
end
%%
%save(fullfile(dr,['S' sub_str],[fln ext{p}]),'myTrials');
end
%% Name ID
f = unique({myTrials([myTrials.face] == 1).name})';
f_ID = num2cell(1:length(f))';
[unique_faces(1:length(f)).face] = deal(f{:});
[unique_faces(1:length(f)).face_ID] = deal(f_ID{:});
for i = 1:length(myTrials)
if myTrials(i).face == 1
    %%
a = strfind(f,myTrials(i).name);
[a{cellfun(@isempty,a,'UniformOutput',true)}] = deal(0);
a = cell2mat(a);
myTrials(i).name_ID = find(a == 1);
%%
end
end
save(sprintf(fn,subID,subID,'_fixed'),'myTrials');
end
disp('All fixed')