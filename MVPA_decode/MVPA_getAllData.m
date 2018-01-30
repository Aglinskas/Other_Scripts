tic
voxel_data = {};
masks.list = arrayfun(@(x) [num2str(x,'%.2i') ': ' masks.lbls{x}],1:length(masks.lbls),'UniformOutput',0)'
for exp_ind = 1:2
for m_ind = 1:21
    voxel_data{m_ind,exp_ind} = func_MVPA_getVoxelData(m_ind,exp_ind);
    save('/Users/aidasaglinskas/Desktop/voxel_data.mat','voxel_data','m_ind','exp_ind')
end
end
toc