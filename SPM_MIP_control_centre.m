SPM_fn = '/Users/aidasaglinskas/Google Drive/Data/Group_analysis12t/SPM.mat';
t1_fn = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii';
load(SPM_fn)


useContrast = 4;
% {SPM.xCon.name}'
 xSPM=SPM;
    xSPM.Ic=useContrast;
    xSPM.Im=0;
    xSPM.Ex=0;
    xSPM.Im=[];
    xSPM.title=SPM.xCon(useContrast).name;
    xSPM.thresDesc='none'; % none or FWE
    xSPM.u= .05; % 001 .004
    xSPM.k=33; % 33
    disp(SPM.xCon(useContrast).name)
    [hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % Sets up results
    spm_sections(xSPM,hReg,t1_fn) % overlays section
%%
figure(1)
coords = [33 -10 -40]
%mip = spm_mip_ui('FindMIPax');

spm_mip_ui('SetCoords',coords);
%spm_mip_ui('jump',spm_mip_ui('FindMIPax'),'glmax')
%'nrmax' - nearest local maximum
Y = spm_mip_ui('Extract','Y','voxel')
%size(Y)
r = reshape(Y,12,20); %r = reshape(Y, N_CONDS , N_SUBS );
r_mean = mean(r,2); % means across subjects
figure(7);
bar(r_mean) %plot it's

