dr = '/Users/aidas_el_cap/Desktop/BehaviouralPilot/' % where the files are stored
subID = 1
%% the script should be able to take over from here
%dir_names & filenames
sub_str = num2str(subID,'%02i');
fln = ['New_Pilot_subject_test_S' sub_str ];%what the files are called
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
fc_allsubs = struct;
[fc_allsubs([1:length({unfc{:}})]).face] = deal(unfc{:});
%% set up struct
%fc_allsubs = struct;
for i = 1:13
    fc_allsubs(2).(Tasks_eng{i}) = []
end
for t = 1:13
   for f = 1:length(fc)
    fc_allsubs(f).(Tasks_eng{t}) = [fc_allsubs(f).(Tasks_eng{t}) fc_allsubs(f).(Tasks_eng{t})]
   end
end
%% loop through participants








