%% Parameters to specify
fn = '/Volumes/Aidas_HDD/29th_march/from scanner/March29_S0%d_Results.mat';
% ^myTrials fn, with '%d' where subID should go
ofn = '/Volumes/Aidas_HDD/MRI_data/29th_march/S%d/'
% ^output directory fn, with '%d' where subID should go
subID = 8
%%
trial_dur = 2.5; %Trial duration
TR = 2.5;
unique_tasks = 12; % how many unique task are there in the experiment
face_control_task = [11 12 13];
momument_control_task = [14 15 16];
%%
load(sprintf(fn,subID))
disp(['loaded ' sprintf(fn,subID)])
%% Fixes Control task coding
if max([myTrials.blockNum]) > unique_tasks
 [myTrials(ismember([myTrials.blockNum],face_control_task)).blockNum] = deal(11)
 [myTrials(ismember([myTrials.blockNum],momument_control_task)).blockNum] = deal(12)
end
%% add TR
for i = 1:length(myTrials)
    myTrials(i).TR = floor((myTrials(i).time_presented / TR))
    
end
%% multiconds
for r = 1:max([myTrials.fmriRun])
    names = num2cell(unique([myTrials(find([myTrials.fmriRun] == r)).blockNum]))
    for b = unique([myTrials(find([myTrials.fmriRun] == r)).blockNum])
onsets{names{b}} = [myTrials(find([myTrials.blockNum] == b & [myTrials.fmriRun] == r)).time_presented];
durations{names{b}} = trial_dur;
    end
  save([sprintf(ofn,subID) 'sub' num2str(subID) 'run' num2str(r) '_multicond'],'') 
end
%%




