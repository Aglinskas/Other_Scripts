%%
opts_xSPM.mask_which_mask_ind = 3;
opts_xSPM.p_tresh = 0.999
opts_xSPM.k_extent = 10
opts_xSPM.MC_correction = 'none'
set_up_xSPM
%%
A = spm_clusters(xSPM.XYZ);
clust = unique(spm_clusters(xSPM.XYZ));
atlas = fullfile('/Users/aidas_el_cap/Documents/MATLAB/spm12/tpm/','labels_Neuromorphometrics.nii');
xA = spm_atlas('load',atlas);
%%
for c = clust
c_inds = find(A == c);
peak_ind = c_inds(find(xSPM.Z(:,c_inds) == max(xSPM.Z(:,c_inds))));
coord = xSPM.XYZmm(:,peak_ind);
%
spm_results_ui('setcoords',coord);%[ 39, -19,  55]);%[-18, -91,  -5]);%[ 63, -22,   1]);%[44 -46 -16]);%[ 63, -22,   1]);%[-21,  -7, -14])% [44 -46 -16]);%[57, -13,   1]);%[3 -64 30] 
    XYZmm= spm_mip_ui('Jump',hMIPax,'nrvox');%glmax/nrmax
cor_labels(c).cluster = c;
cand_lbls = spm_atlas('query',xA,xSPM.XYZmm(:,c_inds))';
cor_labels(c).all_names = cand_lbls;
srt = strsplit(cand_lbls{1});
cor_labels(c).short_name = [srt{1} ' ' srt{2}];
cor_labels(c).coords = coord;
%spm_atlas('query',xA,coord)
['clust ' num2str(c) ' ' cor_labels(c).short_name]
end

%%
for c = 20
spm_results_ui('setcoords',[master_coords{c,2:4}]);
[master_coords{c,2:4}]
master_coords{c}
KbWait(-1)
end





