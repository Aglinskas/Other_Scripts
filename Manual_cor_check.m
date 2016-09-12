%%
which_rois_to_cor = [3 7 14 17]%2:20

clear keep
reducedBetaArray=(subBetaArray(which_rois_to_cor,1:10,:));%subBetaArray(ROI,TASK,SUB)
for subj=1:size(reducedBetaArray,3)
   keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,:,subj))'); %the transpose is important reducedBetaArray(:,:,subj))'); 
end
size(keep)
%%

which_rois_to_cor = []

clear withinDat
%keep = keep(:,which_rois_to_cor,which_rois_to_cor)
% Scotts, =  1.49
%%
wthn=[1,3;,2,4]
btwn=[1,2;1,4;2,3;4,3]
%%
% %Mine, with reduced beta array  = 5.25
% wthn=[1,4;,7,17]
% btwn=[1,7;1,17;4,7;4,17]
% %%
% % Mine, with full beta array(32 rois) = 5.25
% 
% wthn=[2,5;,8,18]
% btwn=[2,8;2,18;5,8;5,18]
%%
clear withinDat
for ii=1:size(wthn,1)
    withinDat(:,ii)=keep(:,wthn(ii,1),wthn(ii,2))
end

for ii=1:size(btwn,1)
    btwnDat(:,ii)=keep(:,btwn(ii,1),btwn(ii,2))
end

statDat=(mean(withinDat,2)-mean(btwnDat,2));

mean(statDat)./(std(statDat)/size(statDat,1)^.5)
%%
% statDat=(mean(within_clust_betas,2)-mean(betweeen_clust_betas,2));
% mean(statDat)./(std(statDat)/size(statDat,1)^.5)
%%
within_clust_betas
betweeen_clust_betas
%%

%%