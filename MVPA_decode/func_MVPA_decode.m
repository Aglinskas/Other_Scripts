function rfx_mat = func_MVPA_decode(all_scans)

loadMR;
dataset = all_scans;
ttl = dataset.a.ttl;
%dataset.samples = zscore(dataset.samples,[],1)
dataset.sa.chunks = dataset.sa.run_ind;
dataset.sa.targets = dataset.sa.t_ind;
classifier = @cosmo_classify_lda;
pairs = nchoosek(unique(dataset.sa.targets),2);

opt = struct;
rfx_mat = [];
for p_ind = 1:length(pairs)
sliced_ds = cosmo_slice(dataset,ismember(dataset.sa.t_ind,pairs(p_ind,:)));
partitions = cosmo_nfold_partitioner(sliced_ds.sa.chunks);
opt.normalization='none';%zscore
[pred, accuracy] = cosmo_crossvalidate(sliced_ds, classifier, partitions,opt);

% results;
temp = [];
temp = [pred-sliced_ds.sa.targets==0 sliced_ds.sa.s_ind];
for s = 1:max(sliced_ds.sa.s_ind)
rfx_mat(pairs(p_ind,1),pairs(p_ind,2),s) = mean(temp(find(temp(:,2)==s),1));
    rfx_mat(pairs(p_ind,2),pairs(p_ind,1),s) = rfx_mat(pairs(p_ind,1),pairs(p_ind,2),s);
        temp2 = rfx_mat(:,:,s);
        temp2(find(eye(size(rfx_mat,1)))) = nan;
        rfx_mat(:,:,s) = temp2;
end

end
rfx_mat = rfx_mat - .5;

mf =  figure(1);clf
add_numbers_to_mat(mean(rfx_mat,3),aBeta.t_lbls);

    mf.CurrentAxes.XTickLabelRotation = 45;
    mf.CurrentAxes.FontWeight = 'bold';
    mf.CurrentAxes.FontSize = 12;

title(ttl,'fontsize',20)

bf = figure(2);clf

tm = squeeze(nanmean(rfx_mat(1:10,1:10,:),1));
sd = std(tm')';
se = sd ./ sqrt(size(rfx_mat,3));

bar(mean(tm'));
hold on;
errorbar(mean(tm')',se,'r*')
    bf.CurrentAxes.XTickLabel = aBeta.t_lbls(1:10);
    bf.CurrentAxes.XTickLabelRotation = 45;
    bf.CurrentAxes.FontWeight = 'bold';
    bf.CurrentAxes.FontSize = 12;
title(ttl,'fontsize',20)    
drawnow
