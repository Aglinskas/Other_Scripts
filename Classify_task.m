loadMR
load('/Users/aidasaglinskas/Desktop/Tiny_BT.mat')
%%
lbls = tiny_t_labels %t_labels(1:10);
arr = tiny_bt;
%arr = arr - arr(:,11,:,:);
%arr = arr(:,1:10,:,:);
%arr = zscore(arr,[],2);

%disp(size(arr))
row = 0;
%for r_ind = 1:size(bt,1)
clear ds
for t_ind = 1:size(arr,2)
for s_ind = 1:size(arr,3)
for run_ind = 1:size(arr,4)
row = row+1;
ds.samples(row,:) = arr(:,t_ind,s_ind,run_ind)';
ds.sa.task(row,1) = t_ind;
ds.sa.subject(row,1) = s_ind;
ds.sa.run(row,1) = run_ind;

%end
end
end
end
if cosmo_check_dataset(ds)
    disp('Dataset OK')
end
% Slice the dataset
ds.sa.chunks = ds.sa.run;
ds.sa.targets = ds.sa.task;
clear mat
pairs = nchoosek(1:max(ds.sa.targets),2);
for p_ind = 1:length(pairs)
this_ds = cosmo_slice(ds,ismember(ds.sa.targets,pairs(p_ind,:)));

% Run Classification
cls = {@cosmo_classify_knn @cosmo_classify_lda @cosmo_classify_libsvm @cosmo_classify_matlabsvm_2class @cosmo_classify_matlabsvm @cosmo_classify_meta_feature_selection @cosmo_classify_naive_bayes};
cl = cls{2};
%disp(cls{7})
%@cosmo_classify_naive_bayes 7
partitions=cosmo_nfold_partitioner(this_ds.sa.chunks);
[pred, accuracy] = cosmo_crossvalidate(this_ds, cl, partitions);
%disp(sprintf('Accuracy: %s',num2str(accuracy)))

mat(pairs(p_ind,1),pairs(p_ind,2)) = accuracy;
mat(pairs(p_ind,2),pairs(p_ind,1)) = accuracy;
end
disp('Mat done')
%
mat = mat - .5;
newVec = get_triu(mat);
Z = linkage(newVec,'ward')
d = subplot(1,2,2);
[h x perm] = dendrogram(Z,'labels',lbls,'orientation','left')
    [h(1:end).LineWidth] = deal(3);
    d.FontSize = 12;
    d.FontWeight = 'bold';
    ord = perm(end:-1:1);
    m = subplot(1,2,1);
add_numbers_to_mat(mat(ord,ord),lbls(ord));
  m.FontSize = 12;
  m.FontWeight = 'bold';
  m.XTickLabelRotation = 35;C