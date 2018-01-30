function all_scans = func_MVPA_getVoxelData(m_ind,exp_ind)
%m_ind = 10;
loadMR;
disp(masks.lbls{m_ind})
masks.dir = '/Users/aidasaglinskas/Desktop/Work_Clutter/faces_blobsp01/';
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
%%
%exp_ind = 1;
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
disp(sprintf('ROI: %d,exp: %d,sub: %d/%d, task: %d/%d',m_ind,exp_ind,s_ind,length(exp.subvecs{exp_ind}),t_ind,12))
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
%all_scans.sa.s_ind = all_scans.sa.s_ind';
%all_scans.sa.t_ind = all_scans.sa.t_ind';
%all_scans.sa.run_ind = all_scans.sa.run_ind';
all_scans = cosmo_remove_useless_data(all_scans);
disp(sprintf('%d NaNs in dataset',sum(isnan(all_scans.samples(:)))))
figure(3); 
imagesc(all_scans.samples);
ttl = {m.exp_lbls{exp_ind} masks.lbls{m_ind}};
all_scans.a.ttl = ttl;
title(ttl,'fontsize',20)