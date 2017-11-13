function individual_faces_multicond(subID)
mt_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/wS%d_Results.mat';
ofn_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/sub%drun%d_multicond_IND_F.mat';
%subID = 29;
mt_fn = sprintf(mt_temp,subID,subID);
load(mt_fn);

% add face info
unique_face = unique({myTrials([myTrials.StimType]==1).word}');
temp.a = cellfun(@(x) find(ismember(unique_face,x)),{myTrials.word}','UniformOutput',0);
[myTrials.personID] = deal(temp.a{:});
% personID not neccecary for nback
[myTrials([myTrials.blockNum] > 10 & [myTrials.blockNum] < 14).personID] = deal([]);
% add 0 for personID for control tasks
[myTrials(cellfun(@isempty,{myTrials.personID})).personID] = deal(0);
% fix n backs 

if max([myTrials.blockNum])==16
inds_mon = [myTrials.blockNum] > 13;
inds_face = [myTrials.blockNum] > 10 & [myTrials.blockNum] < 14;
[myTrials(inds_mon).blockNum] = deal(12);
[myTrials(inds_face).blockNum] = deal(11);
end
%
for run_ind = 1:5 
onsets = {};names = {};durations = {};
for f_ind = 1:40
inds = find([myTrials.personID] == f_ind & [myTrials.fmriRun] == run_ind);
%{myTrials(inds(1))}'
%disp(length(inds));
l = 0;
for i = 1:length(inds);
l = l+1;
onsets{f_ind}(l) = myTrials(inds(i)).time_presented;
names{f_ind} = myTrials(inds(1)).word;
durations{f_ind} = 2.5;
end
end

onsets{41} = [myTrials([myTrials.blockNum] == 11 & [myTrials.fmriRun] == run_ind).time_presented];
names{41} = 'Face n-back';
durations{41} = 2.5;

onsets{42} = [myTrials([myTrials.blockNum] == 12 & [myTrials.fmriRun] == run_ind).time_presented];
names{42} = 'Monument n-back';
durations{42} = 2.5;
e_inds = find(cellfun(@isempty,onsets));
onsets(e_inds) = [];
names(e_inds) = [];
durations(e_inds) = [];
ofn = sprintf(ofn_temp,subID,subID,run_ind);
save(ofn,'onsets','names','durations');
end