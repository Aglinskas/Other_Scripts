%% Extract voxel data
loadMR
b_fn_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/beta_%s.nii';
v = repmat([ones(1,12) zeros(1,6)],1,5);
wh_betas = find(v);

bt_voxel = {};
    for s_ind = 1:20;
subID = subvect(s_ind);
    for m_ind = 1:18;
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
disp(sprintf('Running sub: %d/20, ROI: %d/18',s_ind,m_ind))
    for b_ind = 1:12;
run_betas = wh_betas(b_ind:12:end);
    for run_ind = 1:5;
this_beta = run_betas(run_ind);
b_str = num2str(this_beta, '%.4i');
b_fn = sprintf(b_fn_temp,subID,b_str);
ds = cosmo_fmri_dataset(b_fn,'mask',m_fn);

bt_voxel{m_ind,b_ind,s_ind,run_ind} = ds.samples;

% if run_ind == 1
%     all_scans = ds;
% else 
% all_scans = cosmo_stack({all_scans,ds});
% end
% 
% if sum(isnan(ds.samples(:))) > 0
%     error('nan')
% end

    end
    end
    end
    end
    
















%% Compute on voxel data
size(bt_voxel)
rmat = [];
for roi_ind = 1:18
pairs = nchoosek(1:10,2);
for p_ind = 1:length(pairs)
ds = struct;
row = 0;
for t = [1 2]
for s_ind = 1:20
row = row+1;
%size(bt_voxel) : 18    12    20

ds.samples(row,:) = bt_voxel{roi_ind,pairs(p_ind,t),s_ind};
ds.sa.targets(row,1) = pairs(p_ind,t);
ds.sa.chunks(row,1) = s_ind;
end
end
% Compute pair 

cosmo_check_dataset(ds);
partitions=cosmo_nfold_partitioner(ds.sa.chunks);
cl = @cosmo_classify_lda;
[pred, accuracy] = cosmo_crossvalidate(ds,cl, partitions);

ts = unique(ds.sa.targets);
rmat(roi_ind,ts(1),ts(2)) = accuracy;
rmat(roi_ind,ts(2),ts(1)) = accuracy;
end
end
disp('all done')
