reducedBetaArray=(subBetaArray(2:20,1:10,:));

for subj=1:size(reducedBetaArray,3)
   keep(subj,:,:)= corr(squeeze(reducedBetaArray(:,:,subj)));
end
% 
% subplot(1,3,1),imagesc(squeeze(mean(keep)).*abs(eye(19)-1));
% subplot(1,3,2),imagesc(singmat)
% subplot(1,3,3),imagesc(abs((squeeze(mean(keep))./(squeeze(std(keep)./sqrt(20)))).*abs(eye(19)-1))>4);
