loadMR
outMatCorr=[];
nTask = 10
subVec=1:size(subBetaArray,3);
for sub=1:size(subBetaArray,3)
    x=squeeze(subBetaArray(:,:,sub));
    y=squeeze(mean(subBetaArray(:,:,subVec(subVec~=sub)),3));
    x=zscore(x')';
    y=zscore(y')';
    for ii=1:nTask
        for jj=1:nTask
            outMatCorr(sub,ii,jj)=corr(x(:,ii),y(:,jj));
        end
    end
end
%%
lbls = {tasks{1:10}}'
figure
add_numbers_to_mat(squeeze(mean(outMatCorr,1)),lbls)

j = squeeze(mean(outMatCorr,1));
j = corr(j);

newVec = get_triu(j);
Z = linkage(1-newVec,'ward')
dendrogram(Z,'labels',lbls,'orientation','left')

%%






