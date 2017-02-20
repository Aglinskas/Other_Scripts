clear all
loadMR
subID = 7
names_list = names;

ofn = '/Users/aidasaglinskas/Google Drive/Data/S%d/sub%drun%d_multicond_all_faces.mat'
%
this_mt = all_trials(find([all_trials.subID] == subID));


%disp('Running')
for frun = 1:5%:5
durations = {};
names = {};
onsets = {};
 disp(sprintf('Run %d',frun))
for f = 1:length(names_list)
for b = 1:10
    r = find([this_mt.blockNum] == b & cellfun(@(x) strcmp(x,names_list{f}),{this_mt.name}) & [this_mt.fmriRun] == frun);

names{end+1} = [names_list{f} ',task-' num2str(b)];
    if isempty(r)
        onsets{end+1} = [];
        durations{end+1} = [];
    else 
        onsets{end+1} = this_mt(r).time_presented;
        durations{end+1} = 2.5;
    end
end
end

f_ofn = sprintf(ofn,subID,subID,frun);
save(f_ofn,'durations','onsets','names')
end
disp('done')

%length(find(cellfun(@isempty,onsets) == 0))