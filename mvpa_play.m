clear all
loadMR
w_rois = 1:18;
%pairs = nchoosek(1:12,2);
%for paircomp = 1:length(pairs);
%% Stack all_scans; 
all_scans = struct;
all_scans.samples = [];
for s = 1:20;
for t_ind = 1:12;
%t = pairs(paircomp,t_ind);
t = t_ind
l = size(all_scans.samples,1) + 1;
    all_scans.samples(l,:) = subBeta.array(w_rois,t,s)';
    % Set other thangs
    all_scans.sa.chunks(l,1) = s;
    all_scans.sa.targets(l,1) = t;
    %all_scans.fa.i

end
end
all_scans.samples = zscore(all_scans.samples,[],2);
%corr_scans(1,:) = mean(all_scans.samples(1:2:end,:),1);
%corr_scans(2,:) = mean(all_scans.samples(2:2:end,:),1);

scan_cor = mean(get_triu(corr(all_scans.samples')));
%% Decoding
measure=@cosmo_crossvalidation_measure;  % pick to classify
opt=struct();
opt.classifier=@cosmo_classify_lda;
opt.partitions=cosmo_nchoosek_partitioner(all_scans,1);
%ds_sa = cosmo_crossvalidation_measure(ds, varargin)
corr_results=cosmo_crossvalidation_measure(all_scans,opt);% ,'nproc',4
corr_results.samples=corr_results.samples-(1/length(unique(all_scans.sa.targets)));

% Output
output.acc(pairs(paircomp,1),pairs(paircomp,2)) = corr_results.samples;
output.acc(pairs(paircomp,2),pairs(paircomp,1)) = corr_results.samples;

%output.cor(pairs(paircomp,1),pairs(paircomp,2)) = scan_cor;
%output.cor(pairs(paircomp,2),pairs(paircomp,1)) = scan_cor;
%%
%end
%%
trim_mat = 1:10;
f = figure(6)
subplot(1,3,1)
add_numbers_to_mat(output.acc(trim_mat,trim_mat),t_labels(trim_mat))
subplot(1,3,2)
add_numbers_to_mat(output.cor(trim_mat,trim_mat),t_labels(trim_mat))
subplot(1,3,3)
newVec = get_triu(output.acc(trim_mat,trim_mat));
Z = linkage(newVec);
dendrogram(Z,'labels',t_labels(trim_mat),'orientation','left')
disp('All done')