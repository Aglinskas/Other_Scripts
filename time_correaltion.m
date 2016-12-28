loadMR
% Extract Data (takes time)
data = []
tic
for s = 1:20;
subID = subvect(s);
for sess = 1:5;
disp(s)
for m_ind = 1:18;
m_fn = fullfile(masks.dir,masks.nii_files{m_ind});
mt_fn = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/sub%drun%d_multicond.mat',subID,subID,sess);
load(mt_fn); % onsets, durations
TR = cellfun(@(x) round(x/2.5)+1,onsets,'UniformOutput',false);
%find([TR{:}] == max([TR{:}]))
%vols_to_load = [TR{1:10}]';
%vols_to_load(find(vols_to_load > 208)) = 208;
vols_to_load = 1:208;
fn = sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/Functional/Sess%d/swdata.nii',subID,sess);
ds = cosmo_fmri_dataset(fn,'mask',m_fn,'volumes',vols_to_load);
data(s,sess,m_ind,:) = mean(ds.samples,2);
end
end
end
save('/Users/aidasaglinskas/Desktop/data5_12_off_208vols.mat','data')
toc
%%
clear all
loadMR
load('/Users/aidasaglinskas/Desktop/data5_12_off_208vols.mat')
load('/Users/aidasaglinskas/Desktop/lbls_alphabetical.mat')
size(data)
which_sess = 5
%d = squeeze(data(:,which_sess,:,:));
d = squeeze(mean(data,2));
% Reorder task
size(d)
%d = zscore(d,[],3)
%d = d - mean(d,2);
steps = 1:8:88;
d_ord = []
for s = 1:20
for r = 1:18
for i_ind = 1:10
    i = steps(i_ind):steps(i_ind+1) - 1;
    i_r = steps(subBeta.ord_t(i_ind)):steps(subBeta.ord_t(i_ind)+1) - 1;
    d_ord(s,r,i) = d(s,r,i_r);
    d_ord(s,r,i) = zscore(d_ord(s,r,i));
end
end
end
d = d_ord;
zd = d;
%zd = zscore(d,[],3);
%
size(zd)
for s = 1:20
for r1 = 1:18
for r2 = 1:18
    v1 = squeeze(zd(s,r1,:));
    v2 = squeeze(zd(s,r2,:));
cormat(s,r1,r2) = corr(v1,v2);
end
end
end
%
mmat = squeeze(mean(cormat,1))
figure(1)
clf

dd = subplot(1,2,2);
newVec = get_triu(1-mmat);
Z = linkage(newVec,'ward');
[h sh perm] = dendrogram(Z,'labels',lbls,'orientation','left');
[h(1:end).LineWidth] = deal(3);
dd.FontSize = 14

subplot(1,2,1)
mmat = mmat(perm,perm);
d = d(:,perm,:);
lbls = lbls(perm);
add_numbers_to_mat(mmat,lbls)


m = squeeze(mean(zd,1));
figure(2)
clf
imagesc(m)
xticks([1:8:80])
xticklabels(t_labels(subBeta.ord_t))
xtickangle(45)
yticks([1:18])
yticklabels(lbls)


%%
lbls = {'ATLLeft'
    'ATLRight'
    'AmygdalaLeft'
    'AmygdalaRight'
    'AngularLeft'
    'AngularRight'
    'FFALeft'
    'FFARight'
    'Face PatchLeft'
    'Face PatchRight'
    'IFGLeft'
    'IFGRight'
    'OFALeft'
    'OFARight'
    'OrbLeft'
    'OrbRight'
    'PFCmedial'
    'Precuneus'}
save('/Users/aidasaglinskas/Desktop/lbls_alphabetical.mat','lbls')