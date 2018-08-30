
mat = aBeta.fmat;
cmat = [];
for s = 1:size(mat,3)
    cmat(:,:,s) = corr(mat(:,:,s));
end
size(cmat)
%%
test_inds = [6 10];
ac_inds = find([~ismember([1:size(cmat,2)],test_inds)])
ac_inds = [1	5	7	8]
within = arrayfun(@(x) mean(get_triu(cmat(test_inds,test_inds,x))),1:size(cmat,3))';
across = squeeze(mean(mean(cmat(test_inds,ac_inds,:),1),2));

[H,P,CI,STATS] = ttest(within,across);
clc
if P < .05
warning(sprintf('t(%s) = %s, p = %s',num2str(STATS.df),num2str(STATS.tstat,3),num2str(P,3)))
else
disp(sprintf('t(%s) = %s, p = %s',num2str(STATS.df),num2str(STATS.tstat,3),num2str(P,3)))
end

%% Another way

clust_inds{1} = [1	5	7	8]; 
clust_inds{2} =  [3	4	2	9];
clust_inds{3} = [6 10];

pairs = nchoosek(1:3,2);
pair_ind = 1;


cmat(clust_inds{pairs(pair_ind,1)},clust_inds{pairs(pair_ind,2)},:)







