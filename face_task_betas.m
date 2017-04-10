%% Extract Face Betas from folder
clear 
loadMR
s = 1;
subID = subvect(s);

    bt.dir_temp = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/Analysisall_faces/',subID);
    bt.beta_temp = [bt.dir_temp 'beta_%s.nii']; %sprintf('beta_%s.nii',bt_ind)
    bt.SPM_path = [bt.dir_temp 'SPM.mat'];
 
%%
clear person_betas
clear SPM
load(bt.SPM_path)
cutoff_ons = 500; 
%
conds = [SPM.Sess.U];
bad_inds = [conds.ons]' > cutoff_ons;
%fcs = arrayfun(@(x) conds(x).name{1},find(bad_inds == 0),'UniformOutput',0);
faces = arrayfun(@(x) conds(x).name{1},1:400,'UniformOutput',0);
for sess = 1:5
if sess == 1;vect = [];end
sess_inds = [[SPM.Sess(sess).U.ons]' < cutoff_ons];
%sess_names{sess} = arrayfun(@(x) SPM.Sess(sess).U(x).name{1},find(sess_inds),'UniformOutput',0)
vect = [vect;sess_inds];
end

wh_betas = find(repmat([ones(1,80) zeros(1,6)],1,5));


for m_ind = 7
    m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
    
   for w_b = 1:length(wh_betas)
       b_ind = wh_betas(w_b);
    b_fn = sprintf(bt.beta_temp,num2str(b_ind,'%.4i'));
    ds = cosmo_fmri_dataset(b_fn,'mask',m_fn);

    
person_betas.voxel{s,m_ind,w_b} = ds.samples;
person_betas.ROI(s,m_ind,w_b) = mean(ds.samples);
   end
drop = find(vect==0);
person_betas.ROI(s,m_ind,drop) = nan;  
[person_betas.voxel{s,m_ind,drop}] = deal(nan);
[faces_sorted,ord,IC] = unique(faces);

person_betas.ROI(s,m_ind,:) = person_betas.ROI(s,m_ind,ord)

a = person_betas.ROI(s,m_ind,ord);
a = squeeze(a)
a = a(find(isnan(a) == 0))
a = zscore(a)
bar(a)
end
disp('extracted')
%%

v = squeeze(person_betas.ROI(1,7,:));

clf
bar(v)
%%



