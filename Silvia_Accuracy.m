clear
load('/Users/aidasaglinskas/Downloads/mt.mat')
subID = 1;
% Preprocessing
myTrials([myTrials.cat] == 3) = []; %Drop category 3
to_deal = num2cell(round([myTrials.ISI]' * 100));
[myTrials.ISI] = deal(to_deal{:});
ISI_bins = unique([myTrials.ISI]);
score = zeros(subID,length(ISI_bins));
%
for ISI_counter_ID = 1:length(ISI_bins)
    ISI_counter = ISI_bins(ISI_counter_ID)
ISI_trials = find([myTrials.ISI] == ISI_counter);
%ntargets(ISI_counter_ID) = length(find([myTrials(ISI_trials).target]));

ntemp = cellfun(@sum,{myTrials(ISI_trials).target});
ntemp(ntemp==0) = 1;
ntargets(ISI_counter_ID) = sum(ntemp);
how_many_to_check = ceil(150 / ISI_counter);
    for ISI_trial = ISI_trials
        % match length of target and resp vectors
        myTrials(ISI_trial).resp(length(myTrials(ISI_trial).resp)+1:length(myTrials(ISI_trial).target)) = 0;
t_inds = find(myTrials(ISI_trial).target);
if isempty(t_inds)
    % if no target, check if there's false alarm
   score(subID,ISI_counter_ID) = score(subID,ISI_counter_ID)+[sum(myTrials(ISI_trial).resp) == 0];
else % if there's a target, loop through all targets
    for t_ind = t_inds
    soft_end = min([t_ind+how_many_to_check-1 length(myTrials(ISI_trial).resp)]);
score(subID,ISI_counter_ID) = score(subID,ISI_counter_ID)+[sum(myTrials(ISI_trial).resp(t_ind:soft_end)) >= 1]
    end
end

    end %ends ISI
end % end block counter

acc = []
for i = 1:length(ntargets)
acc(i) = score(i) ./ ntargets(i)
end

all_acc = [score;ntargets;acc]
