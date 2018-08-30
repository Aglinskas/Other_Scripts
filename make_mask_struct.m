function mask = make_mask_struct(mfn)
% gets the masks from a folder
%function mask = make_mask_struct(mfn)
%mask.dir = '/Users/aidasaglinskas/Desktop/testR/';
mask.dir = mfn
temp = dir([mask.dir 'trimROI*.nii']);
mask.filenames = {temp.name}';
mask.lbls = strrep(mask.filenames,'trimROI_','');
mask.lbls = strrep(mask.lbls,'.nii','');
%vx.r_labels = mask.lbls;
%vx.list_r = arrayfun(@(x) [num2str(x,'%.2i') ': ' vx.r_labels{x}],1:length(mask.lbls),'UniformOutput',0)';
end