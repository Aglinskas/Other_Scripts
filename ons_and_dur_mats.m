
source = '/Volumes/Aidas_HDD/01-Dec-2015_Results.mat'    ;
load(source)
% for i = 1:15
%     durations{i} = 4
% end
for p = 1:15
durations{p} = 4
end
mx = length([myTrials.time_presented])
maxr = max([myTrials(1:mx).fmriRun])

for u = 1 : length([myTrials.blockNum])
    if myTrials(u).blockNum == 16 | myTrials(u).blockNum == 17
         myTrials(u).blockNum = 15
    end
end

for r = 1 : maxr
    s_line = min(find([myTrials.fmriRun] == r))
    e_line = max(find([myTrials.fmriRun] == r))
    b = unique([myTrials(s_line:e_line).blockNum])
    for i = 1 : length(b)
        inx = find([myTrials.blockNum] == b(i) & [myTrials.fmriRun] == r)
        names{i} = num2str(b(i))
        for o = 1 : length(inx)
            ons(o) = myTrials(inx(o)).time_presented
        end
    onsets{i} = ons
    clear inx & ons
    end
 
%  durations{b(i)} = dur;
  save(sprintf('multiple_cond_run%d',r),'onsets','names','durations')
  clear onsets & names & inx & o & ons & b
end
  