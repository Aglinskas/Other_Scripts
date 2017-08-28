% ROI decoding
loadMR
fn = '/Users/aidasaglinskas/Desktop/voxel_data.mat';
load(fn)
r_lbls = aBeta.r_lbls;
t_lbls = aBeta.t_lbls;
loadMR
collect_roi = 0
if collect_roi
    disp('Collecting ROIs')
vx = {};
bt_fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/beta_%s.nii';
c_vec = repmat([ones(1,12) zeros(1,6)],1,5);
bt_inds = find(c_vec);
tic
for r_ind = 1:length(masks.nii_files)
m_fn = fullfile(masks.dir,masks.nii_files{r_ind});
for s_ind = 1:20
    toc
    tic
disp(sprintf('Mask %d/%d, Sub %d/%d',r_ind,length(masks.nii_files),s_ind,20))
subID = subvect.face(s_ind);
for t_ind = 1:12
t_betas = bt_inds(t_ind:12:end);
for run_ind = 1:5
run_beta = t_betas(run_ind);
run_beta_str = num2str(run_beta,'%.4i');
bt_fn = sprintf(bt_fn_temp,subID,run_beta_str);
ds = cosmo_fmri_dataset(bt_fn,'mask',m_fn);
vx{r_ind,t_ind,s_ind,run_ind} = ds.samples;
end 
end
end 
end % ends ROI
end % ends if collect
save('/Users/aidasaglinskas/Desktop/vx.mat','vx')
disp('Done & Saved')

%%
%% Run MVPA
load('/Users/aidasaglinskas/Desktop/vx.mat')
clc
voxel_data = vx;
acc_mat = [];
n_tasks = 12;
nrois = size(voxel_data,1);
for r_ind = 1:nrois
disp(sprintf('%d/%d',r_ind,nrois))
pairs = nchoosek(1:n_tasks,2);
for pair_ind = 1:length(pairs);
ds = struct;
l = 0;
for s_ind = 1:20
for run_ind = 1:5
for t_counter = 1:2;
t_ind = pairs(pair_ind,t_counter);
l = l+1;
ds.samples(l,:) = voxel_data{r_ind,t_ind,s_ind,run_ind};
ds.sa.r_ind(l,1) = r_ind;
ds.sa.t_ind(l,1) = t_ind;
ds.sa.s_ind(l,1) = s_ind;
ds.sa.run_ind(l,1) = run_ind;
end
end
end

fix_nan = 0;
if fix_nan
if any(isnan(ds.samples(:)))
%    imagesc(isnan(ds.samples))
%    title([masks.lbls{r_ind} ' ' num2str(sum(isnan(ds.samples(:)))) ' nans'],'FontSize',20)
%    drawnow
%    pause
drop = find(sum(isnan(ds.samples),2));
ds.samples(drop,:) = [];    
ds.sa.r_ind(drop) = [];
ds.sa.t_ind(drop) = [];
ds.sa.s_ind(drop) = [];
ds.sa.run_ind(drop) = [];
%ds.sa.targets(drop) = [];
%ds.sa.chunks(drop) = [];
end
end
%disp('dataset created')
%



for i = 1:length(a)
    c(i) = corr(ds.samples(a(i),:)',ds.samples(a(i)+1,:)');
end
cmat(r_ind,pairs(pair_ind,2),pairs(pair_ind,1)) = nanmean(c);
cmat(r_ind,pairs(pair_ind,1),pairs(pair_ind,2)) = nanmean(c);

ds.sa.targets = ds.sa.t_ind;
ds.sa.chunks = ds.sa.run_ind;
partitions=cosmo_nfold_partitioner(ds.sa.chunks);
%partitions=cosmo_nfold_partitioner(chunks)
%predicted=cosmo_classify_lda(samples_train, targets_train, samples_test[,opt])
%[pred, accuracy] = cosmo_crossvalidate(dataset, classifier, partitions, opt)
[pred, accuracy] = cosmo_crossvalidate(ds, @cosmo_classify_lda, partitions);
accuracy = accuracy - 1 / length(unique(ds.sa.targets));
acc_mat(r_ind,pairs(pair_ind,1),pairs(pair_ind,2)) = accuracy;
acc_mat(r_ind,pairs(pair_ind,2),pairs(pair_ind,1)) = accuracy;
end  % ends pairs
end % ends ROI 
str = 'Dataset Created';
disp(str);
%% Decoding

set(0, 'DefaultFigureVisible', 'on')
imagesc(corr(ds.samples'))
%%


ds.sa.t_ind




