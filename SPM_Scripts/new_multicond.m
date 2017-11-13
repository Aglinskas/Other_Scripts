%% Parameters to specify
loadMR;
fn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/wS%d_Results.mat.mat';
ofn = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/';

which_subs = [23]
for subID = which_subs; % one by one
%%
trial_dur = 2.5; %Trial duration
TR = 2.5;
unique_tasks = 12; % how many unique task are there in the experiment
face_control_task = [11 12 13];
momument_control_task = [14 15 16];
%%
load(sprintf(fn,subID,subID))
disp(['loaded ' sprintf(fn,subID,subID)])
%% Fixes Control task coding
if max([myTrials.blockNum]) > unique_tasks
 [myTrials(ismember([myTrials.blockNum],face_control_task)).blockNum] = deal(11);
 [myTrials(ismember([myTrials.blockNum],momument_control_task)).blockNum] = deal(12);
end
%% add TR
for i = 1:length(myTrials)
    myTrials(i).TR = floor((myTrials(i).time_presented / TR));
end
%% Drop Unknown ppl
    e_inds = find(cellfun(@isempty,{myTrials.resp}'));
    [myTrials(e_inds).RT] = deal(NaN);
    [myTrials(e_inds).resp] = deal(NaN);
u_inds = [myTrials.blockNum] == 8 & [myTrials.resp] == 4;
u_inds = find(u_inds);
% 8 ocupation, 5 familiarity
tempa = cellfun(@(x) strsplit(x,'/'),{myTrials.filepath}','UniformOutput',0);
tempb = cellfun(@(x) x{2},tempa,'UniformOutput',0);
myTrials(1).name = 0;
[myTrials.name] = deal(tempb{:});
ut_inds = find(ismember({myTrials.name}',{myTrials(u_inds).name}'));
ut_inds([myTrials(ut_inds).blockNum]' > 10) = [];
myTrials(ut_inds) = [];
disp([num2str(length(u_inds)) ' People Dropped'])
%% multiconds
%for r = 1:max([myTrials.fmriRun]);
 for r = 1:myTrials(length([myTrials.time_presented])).fmriRun;
    names = num2cell(unique([myTrials(find([myTrials.fmriRun] == r)).blockNum]));
    names = arrayfun(@num2str,[names{:}],'UniformOutput',0);
    for b = unique([myTrials(find([myTrials.fmriRun] == r)).blockNum]);
onsets{b} = [myTrials(find([myTrials.blockNum] == b & [myTrials.fmriRun] == r)).time_presented];
durations{b} = trial_dur;
    end
  save([sprintf(ofn,subID) 'sub' num2str(subID) 'run' num2str(r) '_multicondFAM'],'durations','onsets','names');
end
%%
%n_sess = myTrials(length([myTrials.time_presented])).fmriRun
end % ends subID loop