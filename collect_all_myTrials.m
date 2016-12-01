%% Load file
clear all
loadMR
fn = '/Users/aidasaglinskas/Google Drive/Data/S%d/S%d_ScannerMyTrials_RBLT.mat';
for subID = subvect;
    disp(subID)
load(sprintf(fn,subID,subID))
% Fixes MyTrials
fix.e_c = find(cellfun(@isempty,{myTrials.RT}'));
[myTrials(fix.e_c).RT] = deal(nan);
[myTrials(fix.e_c).resp] = deal(nan);
if length(unique([myTrials.blockNum])) > 12
fix.fc_inds = find([myTrials.blockNum] == 11 | [myTrials.blockNum] == 12 | [myTrials.blockNum] == 13);
fix.mn_inds = find([myTrials.blockNum] == 14 | [myTrials.blockNum] == 15 | [myTrials.blockNum] == 16);
[myTrials(fix.fc_inds).blockNum] = deal(11);
[myTrials(fix.mn_inds).blockNum] = deal(12);end
myTrials(1).subID = subID;
[myTrials(1:end).subID] = deal(subID);

try
myTrials = rmfield(myTrials,'TR')
catch
end

if subID == 7
    all_myTrials = myTrials;
else
    all_myTrials = [all_myTrials myTrials];
end
end
save('/Users/aidasaglinskas/Google Drive/Mat_files/Other_mats/all_myTrials.mat','all_myTrials')
%%
