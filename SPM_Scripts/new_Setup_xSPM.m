%clear;

% 
temp.SPM_fn = '/Users/aidasaglinskas/Desktop/Raw_Data/Words_expData/S%d/Analysis/SPM.mat';
temp.sections_fn = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii'

i = i+1
subID = i; % 4
clear SPM;
spm('defaults','FMRI')
%arrayfun(@(x) ['Con ' num2str(x),':' SPM.xCon(x).name],1:length(SPM.xCon),'UniformOutput',0)'
load('/Users/aidasaglinskas/Desktop/Raw_Data/Words_expData/Group_Analysis/SPM.mat')
xSPM = SPM;
xSPM.Ic=3;
xSPM.Ex=0;
xSPM.Im=[];
xSPM.title=SPM.xCon(xSPM.Ic).name;
xSPM.thresDesc='none';
xSPM.u= .999;
xSPM.k=0;

[hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % SPM GUI
spm_sections(xSPM,hReg,temp.sections_fn) %SECTIONS

spm_mip_ui('setcoords',[6    57   -23])

y=spm_mip_ui('Extract', 'y', 'voxel')


hReg.Position = [0.0093    0.0197    0.9817    0.9597]