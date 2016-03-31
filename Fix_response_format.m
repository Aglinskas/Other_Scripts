dr = '/Users/aidas_el_cap/Desktop/BehaviouralPilot/' % where the files are stored
for subID = 1:12
%% the script should be able to take over from here
%dir_names & filenames
sub_str = num2str(subID,'%02i');
fln = ['New_Pilot_subject_test_S' sub_str ];%what the files are called
first_run = '_Results_SLF_PACE.mat';
second_run = '_Results_2run.mat';
ext = {first_run second_run};
%Tasks_eng = {'Hair_Color' 'First_memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Positive_Emotions' 'Familiarity' 'How_much_write' 'Common_name' 'How_many_facts' 'Occupation' 'Distinctiveness_of_face' 'Integrity' 'Same_Face' 'Same_monument'};
%%
for p = 1:2
load(fullfile(dr,['S' sub_str],[fln ext{p}]));
%%


for i = 1: length(myTrials)
if iscell(myTrials(i).response)
    if isstr(myTrials(i).response{1})
        if length(myTrials(i).response{1}) == 2
            try
                myTrials(i).response = str2num(myTrials(i).response{1}(1));
            catch
            end
        end
    end
end
save(fullfile(dr,['S' sub_str],[fln ext{p}]),'myTrials');
end

if isfield(myTrials, 'Name') == 0;
for i = 1: length(myTrials)
a = strsplit(myTrials(i).filepath,'/');
if length(a) > 2
myTrials(i).name = a{2};
%else myTrials(i).name = nan
end
end
save(fullfile(dr,['S' sub_str],[fln ext{p}]),'myTrials');
end
end
end


    





