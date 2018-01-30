loadMR
%% Make Dataset
mats = {aBeta.fmat_raw aBeta.wmat_raw}
amatt = cat(3,mats{1},mats{2});
subCodes = [zeros(1,size(mats{1},3)) ones(1,size(mats{2},3))];
r_inds = [];
amat = amatt(~ismember([1:21],r_inds),:,:);
ds = [];
l = 0;
for s = 1:44
for t = 1:10
l = l+1;
ds.samples(l,:) = amat(:,t,s)';
ds.sa.s_ind(l,1) = s;
ds.sa.s_code(l,1) = subCodes(s);
ds.sa.t_ind(l,1) = t;
end
end
%cosmo_disp(ds)
cosmo_check_dataset(ds)
%% Tweak DS
ds.sa.targets = ds.sa.t_ind;
ds.sa.chunks = ds.sa.s_code;
% Decode
pairs = nchoosek(unique(ds.sa.targets),2);
crit = []
resmat = []
for p_ind = 1:length(pairs);
% Slice data 
crit(:,1) = ismember(ds.sa.targets,pairs(p_ind,:));
crit(:,2) = ismember(ds.sa.s_code,[0 1]);
    elements_to_select = all(crit,2);
    dataset = cosmo_slice(ds,elements_to_select);
    partitions=cosmo_nfold_partitioner(dataset.sa.chunks);
    opt = [];
    %opt.normalization = 'zscore'
    classifier = @cosmo_classify_lda;
[pred, accuracy] = cosmo_crossvalidate(dataset, classifier, partitions, opt);
accuracy = accuracy-1/length(unique(dataset.sa.targets));
resmat(pairs(p_ind,1),pairs(p_ind,2)) = accuracy;
    resmat(pairs(p_ind,2),pairs(p_ind,1)) = accuracy;
    resmat(pairs(p_ind,1),pairs(p_ind,1)) = 0;
    resmat(pairs(p_ind,2),pairs(p_ind,2)) = 0;
end

t_lbls = aBeta.t_lbls(1:10);
subplot(2,1,1)
[h x perm] = dendrogram(linkage(get_triu(resmat),'ward'),'orientation','left','labels',t_lbls);
make_pretty_dend(h)
ord = perm;
subplot(2,1,2)
%add_numbers_to_mat(resmat,aBeta.t_lbls);
add_numbers_to_mat(1-resmat(ord,ord),aBeta.t_lbls(ord));


