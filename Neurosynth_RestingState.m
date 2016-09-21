NeuroSynth_dir = '/Users/aidasaglinskas/Google Drive/Neurosynth/';
ROI_dir = '/Users/aidasaglinskas/Google Drive/MRI_data/ROIS/';
NeuroSynth_fls = dir([NeuroSynth_dir '*.nii']);NeuroSynth_fls = {NeuroSynth_fls.name}';
ROI_fls = dir([ROI_dir '*.nii']);ROI_fls = {ROI_fls.name}';
%%
%xFiles={'myNeuropStsL.nii','myNeuropStsR.nii' etc
xFiles = cellfun(@(x) fullfile(NeuroSynth_dir,x),NeuroSynth_fls,'UniformOutput',0);
regFile = cellfun(@(x) fullfile(ROI_dir,x),ROI_fls,'UniformOutput',0);
%regFile={marsbar made images for pStsL, pStsR etc?
%%
nRegoins=18
for ii = 1:nRegoins
connect=nifti(xFiles{ii})  % load the neuro file for the Left pSTS
connect=connect.dat;%(:,:,:)
for jj=ii+1:nRegions
    mask=nifit(refFile{jj}) ;
    mask=mask.dat;%(:,:,:)
    outPut(ii,jj)=mean(connect(mask));
end
end

    