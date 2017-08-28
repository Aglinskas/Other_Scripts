fn_temp = '/Users/aidasaglinskas/Desktop/MasksCheck/%s.nii';
inds_str = {'nom_new'
'phys_new'
'soc_new'
'fact_new'
'ep_new'};
%lbls = {'Episodic' 'Factual' 'Social' 'Physical' 'Nominal'}
ds = cosmo_fmri_dataset(sprintf(fn_temp,inds_str{1}));
ds.samples(isnan(ds.samples)) = 0;
ds.samples(1:end) = 0;
thresh = 3.126;
for i = 1:5
a = cosmo_fmri_dataset(sprintf(fn_temp,inds_str{i}));
a.samples(a.samples<thresh) = 0; %threshold
a.samples(isnan(a.samples)) = 0;
a.samples(find(a.samples)) = 1;
ds.samples(i,find(a.samples)) = i;
end
%%
imagesc(ds.samples);
u = {};
merge = [];
for i = 1:length(ds.samples)
uv = unique(ds.samples(:,i));
if length(uv) == 1
merge(1,i) = uv;
elseif length(uv) == 2
merge(1,i) = uv(uv~=0);
else
merge(1,i) = 6; % code for multiple things
end
end
ds.samples = merge;
%cosmo_map2fmri(dataset, fn) saves dataset to a volumetric file.
ofn = '/Users/aidasaglinskas/Desktop/MasksCheck/combined_SPMT.nii';
cosmo_map2fmri(ds,ofn);
%%
f = figure(2)
uv = unique(ds.samples);
box off
imagesc(uv')
lbls = {'Episodic'    'Factual'    'Social'    'Physical'    'Nominal'}
colormap('hsv')
disp('done')
%%
ofn = '/Users/aidasaglinskas/Desktop/fig';
savefig(r,ofn)