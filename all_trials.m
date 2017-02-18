fn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/S%d_ScannerMyTrials_RBLT.mat';
%% Get All Trials
rebuild_or_load = 2 %1 for rebuild, 2 for load;
all_trials = [];
disp('Collecting all_trials')
for subID = subBeta.subvect
%
load(sprintf(fn_temp,subID,subID));
[myTrials(1:end).subID] = deal(subID);
try;myTrials = rmfield(myTrials,'TR'); catch;end
disp(sprintf('Loaded Subject %d Data',subID))
if isempty(all_trials)
    all_trials = myTrials;
else
    all_trials = [all_trials myTrials];
end
    %disp(size(all_trials))
end
disp('done')
%% Tag Skipped
skipped_answers = find(cellfun(@isempty,{all_trials.resp}'));
[all_trials(skipped_answers).resp] = deal(NaN)
[all_trials(skipped_answers).RT] = deal(NaN)