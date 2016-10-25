clear all
close all
loadMR
%load('/Users/aidasaglinskas/Desktop/subbetaarrays/Independent_ROIs2SubBetaArray.mat')
%load('/Users/aidasaglinskas/Google Drive/ROI_masks/Revisited/Independent_ROIs_test5SubBetaArray.mat')
load('/Users/aidasaglinskas/Desktop/Not_independentROIS2_oct25SubBetaArray.mat')
%load('/Users/aidasaglinskas/Desktop/subbetaarrays/Fully NOT independent ROISubBetaArray.mat')
%load for_Scott_arrays
size(subBetaArray)
masks_name = master_coords_labels
% Hemisphere collapse
temp = []
temp([1],:,:) = mean(subBetaArray([1 2],:,:),1);
temp([2],:,:) = mean(subBetaArray([3 4],:,:),1);
temp([3],:,:) = mean(subBetaArray([5 6],:,:),1);
temp([4],:,:) = mean(subBetaArray([7 8],:,:),1);
temp([5],:,:) = mean(subBetaArray([9 10],:,:),1);
temp([6],:,:) = mean(subBetaArray([11 12],:,:),1);
temp([7],:,:) = mean(subBetaArray([13 14],:,:),1);
temp([8],:,:) = mean(subBetaArray([15],:,:),1);
temp([9],:,:) = mean(subBetaArray([16 17],:,:),1);
temp([10],:,:) = mean(subBetaArray([18 19],:,:),1);
temp([11],:,:) = mean(subBetaArray([20],:,:),1);
temp([12],:,:) = mean(subBetaArray([21 22],:,:),1);
% temp=[];
% temp(1,:,:)=mean(subBetaArray(1,:,:),1);
% temp(2,:,:)=mean(subBetaArray(2:3,:,:));
% temp(3,:,:)=mean(subBetaArray(4:5,:,:));
% temp(4,:,:)=mean(subBetaArray(6:7,:,:));
% temp(5,:,:)=mean(subBetaArray(8:9,:,:));
% temp(6,:,:)=mean(subBetaArray(10:11,:,:));
% temp(7,:,:)=mean(subBetaArray(12:13,:,:));
% temp(8,:,:)=mean(subBetaArray(14:15,:,:));
% %temp(8,:,:)=(subBetaArray(15,:,:));
% temp(9,:,:)=(subBetaArray(16,:,:));
% temp(10,:,:)=mean(subBetaArray(17:18,:,:));
% temp(11,:,:)=mean(subBetaArray(19:20,:,:));
%
temp_pr=temp-repmat(temp(:,11,:),1,12,1);  % subtract face n-back
%reord=[6 1 4 5 2 7 1 8 9 10];
%reord = [ 2     7     4     3     5     1     8     6     9    10    11]
reord = [ 9     5     6     1     7    10     4     3    11     8     2    12]%[11     9     6     5     2    10     4     7     1     3     8    12]%[ 3 4 11 7 5 10 6 1 9 2]  

temp=temp_pr(reord,:,:);
%tempName={'OFA','FFA','aFP','Hipp','DLPFC','OFC','ATL','Prec','mPFC','pSTS'};
tempName_pr = {'Amygdala'
'Angular'
'ATL-ant'
'ATL'
'FFA'
'FP'
'IFG'
'mPFC'
'OFA'
'Orb'
'Prec'
'SFG'}
tempName = {tempName_pr{reord}}'
%
clf
% rough grouping for plots
Z2=linkage(1-pdist(squeeze(mean(temp(:,1:10,:),3)),'correlation'), 'ward');%,{'correlation'} )
[H,T,OUTPERM]  = dendrogram(Z2,length(tasks));%
%
% but let's hardcode it
%OUTPERM  = [1     4     3     5     8      2    10     6     9     7] %[     3     5     6    10     9     1     8     2     4     7];
OUTPERM = [ 7     4     5     1     8     3     9     2    10     6]
    
for myInd=1:10
others=[1:10];
mySE=squeeze(std(temp(:,OUTPERM(myInd),:)-mean(temp(:,others,:),2),[],3))/size(temp,3)^.5;

sbp = subplot(3,4,myInd)
errorbar([mean(squeeze(mean(temp(:,others,:),3)),2) squeeze(mean(temp(:,OUTPERM([myInd]),:),3))],[mySE*0 mySE*1    ])
legend({'others','task'},'Location','NorthWest')
% store difference between this task and others
blob(myInd,:)=[-mean(squeeze(mean(temp(:,others,:),3)),2)+squeeze(mean(temp(:,OUTPERM([myInd]),:),3))];
title(tasks(OUTPERM([myInd])))
sbp.XTickLabelRotation = 45
ylim([-.2 1.3])
hold on

% plot(squeeze(mean(temp(:,([12]),:),3))) to plot places
hold off
set(gca,'XTick',1:length(tempName)), set(gca,'XTickLabel',tempName)
%xlim([.5 10.5])
xlim([.5 12.5])
end


subplot(3,5,14:15),add_numbers_to_mat(blob)
set(gca,'XTick',1:length(OUTPERM)), set(gca,'XTickLabel',tempName)
set(gca,'YTick',1:length(OUTPERM)), set(gca,'YTickLabel',tasks(OUTPERM))