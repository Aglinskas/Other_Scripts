subID = 6
sess = 5
sub_dir = sprintf('/Volumes/Aidas_HDD/MRI_data/S%d',subID)
fn = fullfile(sub_dir, sprintf('multiple_cond_run%d.mat',sess))
mt = sprintf('/Users/aidas_el_cap/Desktop/Recognition/myTrials_fmri/S%d_Results.mat',subID)
load(mt)
find([myTrials.blockNum] == 8 & [myTrials.fmriRun] == sess)
% durations onsets names pmod
%% task 15,16,17 are task 15
for u = 1 : length([myTrials.blockNum]);
    if myTrials(u).blockNum == 16 | myTrials(u).blockNum == 17;
         myTrials(u).blockNum = 15;
    end
end
%% fix skipped responses
for i = 1 : length(myTrials)
if isempty(myTrials(i).resp)
 myTrials(i).resp = 0
end
end
%%
for t = 1 : 15
pmod(t).name = {['Task ' num2str(t) ' modulation']}
pmod(t).param = {[myTrials(find([myTrials.blockNum] == t & [myTrials.fmriRun] == sess)).resp]}
pmod(t).poly = {1}
end



save(fn,'pmod','-append')



