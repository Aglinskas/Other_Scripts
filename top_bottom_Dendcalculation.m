which_rois = [1,4,17,7]
size(keep)

rFFA_lFFA = keep(:,1,4)
%%
top = 1-[keep(:,1,7) keep(:,17) keep(:,4,7) keep(:,4,17)]
bottom = 1-[keep(:,1,4) keep(:,7,17)]

vals=[mean(top') -  mean(bottom') ]'
mean(vals)./(std(vals)/20^.5)

%%
cd /Volumes/Aidas_HDD/MRI_data/
load('submats_MVPA.mat')
load('subvect.mat')
load('roi_names.mat')
size(submats)
subvect
which_rois_to_cor = 2:20
singmat = squeeze(mean(submats(which_rois_to_cor,subvect,:,:),2));
size(singmat)