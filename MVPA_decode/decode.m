loadMR;
%%
m_ind = 10;
disp(masks.lbls{m_ind})
masks.dir = '/Users/aidasaglinskas/Desktop/Work_Clutter/faces_blobsp01/';
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
%%
exp_ind = 1;
disp(m.exp_lbls{exp_ind})
bt_temp{1} = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/S%d/Analysis/beta_%s.nii';
bt_temp{2} = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/Analysis/beta_%s.nii';
bt_inds_all = find(repmat([ones(1,12) zeros(1,6)],1,5));
%exp.nsubs = [20 24];
exp.subvecs = {subvect.face subvect.word};
%% Build Data
tic
all_scans = [];
for s_ind = 1:length(exp.subvecs{exp_ind})
    subID = exp.subvecs{exp_ind}(s_ind);
for t_ind = 1:12;
clc;
disp(sprintf('sub: %d/%d, task: %d/%d',s_ind,length(exp.subvecs{exp_ind}),t_ind,12))
    bt_inds = bt_inds_all(t_ind:12:end);
for run_ind = 1:5
    this_bt_ind = bt_inds(run_ind);
    this_bt_fn = sprintf(bt_temp{exp_ind},subID,num2str(this_bt_ind,'%.4i'));  
    single_scan = cosmo_fmri_dataset(this_bt_fn,'mask',m_fn);
single_scan.sa.s_ind = s_ind;
single_scan.sa.t_ind = t_ind;
single_scan.sa.run_ind = run_ind;
    if isempty(all_scans)
        all_scans = single_scan;
    else 
        all_scans = cosmo_stack({all_scans single_scan});
    end
end %ends run
end %ends task
end %ends sub
disp('data set created')
toc
all_scans_backup = all_scans;
%%
all_scans = all_scans_backup;

all_scans.sa.s_ind = all_scans.sa.s_ind';
all_scans.sa.t_ind = all_scans.sa.t_ind';
all_scans.sa.run_ind = all_scans.sa.run_ind';
all_scans = cosmo_remove_useless_data(all_scans);
disp(sprintf('%d NaNs in dataset',sum(isnan(all_scans.samples(:)))))
figure(3); 
imagesc(all_scans.samples);
ttl = {m.exp_lbls{exp_ind} masks.lbls{m_ind}};
title(ttl,'fontsize',20)
%%
dataset = all_scans;
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
opt.normalization='zscore';
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
%
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