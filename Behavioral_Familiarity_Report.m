%% Recognition report
% Dumps report in the command window
% Creates recogVec(nmissed,subID) showing unrecognized faces, 
% 0 = all regonzised
loadMR % to get subvect
recogVec = []
for subID = subvect;
recog_fileNM = '*recog*';
subdir = sprintf('/Volumes/Aidas_HDD/MRI_data/S%d',subID);
fl = dir(fullfile(subdir,recog_fileNM));
if length(fl) == 1;
fl = fl.name;

load(fullfile(subdir,fl))
% File found and loaded
if length({recog([recog.response] == 2).name}') == 0
    disp(['Sub ' num2str(subID) ' Recognized All'])
    recogVec(subID) = 0;
else
disp(['Sub ' num2str(subID) ' didnt recognize ' num2str(length({recog([recog.response] == 2).name}'))])
disp({recog([recog.response] == 2).name}')
recogVec(subID) = length({recog([recog.response] == 2).name});
end
elseif length(fl) > 1
    {fl.name}'
    error('multiple recog files')
elseif length(fl) == 0
    disp([ num2str(subID) ' No recog file'])
    recogVec(subID) = nan;
end
end
recogVec = recogVec(subvect)';
recogVec(:,2) = subvect'
% 40 - 
%% Recognition from MyTrials
mt_fn = '/Volumes/Aidas_HDD/MRI_data/S%d/S%d_Results_fixed.mat';
subID = 29
load(sprintf(mt_fn,subID,subID))

{myTrials(find([myTrials.blockNum] == 5 & [myTrials.resp] == 4)).name}'

%famVec(subID)





