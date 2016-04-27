a = [9 10 11 15 16 17];
for subID = a;
fn = sprintf('/Users/aidas_el_cap/Desktop/00_fmri_pilot_final/S_%d_recog.mat',subID);
%dir('/Users/aidas_el_cap/Desktop/00_fmri_pilot_final/S_*');
load(fn)
if length(unique([recog.response]')) == 1 & [recog.response]' == 1
    disp([num2str(subID) ' All rec''ed'])
else
    disp(['Sub ' num2str(subID) ' didnt recognize the following faces:'])
    {recog(find([recog.response] == 2)).name}'
end
end
%% fmri myTrials
load('/Users/aidas_el_cap/Desktop/Tasks.mat')
a = [9 10 11 15 16 17];

for subID = a;
task = 5;
resp = 4;
fn = sprintf('/Users/aidas_el_cap/Desktop/myTrials/new/S%d_Results.mat',subID);
load(fn) % loaded
r = {myTrials([myTrials.blockNum] == task &[myTrials.resp] == resp).filepath};
r = cellfun(@(x) strsplit(x,'/'), r,'UniformOutput',false);

disp(['sub ' num2str(subID) ' responded ' num2str(resp) ' on task ' num2str(task) ' for these faces:'])
r = cellfun(@(x) x(2),r)'
end


%% Fix myTrials
% for subID = 9:17;
% fn = sprintf('/Users/aidas_el_cap/Desktop/myTrials/new/S%d_Results.mat',subID);
% load(fn)
% [myTrials(cellfun(@isempty,{myTrials.resp})).resp] = deal(0);
% [myTrials(cellfun(@isempty,{myTrials.RT})).RT] = deal(0);
% save(fn)
% end




