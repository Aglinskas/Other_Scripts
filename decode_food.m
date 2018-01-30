all_scans = [];
m_fn = '/Volumes/wonderwoman/WP_2.1.2/Typicality_judgment/ROIs/Insula_L.nii'
subID = 13;
for sess = 1:2
mc_fn = [];mc_fn = sprintf('/Volumes/wonderwoman/WP_2.1.2/Typicality_judgment/sub%s/MCT_s%dm1r%d.mat',num2str(subID,'%.2i'),subID,sess);load(mc_fn)
dt_fn = sprintf('/Volumes/wonderwoman/WP_2.1.2/Typicality_judgment/sub%s/sess_%d/w4D.nii',num2str(subID,'%.2i'),sess)
for wh_targ = [7 1 2]
TRs = ceil((onsets{wh_targ}'+4) /2);
for v_ind = 1:length(TRs);
single_scan = cosmo_fmri_dataset(dt_fn,'mask',m_fn,'volumes',TRs(v_ind));
single_scan.sa.targets = wh_targ;
single_scan.sa.chunks = sess;

if isempty(all_scans)
    all_scans = single_scan;
else
    all_scans = cosmo_stack({all_scans single_scan})
end
end
end
end
all_scans.sa.targets(all_scans.sa.targets ~= 7) = 1
%all_scans.sa.targets(ismember(all_scans.sa.targets,[1 2])) = 2 % haxs
%% Classify
%all_scans.sa.targ = all_scans.sa.targets
partitions=cosmo_nfold_partitioner(all_scans.sa.chunks)
classifier = @cosmo_classify_lda
opt.normalization = 'zscore'
[pred, accuracy] = cosmo_crossvalidate(all_scans, classifier, partitions, opt)





