loadMR
%%
ofn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/sub%drun%d_multicond_all_faces.mat'
for subID = subvect(1) %(2:end)
for frun = 1:5
durations ={};names = {};onsets = {};
% subID, frun, cogntive tasks
this_mt = all_trials(find([all_trials.subID] == subID & [all_trials.fmriRun] == frun & ismember([all_trials.blockNum],[1:10])));
%this_mt(find([this_mt.time_presented]' > 500)) = [];


for l = 1:length(this_mt)-1
        names{l} = [this_mt(l).name num2str(this_mt(l).blockNum)];
        onsets{l} = this_mt(l).time_presented;
        durations{l} = 2.5;
end
ofn = sprintf(ofn_temp,subID,subID,frun);
save(ofn,'names','onsets','durations')
end
end
disp('done')
%%
