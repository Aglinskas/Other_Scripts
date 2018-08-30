myFiles=uigetfile('MultiSelect', 'on')
numOfSubjects=length(myFiles); % How ma
allData = [];
commandwindow
for sub=1:numOfSubjects % so, for each subject
    m = SCT_analysis(myFiles{sub}) % each SCT file get's fed into the SCT_analysis function;
    % Pause % pause to see plots for every subject
    allData(sub,:) = m;  
%run your function with the input set to this subject file. Get the output. Check the graphs
%Pause; this allows you to look at the plots. Matlab will start again when your press a button
%In an array (nSubs by 2), record this subjects SNR for 500 and 1500Hz
end

[H,P,CI,STATS] = ttest(allData(:,1),allData(:,2))
%corr(allData(:,1),allData(:,2)) % we can also check the correlation!

% Do you want to use the function ttest or ttest2 (look at the help)
% Use the t-test to find the p-value determine if there is a difference between SNR thresholds for each pitch;
% This will be a bit tricky – look at help to determine how you need to organinse the input.
% What is the correlation between 500 and 1500 Hz threshold across subjects?
% Can you plot this?