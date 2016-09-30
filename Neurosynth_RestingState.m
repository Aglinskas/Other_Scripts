NeuroSynth_dir = '/Users/aidasaglinskas/Google Drive/Neurosynth/';
ROI_dir = '/Users/aidasaglinskas/Google Drive/MRI_data/ROIS/';
NeuroSynth_fls = dir([NeuroSynth_dir 'r*.nii']);NeuroSynth_fls = {NeuroSynth_fls.name}';
ROI_fls = dir([ROI_dir '*.nii']);ROI_fls = {ROI_fls.name}';
%%
%xFiles={'myNeuropStsL.nii','myNeuropStsR.nii' etc
xFiles = cellfun(@(x) fullfile(NeuroSynth_dir,x),NeuroSynth_fls,'UniformOutput',0);
regFile = cellfun(@(x) fullfile(ROI_dir,x),ROI_fls,'UniformOutput',0);
%regFile={marsbar made images for pStsL, pStsR etc?
%%
loadMR
nRegions=18
outPut = repmat(NaN,18); % Preallocate or reset
for ii = 1:nRegions
connect_prime=nifti(xFiles{ii});  % load the neuro file for the Left pSTS
%connect=connect.dat;%(:,:,:)
connect = connect_prime.dat(:);
for jj=ii:nRegions % jj=ii+1:nRegions %
    mask_prime=nifti(regFile{jj});
    %mask=mask.dat;%(:,:,:)
    mask=mask_prime.dat(:);
    outPut(ii,jj)=mean(connect(mask>0));
    outPut(jj,ii)=mean(connect(mask>0));
end
end
n = figure(7)
add_numbers_to_mat(outPut(ord,ord),masks_name(ord))
n.CurrentAxes.YTickLabel = cellfun(@(x) strrep(x,'_','-'),NeuroSynth_fls(ord),'UniformOutput',0);
n.CurrentAxes.XTickLabel = cellfun(@(x) strrep(x,'_','-'),ROI_fls(ord),'UniformOutput',0);
n.CurrentAxes.FontSize = 12;
%%
% newVec = get_triu(outPut);
% Z = linkage(1-newVec,'ward')
% d = figure(9)
% [h x] = dendrogram(Z,'labels',masks_name,'orientation','left','colorthreshold',1.21)
% [h(1:end).LineWidth] = deal(3)
% d.CurrentAxes.FontSize = 14
