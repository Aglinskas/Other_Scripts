clc;addpath('/Users/aidasaglinskas/Desktop/Other_Scripts/MVPA_decode/')
res = {};
for m_ind = 1:21;
for exp_ind = 1:2;
all_scans = struct;
all_scans = func_MVPA_getVoxelData(m_ind,exp_ind);
rfx_mat = func_MVPA_decode(all_scans);
res{exp_ind}(:,:,m_ind,:) = rfx_mat;
save('/Users/aidasaglinskas/Desktop/decoding.mat','res')
end
end