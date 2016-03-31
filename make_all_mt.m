addpath(genpath('/Users/aidas_el_cap/Documents/MATLAB/altmany-export_fig_f/'));
addpath(genpath('/Users/aidas_el_cap/Desktop/BehaviouralPilot/'))
for subID = 1:12
%Override = 0
dr = '/Users/aidas_el_cap/Desktop/BehaviouralPilot/'; % where the files are stored
%% the script should be able to take over from here
%dir_names & filenames
sub_str = num2str(subID,'%02i');
fln = ['New_Pilot_subject_test_S' sub_str ];%what the files are called
first_run = '_Results_SLF_PACE.mat';
second_run = '_Results_2run.mat';
ext = {first_run second_run};
Tasks_eng = {'Hair_Color' 'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive_Emotions' 'Familiarity' 'How_much_write' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Integrity' 'Same_Face' 'Same_monument'};
lbls = {'Hair Color' 'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive Emotions' 'Familiarity' 'How much write' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness of face' 'Integrity' 'Same Face' 'Same monument'};
%% self paced half
load(fullfile(dr,['S' sub_str],[fln first_run]));
[myTrials([1:length(myTrials)]).portion] = deal('First Half');
mtf = myTrials;
load(fullfile(dr,['S' sub_str],[fln second_run]));
[myTrials([1:length(myTrials)]).portion] = deal('Second Half');
mts = myTrials;
mt = [mtf mts];
all_mt{subID} = mt;
all_mt = all_mt' %fuck rows
end
disp('loaded all')
%% save?
sv = 0
if sv == 1
    save('/Users/aidas_el_cap/Desktop/BehaviouralPilot/all_mt.mat','all_mt')
    disp('saved; Overwritten if needed')
end