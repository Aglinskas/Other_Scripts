%% Parameters to specify
fn = '/Volumes/Aidas_HDD/MRI_data/S%d/S%d_Results.mat';
% ^myTrials fn, with '%d' where subID should go
ofn = '/Volumes/Aidas_HDD/MRI_data/S%d/'
% ^output directory fn, with '%d' where subID should go
for subID = [31]; % one by one
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
%% multiconds
%for r = 1:max([myTrials.fmriRun]);
 for r = 1:myTrials(length([myTrials.time_presented])).fmriRun;
    names = num2cell(unique([myTrials(find([myTrials.fmriRun] == r)).blockNum]));
    names = arrayfun(@num2str,[names{:}],'UniformOutput',0);
    for b = unique([myTrials(find([myTrials.fmriRun] == r)).blockNum]);
onsets{b} = [myTrials(find([myTrials.blockNum] == b & [myTrials.fmriRun] == r)).time_presented];
durations{b} = trial_dur;
    end
  save([sprintf(ofn,subID) 'sub' num2str(subID) 'run' num2str(r) '_multicond'],'durations','onsets','names');
end
%%
%n_sess = myTrials(length([myTrials.time_presented])).fmriRun
end % ends subID loop

