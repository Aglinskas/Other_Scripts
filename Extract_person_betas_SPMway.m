loadMR
%%
SPM_path_temp = '/Users/aidasaglinskas/Google Drive/Data/S%d/Analysisall_faces/SPM.mat';
s_ind = 1;


subID = subvect(s_ind)

clear SPM
SPM_path = sprintf(SPM_path_temp,subID)
load(SPM_path)

xSPM = SPM;
 xSPM=SPM;
    xSPM.Ic=1;
    xSPM.Im=1;
    xSPM.Ex=0;
    xSPM.Im=[];
    xSPM.title='singleSubROI';
    xSPM.thresDesc='none';
    xSPM.u=thresh;
    xSPM.k=initialExtent;
   
%%
[hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM])

