fn.SPM_temp = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/S%d/Analysis/SPM.mat';
fn.groupSPM_words = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_words/Group_Analysis_subconst/SPM.mat';
fn.groupSPM_faces = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/Group_Analysis_subconst/SPM.mat';
fn.groupN42 = '/Users/aidasaglinskas/Google Drive/Aidas:  Summaries & Analyses (WP 1.4)/Data_faces/New42_Group/Group_anal_removeFUnky_m-3_s8n40ex/SPM.mat';
fn.sections_fn = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii';
fn.rend = '/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/cortex_20484.surf.gii'
i = i+1
subvect.word = [1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
subID = subvect.word(i);
fn.SPM = sprintf(fn.SPM_temp,subID);
%%
clear SPM;load(fn.groupN42);
xSPM = SPM;
    xSPM.Ic= 1; % Which contrast
xSPM.Im= {};xSPM.Ex=0;%{mask.grey}    %{mask.cutpSTS};
xSPM.title=SPM.xCon(xSPM.Ic).name;
    xSPM.thresDesc='FWE';
    xSPM.u= .05;
    xSPM.k= 0;
[hReg,xSPM,SPM] = spm_results_ui('Setup',[xSPM]) % SPM GUI
spm_sections(xSPM,hReg,fn.sections_fn) %SECTIONS
%spm_render(xSPM,nan,fn.rend)
if ~exist('H');H = spm_mesh_render(fn.rend);end
spm_mesh_render('overlay',H,xSPM)
%spm_mesh_render('clim',H,[-100 100])
disp(subID)
%%
%spm_mesh_inflate(H.patch,5,0)
%%
i = i+1
c = mc.coords(i,:)
clc;
spm_mip_ui('SetCoords',c);
disp(mc.names{i})
%%
fast_save_fig