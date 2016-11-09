clear all
loadMR
analysis_name = 'cross subjects test';
% [1 2 3 10 11 14] % DMN
% [4 5 6 7 8 9 15 16] Core-frontal
% [12 13 17 18]
w_rois = 1:18
pairs = nchoosek(1:12,2);
for paircomp = 1:length(pairs);
%% Stack all_scans; 
all_scans = struct;
all_scans.samples = [];
for s = 1:20;
for t_ind = [1:2];
t = pairs(paircomp,t_ind);
l = size(all_scans.samples,1) + 1;
    all_scans.samples(l,:) = subBeta.array(w_rois,t,s)';
    % Set other thangs
    all_scans.sa.chunks(l,1) = s;
    all_scans.sa.targets(l,1) = t;
    %all_scans.fa.i
end
end
%all_scans.samples = zscore(all_scans.samples,[],1);
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

output.cor(pairs(paircomp,1),pairs(paircomp,2)) = scan_cor;
output.cor(pairs(paircomp,2),pairs(paircomp,1)) = scan_cor;
end
%%
trim_mat = 1:10;
f = figure(6)
p = subplot(2,2,1)
add_numbers_to_mat(output.acc(trim_mat,trim_mat),t_labels(trim_mat))
p.FontSize = 16
title('Decoding')
p = subplot(2,2,2)
add_numbers_to_mat(output.cor(trim_mat,trim_mat),t_labels(trim_mat))
p.FontSize = 16
title('Correlation')
p = subplot(2,2,3)
newVec = get_triu(output.acc(trim_mat,trim_mat));
Z = linkage(newVec,'ward');
[h x] = dendrogram(Z,'labels',t_labels(trim_mat),'orientation','left')
[h(1:end).LineWidth] = deal(5)
p.FontSize = 16
title('Decoding Dend')
p = subplot(2,2,4)
newVec = get_triu(output.cor(trim_mat,trim_mat));
Z = linkage(1-newVec,'ward');
[h x] = dendrogram(Z,'labels',t_labels(trim_mat),'orientation','left')
[h(1:end).LineWidth] = deal(5)
p.FontSize = 16
title('Decoding Cor')
disp('All done')