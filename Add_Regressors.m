
save('/Volumes/Aidas_HDD/MRI_data/S6/Functional/Sess2/rp_adata_withResp.txt','rp_adata', '-ASCII')
rp_adata(:,7) = R
TR1 = [[myTrials.fmriRun];[myTrials.TR];[myTrials.TR] + 1;[myTrials.resp]]


tr2 = [[myTrials.fmriRun],[myTrials.fmriRun];[myTrials.TR],[myTrials.TR] + 1;[myTrials.resp],[myTrials.resp]]

% tr2(sess1,3) get session1 scores from tr2 thing

load('/Volumes/Aidas_HDD/MRI_data/S6/Functional/Sess1/rp_adata.txt')
sess2 = find(tr2(:,1) == 2) 
R(tr2(sess2,2)) = tr2(sess2,3)
save('/Volumes/Aidas_HDD/MRI_data/S6/Functional/Sess2/rp_adata_withResp.txt','rp_adata', '-ASCII')

%% fix skipped responses
for i = 1 : length(myTrials)
if isempty(myTrials(i).resp)
 myTrials(i).resp = 0
end
end
%% fix skipped responses
for i = 1 : length(myTrials)
if isempty(myTrials(i).resp)
 myTrials(i).resp = 0
end
end
    %% Make TRs
myTrials.TR
for i = 1 : length(myTrials)
    myTrials(i).TR = floor(myTrials(i).time_presented) / 2;
end