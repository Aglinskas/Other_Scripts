dr = '/Users/aidas_el_cap/Desktop/BehaviouralPilot/' % where the files are stored
subID = 1
%% the script should be able to take over from here
%dir_names & filenames
sub_str = num2str(subID,'%02i');
fln = ['New_Pilot_subject_test_S' sub_str];%what the files are called
first_run = '_Results_SLF_PACE.mat';
second_run = '_Results_2run.mat';
ext = {first_run second_run}
Tasks_eng = {'Hair_Color' 'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive_Emotions' 'Familiarity' 'How_much_write' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Integrity' 'Same_Face' 'Same_monument'};
%% Build the frankenstein myTrials struct
load(fullfile(dr,['S' sub_str],[fln first_run]))
myTrials_F = myTrials;
[myTrials_F([1:length(myTrials_F)]).portion] = deal('First half')
clear myTrials
load(fullfile(dr,['S' sub_str],[fln second_run]))
myTrials_S = myTrials;
[myTrials_S([1:length(myTrials_S)]).portion] = deal('Second half')
clear myTrials
myTrials = [myTrials_F myTrials_S]
%% get unique
unfc = unique({myTrials(find(isempty([myTrials.response]) == 0 & [myTrials.task_number] ~= 15)).name});
unfc = unfc';
fc = struct;
[fc([1:length(unfc)]).name] = deal(unfc(:));
%%
for i = 1:length(myTrials)
    if isempty(myTrials(i).response)
        myTrials(i).response = 0
    end
end
%%
for f = 1:length(fc)
    for t = 1:13
        if isempty(find(strcmp({myTrials.name},fc(f).name) & [myTrials.task_number] == t))
            fc(f).(Tasks_eng{t}) = nan
        else
fc(f).(Tasks_eng{t}) = [myTrials(find(strcmp({myTrials.name},fc(f).name) & [myTrials.task_number] == t)).response]
if length(fc(f).(Tasks_eng{t})) == 2 && fc(f).(Tasks_eng{t})(1) == fc(f).(Tasks_eng{t})(2)
    fc(f).(Tasks_eng{t}) = fc(f).(Tasks_eng{t})(1)
end
        end
    end
end


