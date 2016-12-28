%% Load up vars
clear all
load('/Users/aidasaglinskas/Desktop/Silvia_Script/OutPut_StimCheck_behavioral_s13.mat')
load('/Users/aidasaglinskas/Desktop/Silvia_Script/OutPut_TimeCourse_Semantic_feedback_s13_r1.mat')
%% get unknown vector;
unknown.ind = find([myTrials.resp] == 2)';
unknown.name = {myTrials(unknown.ind).name}'
%% add unknowns to allTrials
for r = 1:length(allTrials)
for u = 1:length(unknown.name)
    if isempty(allTrials(r).name) == 0 & strmatch(allTrials(r).name,unknown.name(u)) == 1
        allTrials(r).unknownFace = 1; 
    else 
        %allTrials(r).unknownFace = 0; 
    end
end
end
%% Check if they match
% Gotta add the zeros because when you concatenate an array, it drops empty
% cells #nerdstuff #annoyign #dirty_hacking
[allTrials(find(cellfun(@isempty,{allTrials.unknownFace}))).unknownFace] = deal(0);
%unique({allTrials(find([allTrials.unknownFace] == 1)).name}')
h1 = sort(unknown.name);
h2 = unique({allTrials(find([allTrials.unknownFace] == 1)).name}');
if all([h1{:}] == [h2{:}])
    disp('hash check passed')
else 
    disp('Subject Unknowns')
    disp(h1)
    disp('Data unknowns')
    disp(h2)
    error('Hash check fail')
end
%% Ok, now that's all good and dandy, let's get TriaIDs
[allTrials.TrialID] = deal(0);
r = 1;
disp('Attaching TrialIDs')
while r < length(allTrials)% - allTrials(length(allTrials)).psLength+1
    %allTrials(r).trialCode;
mark = [r:r+allTrials(r).psLength-1];
[allTrials(mark).TrialID] = deal(max([allTrials.TrialID])+1);
r = max(mark) + 1;
end
disp('Done')
%% the easy bit
v1 = [find([allTrials.isTarget]) find([allTrials.isTarget]) - 1]
v2 = find([allTrials.unknownFace])
%{allTrials(v1(ismember(v1,v2))').name}'
to_dump = v1(ismember(v1,v2));
[allTrials.dump_these] = deal(0)
for ii = 1:length(to_dump)
    [allTrials(find([allTrials.TrialID] == allTrials(to_dump(ii)).TrialID)).dump_these] = deal(1);
end
%%
% for ii = 1:length(allTrials)
% allTrials(ii).checkTarget = allTrials(ii).isTarget
% allTrials(ii).checkTrial = allTrials(ii).trialCode
% end



