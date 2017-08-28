clear 
loadMR;
load('/Users/aidasaglinskas/Desktop/bt_task.mat')
load('/Users/aidasaglinskas/Desktop/Tiny_BT.mat')
%% Create Ds
% bt( 18    12    20     5 )
%lbls = tiny_r_labels;
lbls = { 'ATL' 'pSTS' 'FFA' 'IFG' 'OFA' 'Orb' 'Prec-mPFC'}
arr = bt;
%arr = mean(arr,4)

arr = arr - arr(:,11,:,:);
arr = arr(:,1:10,:,:);
arr = zscore(arr,[],2);

ds = struct;
row = 0;
for s_ind  = 1:size(arr,3)
for d_ind = 1:size(arr,1)
for run_ind = 1:size(arr,4)
row = row+1;
ds.samples(row,:) = arr(d_ind,:,s_ind,run_ind)';
ds.sa.fmri_run(row,1) = run_ind;
ds.sa.ROI(row,1) = d_ind;
ds.sa.subject(row,1) = s_ind;
end
end
end
disp('done')
if cosmo_check_dataset(ds);disp('dataset ok');else disp('dataset fucked');end
% add targets and chunks

%wh_t_inds = {[1 5] [7 8] [3 4] [2 9] [6 10]};
 wh_t_inds = {[1 2] [5 6] [7 8] [11 12] [13 14] [15 16] [17 18] }

ds.sa.targets = []
for i = 1:length(wh_t_inds)
ds.sa.targets(find(ismember(ds.sa.ROI,wh_t_inds{i}))) = i;    
end
ds.sa.targets = ds.sa.targets'

ds.sa.chunks = ds.sa.fmri_run;
%ds.sa.targets = ds.sa.ROI;

%
n_pairs = unique(ds.sa.targets);
n_pairs(n_pairs==0) = [];
pairs = nchoosek(n_pairs,2);

r_mat = nan(length(n_pairs));
for pair_ind = 1:length(pairs)
this_pair = pairs(pair_ind,:);
this_ds = cosmo_slice(ds,ismember(ds.sa.targets,this_pair));

classifier = @cosmo_classify_lda;
partitions=cosmo_nfold_partitioner(this_ds.sa.chunks);
[pred, accuracy] = cosmo_crossvalidate(this_ds, classifier, partitions);

r_mat(this_pair(1),this_pair(2)) = accuracy;
r_mat(this_pair(2),this_pair(1)) = accuracy;
end

r_mat = r_mat - .5;
f = figure(1);
d = subplot(1,2,2);
newVec = get_triu(r_mat);
Z = linkage(newVec,'ward');
[h x perm] = dendrogram(Z,'labels',lbls,'orientation','left');
ord = perm(end:-1:1);
m = subplot(1,2,1);
add_numbers_to_mat(r_mat(ord,ord),lbls(ord));

m.FontSize = 14; d.FontSize = 14;
m.FontWeight = 'Bold'; d.FontWeight = 'Bold';
m.XTickLabelRotation = 45;
d.XTickLabelRotation = 0;
[h(1:end).LineWidth] = deal(3);


ofn = '/Users/aidasaglinskas/Desktop/untitled folder/';
saveas(f,fullfile(ofn,datestr(datetime)),'png')

